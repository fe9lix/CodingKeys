#import <Foundation/Foundation.h>

@interface HotKey : NSObject

@property (nonatomic, copy, readonly) NSString *key;
@property (nonatomic, strong, readonly) NSDictionary *mapping;
@property (nonatomic, readonly) int keyCode;
@property (nonatomic, readonly) int modifiers;
@property (nonatomic, readonly) int carbonModifiers;
@property (nonatomic) int keyID;
@property (nonatomic, strong) NSValue *value;

- (id)initWithKey:(NSString *)key mapping:(NSDictionary *)mapping;

- (HotKey *)mappedHotKeyForAppWithName:(NSString *)appName;

@end