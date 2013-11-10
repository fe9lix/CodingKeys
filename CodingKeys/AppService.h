#import <Foundation/Foundation.h>

@interface AppService : NSObject

+ (AppService *)sharedService;

- (BOOL)isAppRegistered:(NSString *)appName;
- (NSArray *)hotKeysForAppWithName:(NSString *)appName;

@end