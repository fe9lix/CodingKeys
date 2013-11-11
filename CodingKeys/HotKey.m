#import "HotKey.h"
#import "KeyCodeConverter.h"
#import <Carbon/Carbon.h>

@interface HotKey ()

@property (nonatomic, copy, readwrite) NSString *key;
@property (nonatomic, strong, readwrite) NSDictionary *mapping;
@property (nonatomic, readwrite) int keyCode;
@property (nonatomic, readwrite) int modifiers;
@property (nonatomic, readwrite) int carbonModifiers;

@end

@implementation HotKey

- (id)initWithKey:(NSString *)key mapping:(NSDictionary *)mapping {
    self = [super init];
    if (self) {
        _key = key;
        _mapping = mapping;
        [self setup];
    }
    return self;
}

- (void)setup {
    [self parseKey];
}

- (void)parseKey {
    NSDictionary *fixKeys = [KeyCodeConverter fixKeys];
    
    NSArray *components = [self.key componentsSeparatedByString:@" "];
    
    int modifiers = 0;
    int carbonModifiers = 0;
    
    for (NSString *component in components) {
        int keyCode = [fixKeys[component] intValue];
        
        switch (keyCode) {
            case kVK_Shift:
                modifiers |= kCGEventFlagMaskShift;
                carbonModifiers |= shiftKey;
                break;
            case kVK_Control:
                modifiers |= kCGEventFlagMaskControl;
                carbonModifiers |= controlKey;
                break;
            case kVK_Option:
                modifiers |= kCGEventFlagMaskAlternate;
                carbonModifiers |= optionKey;
                break;
            case kVK_Command:
                modifiers |= kCGEventFlagMaskCommand;
                carbonModifiers |= cmdKey;
                break;
            default:
                if (fixKeys[component]) {
                    self.keyCode = keyCode;
                } else {
                    self.keyCode = [KeyCodeConverter toKeyCode:component];
                }
                break;
        }
    }
    
    self.modifiers = modifiers;
    self.carbonModifiers = carbonModifiers;
}

- (HotKey *)mappedHotKeyForAppWithName:(NSString *)appName {
    NSString *mappedKey = self.mapping[appName];
    return [[HotKey alloc] initWithKey:mappedKey mapping:nil];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"key: %@, keyCode: %d, modifiers: %d, mapping: %@",
            self.key, self.keyCode, self.modifiers, self.mapping];
}

- (NSUInteger)hash {
    return self.keyCode ^ self.modifiers;
}

- (BOOL)isEqual:(id)object {
    BOOL equal = NO;
    if ([object isKindOfClass:[HotKey class]]) {
        HotKey *hotKey = (HotKey *)object;
        equal = (hotKey.keyCode == self.keyCode);
        equal &= (hotKey.modifiers == self.modifiers);
    }
    return equal;
}

@end