#import "KeyCodeConverter.h"
#import <Carbon/Carbon.h>

@implementation KeyCodeConverter

+ (int)toKeyCode:(NSString *)character {
    return keyCodeForChar([[character lowercaseString] characterAtIndex:0]);
}

// Mapping from https://github.com/davedelong/DDHotKey/

+ (NSDictionary *)fixKeys {
    static NSDictionary *keyCodeMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keyCodeMap = @{
                       @"↩":@(kVK_Return),
                       @"⇥":@(kVK_Tab),
                       @"⎵":@(kVK_Space),
                       @"⌫":@(kVK_Delete),
                       @"⎋":@(kVK_Escape),
                       @"⌘":@(kVK_Command),
                       @"⇧":@(kVK_Shift),
                       @"⇪":@(kVK_CapsLock),
                       @"⌥":@(kVK_Option),
                       @"⌃":@(kVK_Control),
                       @"⇧":@(kVK_RightShift),
                       @"⌥":@(kVK_RightOption),
                       @"⌃":@(kVK_RightControl),
                       @"🔊":@(kVK_VolumeUp),
                       @"🔈":@(kVK_VolumeDown),
                       @"🔇":@(kVK_Mute),
                       @"\u2318":@(kVK_Function),
                       @"F1":@(kVK_F1),
                       @"F2":@(kVK_F2),
                       @"F3":@(kVK_F3),
                       @"F4":@(kVK_F4),
                       @"F5":@(kVK_F5),
                       @"F6":@(kVK_F6),
                       @"F7":@(kVK_F7),
                       @"F8":@(kVK_F8),
                       @"F9":@(kVK_F9),
                       @"F10":@(kVK_F10),
                       @"F11":@(kVK_F11),
                       @"F12":@(kVK_F12),
                       @"F13":@(kVK_F13),
                       @"F14":@(kVK_F14),
                       @"F15":@(kVK_F15),
                       @"F16":@(kVK_F16),
                       @"F17":@(kVK_F17),
                       @"F18":@(kVK_F18),
                       @"F19":@(kVK_F19),
                       @"F20":@(kVK_F20),
                       @"⌦":@(kVK_ForwardDelete),
                       @"↖":@(kVK_Home),
                       @"↘":@(kVK_End),
                       @"⇞":@(kVK_PageUp),
                       @"⇟":@(kVK_PageDown),
                       @"←":@(kVK_LeftArrow),
                       @"→":@(kVK_RightArrow),
                       @"↓":@(kVK_DownArrow),
                       @"↑":@(kVK_UpArrow)
                       };
    });
    
    return keyCodeMap;
}

// Uses code from: http://stackoverflow.com/questions/1918841/how-to-convert-ascii-character-to-cgkeycode

static CGKeyCode keyCodeForChar(const char c) {
    static CFMutableDictionaryRef charToCodeDict = NULL;
    CGKeyCode code;
    UniChar character = c;
    CFStringRef charStr = NULL;
    
    if (charToCodeDict == NULL) {
        size_t i;
        charToCodeDict = CFDictionaryCreateMutable(kCFAllocatorDefault,
                                                   128,
                                                   &kCFCopyStringDictionaryKeyCallBacks,
                                                   NULL);
        if (charToCodeDict == NULL) return UINT16_MAX;
        
        for (i = 0; i < 128; ++i) {
            CFStringRef string = createStringForKey((CGKeyCode)i);
            if (string != NULL) {
                CFDictionaryAddValue(charToCodeDict, string, (const void *)i);
                CFRelease(string);
            }
        }
    }
    
    charStr = CFStringCreateWithCharacters(kCFAllocatorDefault, &character, 1);
    
    if (!CFDictionaryGetValueIfPresent(charToCodeDict, charStr, (const void **)&code)) {
        code = UINT16_MAX;
    }
    
    CFRelease(charStr);
    
    return code;
}

static CFStringRef createStringForKey(CGKeyCode keyCode) {
    TISInputSourceRef currentKeyboard = TISCopyCurrentKeyboardInputSource();
    CFDataRef layoutData = TISGetInputSourceProperty(currentKeyboard,
                                                     kTISPropertyUnicodeKeyLayoutData);
    
    const UCKeyboardLayout *keyboardLayout = (const UCKeyboardLayout *)CFDataGetBytePtr(layoutData);
    
    UInt32 keysDown = 0;
    UniChar chars[4];
    UniCharCount realLength;
    
    UCKeyTranslate(keyboardLayout,
                   keyCode,
                   kUCKeyActionDisplay,
                   0,
                   LMGetKbdType(),
                   kUCKeyTranslateNoDeadKeysBit,
                   &keysDown,
                   sizeof(chars) / sizeof(chars[0]),
                   &realLength,
                   chars);
    CFRelease(currentKeyboard);
    
    return CFStringCreateWithCharacters(kCFAllocatorDefault, chars, 1);
}

@end