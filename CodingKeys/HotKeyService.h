#import <Foundation/Foundation.h>

extern NSString * const HotKeyHandlerDidTriggerHotKey;

@class HotKey;

@interface HotKeyService : NSObject

+ (instancetype)sharedService;

- (HotKey *)registerHotKey:(HotKey *)hotKey;
- (void)unregisterAllHotKeys;
- (void)dispatchKeyEventsForHotKeys:(NSArray *)hotKeys;

@end