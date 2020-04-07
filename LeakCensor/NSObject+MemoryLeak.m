//
//  NSObject+MemoryLeak.m
//  LeakCensor
//
//  Created by tonbright on 2020/3/31.
//  Copyright © 2020 tonbright. All rights reserved.
//

#import "NSObject+MemoryLeak.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "MLeakedObjectProxy.h"

static const void *const kViewStackKey = &kViewStackKey;
static const void *const kParentPtrsKey = &kParentPtrsKey;
const void *const kLatestSenderKey = &kLatestSenderKey;

@implementation NSObject (MemoryLeak)



- (BOOL)willDealloc {
    NSString *className = NSStringFromClass([self class]);
    
    if ([[NSObject classNamesWhitelist] containsObject:className]) {
        return NO;
    }
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong id strongSelf = weakSelf;
        [strongSelf assertNotDealloc];
    });
    return YES;
}

- (void)assertNotDealloc {
    //pandyua
    
    if ([MLeakedObjectProxy isAnyObjectLeakedAtPtrs:[self parentPtrs]]) {
        return;
    }
    
    [MLeakedObjectProxy addLeakedObject:self];
    
    NSString *className = NSStringFromClass([self class]);
    NSLog(@"Possibly Memory Leak.\nIn case that %@ should not be dealloced, override -willDealloc in %@ by returning NO.\nView-ViewController stack: %@", className, className, [self viewStack]);
}


- (void)willReleaseChild:(id)child {
    if (!child) {
        return;
    }
    [self willReleaseChildren:@[child]];
}

- (void)willReleaseChildren:(NSArray *)children {
    NSArray *viewStack = [self viewStack];
    NSSet *parentPtrs = [self parentPtrs];
    for (id child in children) {
        NSString *classnm = NSStringFromClass([child class]);
        [child setViewStack:[viewStack arrayByAddingObject:classnm]];
        [child setParentPtrs:[parentPtrs setByAddingObject:@((unsigned long)child)]];
        [child willDealloc];
    }
    
    
//    NSSet *parentPtrs = [self ]
}

- (NSArray *)viewStack {
    NSArray *viewStack = objc_getAssociatedObject(self, kViewStackKey);
    if (viewStack) {
        return viewStack;
    }
    NSString *classnm = NSStringFromClass([self class]);
    return @[classnm];
}

- (void)setViewStack:(NSArray *)viewStack {
    objc_setAssociatedObject(self, kViewStackKey, viewStack, OBJC_ASSOCIATION_RETAIN);
}
- (void)setParentPtrs: (NSSet *)parentPtrs {
    objc_setAssociatedObject(self, kParentPtrsKey, parentPtrs, OBJC_ASSOCIATION_RETAIN);
}

- (NSSet *)parentPtrs {
    NSSet *parentPtrs = objc_getAssociatedObject(self, kParentPtrsKey);
    if (parentPtrs) {
        return parentPtrs;
    }
    parentPtrs = [NSSet setWithObject:@((unsigned long)self)];
    return parentPtrs;
}


+ (NSMutableSet *)classNamesWhitelist {
    static NSMutableSet *whitelist = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        whitelist = [NSMutableSet setWithObjects:
                     @"UIFieldEditor", // UIAlertControllerTextField
                     @"UINavigationBar",
                     @"_UIAlertControllerActionView",
                     @"_UIVisualEffectBackdropView",
                     nil];
        
        // System's bug since iOS 10 and not fixed yet up to this ci.
        NSString *systemVersion = [UIDevice currentDevice].systemVersion;
        if ([systemVersion compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending) {
            [whitelist addObject:@"UISwitch"];
        }
    });
    return whitelist;
}

+ (void)addClassNamesToWhitelist:(NSArray *)classNames {
    [[self classNamesWhitelist] addObjectsFromArray:classNames];
}


+ (void)swizzleSEL:(SEL)originSel withSEL:(SEL)swizzledSEL {
    Class class = [self class];
    Method originMethod = class_getInstanceMethod(class, originSel);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
    BOOL didAddMethod = class_addMethod(class, originSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSEL, method_getImplementation(originMethod), method_getTypeEncoding(swizzledMethod));
    }else {
        method_exchangeImplementations(originMethod, swizzledMethod);
    }
}

@end
