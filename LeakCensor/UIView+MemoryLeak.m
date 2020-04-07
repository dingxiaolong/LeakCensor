//
//  UIView+MemoryLeak.m
//  LeakCensor
//
//  Created by tonbright on 2020/4/7.
//  Copyright © 2020 tonbright. All rights reserved.
//

#import "UIView+MemoryLeak.h"
#import "NSObject+MemoryLeak.h"


@implementation UIView (MemoryLeak)
- (BOOL)willDealloc {
    if (![super willDealloc]) {
        return NO;
    }
    [self willReleaseChild:self.subviews];
    return YES;
}
@end
