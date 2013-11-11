#import "AppService.h"
#import "HotKey.h"

static NSString * const KeysFileName = @"keys";
static NSString * const AboutURL = @"https://github.com/fe9lix/CodingKeys";

NSString * const AppServiceDidChangeHotKeys = @"AppServiceDidChangeHotKeys";

@interface AppService () <NSFilePresenter>

@property (nonatomic, strong) NSDictionary *hotKeysForAppName;
@property (nonatomic, strong) NSFileCoordinator *fileCoordinator;
@property (strong) NSURL *presentedItemURL;
@property (strong) NSOperationQueue *presentedItemOperationQueue;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AppService

+ (AppService *)sharedService {
    static AppService *sharedService = nil;
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
    [self setupHotKeysForAppName];
    [self watchKeyFile];
}

- (void)setupHotKeysForAppName {
    NSArray *keyMappings = [self loadKeyMappingsFile];
    
    NSMutableDictionary *hotKeysForAppName = [NSMutableDictionary dictionary];
    
    for (NSDictionary *keyMapping in keyMappings) {
        NSString *key = keyMapping[@"key"];
        NSDictionary *mapping = keyMapping[@"mapping"];
        
        HotKey *hotKey = [[HotKey alloc] initWithKey:key
                                             mapping:mapping];
        
        for (NSString *appName in mapping) {
            if (!hotKeysForAppName[appName]) {
                hotKeysForAppName[appName] = [NSMutableArray array];
            }
            NSString *mappedKey = mapping[appName];
            if (![mappedKey isEqualToString:key]) {
                [hotKeysForAppName[appName] addObject:hotKey];
            }
        }
    }
    
    self.hotKeysForAppName = hotKeysForAppName;
}

- (NSArray *)loadKeyMappingsFile {
    NSError *error;
    NSString *jsonString = [NSString stringWithContentsOfFile:[self keysFilePath]
                                                     encoding:NSUTF8StringEncoding
                                                        error:&error];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [NSJSONSerialization JSONObjectWithData:jsonData
                                           options:0
                                             error:nil];
}

- (NSString *)keysFilePath {
    return [[NSBundle mainBundle] pathForResource:KeysFileName
                                           ofType:@"json"];
}

- (void)watchKeyFile {
    self.presentedItemOperationQueue = [[NSOperationQueue alloc] init];
    self.presentedItemOperationQueue.maxConcurrentOperationCount = 1;
    
    self.presentedItemURL = [[NSBundle mainBundle] resourceURL];
    
    self.fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:self];
    
    [NSFileCoordinator addFilePresenter:self];
}

- (void)presentedItemDidChange {
    [self.timer invalidate];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                      target:self
                                                    selector:@selector(keysDidChange:)
                                                    userInfo:nil
                                                     repeats:NO];
    });
}

- (void)keysDidChange:(id)obj {
    [self setupHotKeysForAppName];
    [self dispatchKeysDidChangeNotification];
}

- (void)dispatchKeysDidChangeNotification {
    NSNotification *notification = [NSNotification notificationWithName:AppServiceDidChangeHotKeys
                                                                 object:nil
                                                               userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (BOOL)isAppRegistered:(NSString *)appName {
    return self.hotKeysForAppName[appName] != nil;
}

- (NSArray *)hotKeysForAppWithName:(NSString *)appName {
    return self.hotKeysForAppName[appName];
}

- (void)openKeyMappings {
    [[NSWorkspace sharedWorkspace] openFile:[self keysFilePath]];
}

- (void)openAboutURL {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:AboutURL]];
}

@end