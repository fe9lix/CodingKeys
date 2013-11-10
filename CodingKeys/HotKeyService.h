#import <Foundation/Foundation.h>

extern NSString * const HotKeyHandlerDidTriggerHotKey;

@class HotKey;

@interface HotKeyService : NSObject

+ (HotKeyService *)sharedService;

- (HotKey *)registerHotKey:(HotKey *)hotKey;
- (void)unregisterAllHotKeys;

- (void)dispatchKeyEventForHotKey:(HotKey *)hotKey;

@end