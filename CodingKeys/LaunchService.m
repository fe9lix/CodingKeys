#import "LaunchService.h"

// Based on code from:
// http://bdunagan.com/2010/09/25/cocoa-tip-enabling-launch-on-startup/
// https://github.com/Mozketo/LaunchAtLoginController/blob/master/LaunchAtLoginController.m

@implementation LaunchService

+ (LaunchService *)sharedService {
    static LaunchService *sharedService = nil;
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
    
}

- (void)launchAtStartup:(BOOL)enabled {
    LSSharedFileListRef listRef = LSSharedFileListCreate(NULL,
                                                         kLSSharedFileListSessionLoginItems,
                                                         NULL);
    if (listRef == nil) {
        return;
    }
    
    LSSharedFileListItemRef itemRef;
    
    if (enabled) {
        itemRef = LSSharedFileListInsertItemURL(listRef,
                                                kLSSharedFileListItemLast,
                                                NULL,
                                                NULL,
                                                (__bridge CFURLRef)[self appURL],
                                                NULL,
                                                NULL);
    } else {
        itemRef = [self findLoginItem];
        if (itemRef) {
            LSSharedFileListItemRemove(listRef, itemRef);
        }
    }
    
    if (itemRef != nil) {
        CFRelease(itemRef);
    }
    
    CFRelease(listRef);
}

- (BOOL)isLaunchedAtStartup {
    LSSharedFileListItemRef itemRef = [self findLoginItem];
    BOOL isInList = itemRef != nil;
    if (itemRef != nil) {
        CFRelease(itemRef);
    }
    
    return isInList;
}

- (LSSharedFileListItemRef)findLoginItem {
    CFURLRef appURLRef = (__bridge CFURLRef)[self appURL];
    
    LSSharedFileListRef listRef = LSSharedFileListCreate(NULL,
                                                         kLSSharedFileListSessionLoginItems,
                                                         NULL);
    if (listRef == nil) {
        return nil;
    }
    
    NSArray *loginItems = (__bridge NSArray *)LSSharedFileListCopySnapshot(listRef, nil);
    
    for (int i = 0; i < [loginItems count]; i++) {
        LSSharedFileListItemRef currentItemRef = (__bridge LSSharedFileListItemRef)loginItems[i];
        UInt32 resolutionFlags = kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes;
        CFURLRef currentItemURLRef = NULL;
        
        LSSharedFileListItemResolve(currentItemRef, resolutionFlags, &currentItemURLRef, NULL);
        
        if (currentItemURLRef && CFEqual(currentItemURLRef, appURLRef)) {
            CFRelease(currentItemURLRef);
            CFRelease(listRef);
            return currentItemRef;
        }
        if (currentItemURLRef) {
            CFRelease(currentItemURLRef);
        }
    }
    
    CFRelease(listRef);
    
    return nil;
}

- (NSURL *)appURL {
    return [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
}

@end