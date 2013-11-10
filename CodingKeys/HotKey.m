#import "HotKey.h"
#import <Carbon/Carbon.h>

@interface HotKey ()

@property (nonatomic, copy, readwrite) NSString *key;
@property (nonatomic, strong, readwrite) NSDictionary *mapping;
@property (nonatomic, readwrite) int keyCode;
@property (nonatomic, readwrite) int modifiers;
@property (nonatomic, readwrite) int carbonModifiers;

@end

@implementation HotKey

// Mapping from https://github.com/davedelong/DDHotKey/

+ (NSDictionary *)keyMapping {
    static NSDictionary *keyCodeMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keyCodeMap = @{
                       @"↩":@(kVK_Return),
                       @"⇥":@(kVK_Tab),
                       @"⎵":@(kVK_Space),
                       @"⌫":@(kVK_Delete),
                       @"⎋":@(kVK_Escape),
                       @"⌘":@(kVK_Command),
                       @"⇧":@(kVK_Shift),
                       @"⇪":@(kVK_CapsLock),
                       @"⌥":@(kVK_Option),
                       @"⌃":@(kVK_Control),
                       @"⇧":@(kVK_RightShift),
                       @"⌥":@(kVK_RightOption),
                       @"⌃":@(kVK_RightControl),
                       @"🔊":@(kVK_VolumeUp),
                       @"🔈":@(kVK_VolumeDown),
                       @"🔇":@(kVK_Mute),
                       @"\u2318":@(kVK_Function),
                       @"F1":@(kVK_F1),
                       @"F2":@(kVK_F2),
                       @"F3":@(kVK_F3),
                       @"F4":@(kVK_F4),
                       @"F5":@(kVK_F5),
                       @"F6":@(kVK_F6),
                       @"F7":@(kVK_F7),
                       @"F8":@(kVK_F8),
                       @"F9":@(kVK_F9),
                       @"F10":@(kVK_F10),
                       @"F11":@(kVK_F11),
                       @"F12":@(kVK_F12),
                       @"F13":@(kVK_F13),
                       @"F14":@(kVK_F14),
                       @"F15":@(kVK_F15),
                       @"F16":@(kVK_F16),
                       @"F17":@(kVK_F17),
                       @"F18":@(kVK_F18),
                       @"F19":@(kVK_F19),
                       @"F20":@(kVK_F20),
                       @"⌦":@(kVK_ForwardDelete),
                       @"↖":@(kVK_Home),
                       @"↘":@(kVK_End),
                       @"⇞":@(kVK_PageUp),
                       @"⇟":@(kVK_PageDown),
                       @"←":@(kVK_LeftArrow),
                       @"→":@(kVK_RightArrow),
                       @"↓":@(kVK_DownArrow),
                       @"↑":@(kVK_UpArrow)
                       };
    });
    
    return keyCodeMap;
}

- (id)initWithKey:(NSString *)key mapping:(NSDictionary *)mapping {
    self = [super init];
    if (self) {
        _key = key;
        _mapping = mapping;
        [self setup];
    }
    return self;
}

- (void)setup {
    [self parseKey];
}

- (void)parseKey {
    NSDictionary *keyMapping = [[self class] keyMapping];
    
    NSArray *components = [self.key componentsSeparatedByString:@" "];
    
    int modifiers = 0;
    int carbonModifiers = 0;
    
    for (NSString *component in components) {
        int keyCode = [keyMapping[component] intValue];

        switch (keyCode) {
            case kVK_Shift:
                modifiers |= kCGEventFlagMaskShift;
                carbonModifiers |= shiftKey;
                break;
            case kVK_Control:
                modifiers |= kCGEventFlagMaskControl;
                carbonModifiers |= controlKey;
                break;
            case kVK_Option:
                modifiers |= kCGEventFlagMaskAlternate;
                carbonModifiers |= optionKey;
                break;
            case kVK_Command:
                modifiers |= kCGEventFlagMaskCommand;
                carbonModifiers |= cmdKey;
                break;
            default:
                self.keyCode = keyCode;
                break;
        }
    }
    
    self.modifiers = modifiers;
    self.carbonModifiers = carbonModifiers;
}

- (HotKey *)mappedHotKeyForAppWithName:(NSString *)appName {
    NSString *mappedKey = self.mapping[appName];
    return [[HotKey alloc] initWithKey:mappedKey mapping:nil];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"key: %@, keyCode: %d, modifiers: %d, mapping: %@",
            self.key, self.keyCode, self.modifiers, self.mapping];
}

- (NSUInteger)hash {
    return self.keyCode ^ self.modifiers;
}

- (BOOL)isEqual:(id)object {
    BOOL equal = NO;
    if ([object isKindOfClass:[HotKey class]]) {
        HotKey *hotKey = (HotKey *)object;
        equal = (hotKey.keyCode == self.keyCode);
        equal &= (hotKey.modifiers == self.modifiers);
    }
    return equal;
}

@end