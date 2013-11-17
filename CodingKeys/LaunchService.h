#import <Foundation/Foundation.h>

@interface LaunchService : NSObject

+ (instancetype)sharedService;

- (void)launchAtStartup:(BOOL)enabled;
- (BOOL)isLaunchedAtStartup;

@end