#import <Foundation/Foundation.h>

@interface KeyCodeConverter : NSObject

+ (NSDictionary *)fixKeys;

+ (CGKeyCode)toKeyCode:(NSString *)character;

@end