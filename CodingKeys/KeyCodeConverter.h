#import <Foundation/Foundation.h>

@interface KeyCodeConverter : NSObject

+ (NSDictionary *)fixKeys;

+ (int)toKeyCode:(NSString *)character;

@end