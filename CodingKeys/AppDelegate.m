#import "AppDelegate.h"
#import "AppService.h"
#import "HotKeyService.h"
#import "HotKey.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self setup];
}

- (void)setup {
    [self setupNotifications];
    [self setupHotKeyService];
}

- (void)setupNotifications {
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(didActivateApplication:)
                                                               name:NSWorkspaceDidActivateApplicationNotification
                                                             object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didTriggerHotKey:)
                                                 name:HotKeyHandlerDidTriggerHotKey
                                               object:nil];
}

- (void)setupHotKeyService {
    
}

- (void)didActivateApplication:(NSNotification *)notification {
    [self unregisterHotKeys];
    
    NSString *activeAppName = [self activeApplicationName];
    
    if ([[AppService sharedService] isAppRegistered:activeAppName]) {
        [self registerHotKeysForApp:activeAppName];
    }
}

- (void)registerHotKeysForApp:(NSString *)app {
    HotKeyService *hotKeyService = [HotKeyService sharedService];
    
    NSArray *hotKeys = [[AppService sharedService] hotKeysForAppWithName:app];
    for (HotKey *hotKey in hotKeys) {
        [hotKeyService registerHotKey:hotKey];
    }
}

- (void)unregisterHotKeys {
    [[HotKeyService sharedService] unregisterAllHotKeys];
}

- (NSString *)activeApplicationName {
    NSDictionary *activeApp = [[NSWorkspace sharedWorkspace] activeApplication];
    return (NSString *)[activeApp objectForKey:@"NSApplicationName"];
}

- (void)didTriggerHotKey:(NSNotification *)notification {
    HotKey *hotKey = notification.userInfo[@"hotKey"];
    
    HotKey *mappedHotKey = [hotKey mappedHotKeyForAppWithName:[self activeApplicationName]];
    if (!mappedHotKey || ([hotKey isEqual:mappedHotKey])) {
        return;
    }
    
    [[HotKeyService sharedService] dispatchKeyEventForHotKey:mappedHotKey];
}

@end