#import "HotKeyService.h"
#import <Carbon/Carbon.h>
#import "HotKey.h"

NSString * const HotKeyHandlerDidTriggerHotKey = @"HotKeyHandlerDidTriggerHotKey";

@interface HotKeyService ()

@property (nonatomic, strong) NSMutableDictionary *hotKeys;

@end

@implementation HotKeyService

static id this;

+ (HotKeyService *)sharedService {
    static HotKeyService *sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedService = [[self alloc] init];
    });
    return sharedService;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    this = self;
    
    self.hotKeys = [NSMutableDictionary dictionary];
    
    [self installHotKeyHandler];
}

- (void)installHotKeyHandler {
    EventTypeSpec eventType;
    eventType.eventClass = kEventClassKeyboard;
    eventType.eventKind = kEventHotKeyPressed;
    
    InstallApplicationEventHandler(&hotKeyHandler,
                                   1,
                                   &eventType,
                                   NULL,
                                   NULL);
}

- (HotKey *)registerHotKey:(HotKey *)hotKey {
    hotKey.keyID = (int)[self.hotKeys count] + 1;
    
    EventHotKeyID hotKeyID;
    hotKeyID.signature = 'cdk1';
    hotKeyID.id = hotKey.keyID;
    
    EventHotKeyRef hotKeyRef;
    OSStatus err = RegisterEventHotKey(hotKey.keyCode,
                                       hotKey.carbonModifiers,
                                       hotKeyID,
                                       GetApplicationEventTarget(),
                                       0,
                                       &hotKeyRef);
    
    if (err != 0) {
        return nil;
    }
    
    hotKey.value = [NSValue valueWithPointer:hotKeyRef];
    
    self.hotKeys[@(hotKey.keyID)] = hotKey;
    
    return hotKey;
}

- (HotKey *)findHotKeyByID:(int)keyID {
    return self.hotKeys[@(keyID)];
}

static OSStatus hotKeyHandler(EventHandlerCallRef nextHandler,
                              EventRef theEvent,
                              void *userData) {

    EventHotKeyID hotKeyID;
    GetEventParameter(theEvent,
                      kEventParamDirectObject,
                      typeEventHotKeyID,
                      NULL,
                      sizeof(hotKeyID),
                      NULL,
                      &hotKeyID);
    
    UInt32 keyID = hotKeyID.id;
    
    HotKey *hotKey = [this findHotKeyByID:keyID];
    
    [this dispatchNotificationForHotKey:hotKey];
    
    return noErr;
}

- (void)dispatchNotificationForHotKey:(HotKey *)hotKey {
    NSNotification *notification = [NSNotification notificationWithName:HotKeyHandlerDidTriggerHotKey
                                                                 object:nil
                                                               userInfo:@{@"hotKey":hotKey}];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)unregisterAllHotKeys {
    NSDictionary *hotKeys = [self.hotKeys copy];
    for (id keyID in hotKeys) {
        [self unregisterHotKey:hotKeys[keyID]];
    }
}

- (void)unregisterHotKey:(HotKey *)hotKey {
    EventHotKeyRef hotKeyRef = (EventHotKeyRef)[hotKey.value pointerValue];
    UnregisterEventHotKey(hotKeyRef);
    hotKey.value = nil;
    [self.hotKeys removeObjectForKey:@(hotKey.keyID)];
}

- (void)dispatchKeyEventsForHotKeys:(NSArray *)hotKeys {
    ProcessSerialNumber processSerialNumber;
    GetFrontProcess(&processSerialNumber);
    
    CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateHIDSystemState);
    
    for (int i = 0; i < [hotKeys count]; i++) {
        HotKey *hotKey = hotKeys[i];
        
        CGEventRef ev;
        ev = CGEventCreateKeyboardEvent(source, (CGKeyCode)hotKey.keyCode, true);
        CGEventSetFlags(ev, hotKey.modifiers);
        CGEventPostToPSN(&processSerialNumber, ev);
        CFRelease(ev);
    }
    
    CFRelease(source);
}

@end