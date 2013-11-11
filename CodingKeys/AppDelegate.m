#import "AppDelegate.h"
#import "AppService.h"
#import "HotKeyService.h"
#import "HotKey.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSMenu *statusMenu;
@property (strong) NSStatusItem *statusItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self setup];
}

- (void)awakeFromNib {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.menu = self.statusMenu;
    self.statusItem.title = @"CodingKeys";
    //self.statusItem.image = [NSImage imageNamed:@"imageName"];
    self.statusItem.highlightMode = YES;
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

- (IBAction)settingsClicked:(id)sender {
    [[AppService sharedService] openKeyMappings];
}

- (IBAction)aboutClicked:(id)sender {
    [[AppService sharedService] openAboutURL];
}

- (IBAction)quitClicked:(id)sender {
    [NSApp terminate:self];
}

@end