#import "AppService.h"
#import "HotKey.h"

static NSString * const KeysFileName = @"keys";

@interface AppService ()

@property (nonatomic, strong) NSDictionary *hotKeysForAppName;

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
    NSString *path = [[NSBundle mainBundle] pathForResource:KeysFileName
                                                     ofType:@"json"];
    NSError *error;
    NSString *jsonString = [NSString stringWithContentsOfFile:path
                                                     encoding:NSUTF8StringEncoding
                                                        error:&error];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [NSJSONSerialization JSONObjectWithData:jsonData
                                           options:0
                                             error:nil];
}

- (BOOL)isAppRegistered:(NSString *)appName {
    return self.hotKeysForAppName[appName] != nil;
}

- (NSArray *)hotKeysForAppWithName:(NSString *)appName {
    return self.hotKeysForAppName[appName];
}

@end