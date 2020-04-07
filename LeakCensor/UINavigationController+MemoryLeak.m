//
//  UINavigationController+MemoryLeak.m
//  LeakCensor
//
//  Created by tonbright on 2020/4/3.
//  Copyright © 2020 tonbright. All rights reserved.
//

#import "UINavigationController+MemoryLeak.h"
#import "NSObject+MemoryLeak.h"
#import "objc/runtime.h"

@implementation UINavigationController (MemoryLeak)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSEL:@selector(pushViewController:animated:) withSEL:@selector(swizzled_pushViewController:animated:)];
        
        [self swizzleSEL:@selector(popViewControllerAnimated:) withSEL:@selector(swizzled_popViewControllerAnimated:)];
        
    });
}

- (void)swizzled_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self swizzled_pushViewController:viewController animated:animated];
}

- (UIViewController *)swizzled_popViewControllerAnimated:(BOOL)animated {
    UIViewController *vc = [self swizzled_popViewControllerAnimated:animated];
    if (!vc) {
        return nil;
    }
    extern const void *const kHasBeenPoppedKey;
    objc_setAssociatedObject(vc, kHasBeenPoppedKey, @(YES), OBJC_ASSOCIATION_RETAIN);
    return vc;
}


@end
