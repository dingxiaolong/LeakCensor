//
//  UIViewController+MemoryLead.m
//  LeakCensor
//
//  Created by tonbright on 2020/3/31.
//  Copyright © 2020 tonbright. All rights reserved.
//

#import "UIViewController+MemoryLead.h"
#import <objc/runtime.h>
#import "NSObject+MemoryLeak.h"

const void *const kHasBeenPoppedKey = &kHasBeenPoppedKey;

@implementation UIViewController (MemoryLead)

+ (void)load {
    //交换方法
    [self swizzleSEL:@selector(viewDidDisappear:) withSEL:@selector(swizzed_viewDidDisappear:)];
    
    [self swizzleSEL:@selector(viewWillAppear:) withSEL:@selector(swizzled_viewWillAppear:)];
}

- (void)swizzed_viewDidDisappear:(BOOL)animated {
    [self swizzed_viewDidDisappear:animated];
    
    //控制器即将被销毁了
    //2秒后调用断言方法
    if (objc_getAssociatedObject(self, kHasBeenPoppedKey)) {
        [self willDealloc];
    }
}


- (void)swizzled_viewWillAppear:(BOOL)animated {
    [self swizzed_viewDidDisappear:animated];
    objc_setAssociatedObject(self, kHasBeenPoppedKey, @(NO), OBJC_ASSOCIATION_RETAIN);
}


- (BOOL)willDealloc {
    //判断是不是白名单======
    
    //如果不是的话在3h秒之后调用断言=======或者弹窗========
    
    
    //然后遍历自己的子类============
    if (![super willDealloc]) {
        return NO;
    }
    
    [self willReleaseChildren:self.childViewControllers];
    [self willReleaseChild:self.presentedViewController];
    if (self.isViewLoaded) {
        [self willReleaseChild:self.view];
    }
    
    
    return YES;
}


@end
