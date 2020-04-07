//
//  MLeakedObjectProxy.m
//  LeakCensor
//
//  Created by tonbright on 2020/3/31.
//  Copyright © 2020 tonbright. All rights reserved.
//

#import "MLeakedObjectProxy.h"
static NSMutableSet *leakedObjectPtrs;

@interface MLeakedObjectProxy()
@property (nonatomic, weak) id object;
@property (nonatomic, strong) NSNumber *objectPtr;
@property (nonatomic, strong) NSArray *viewStack;
@end


@implementation MLeakedObjectProxy
+ (BOOL)isAnyObjectLeakedAtPtrs:(NSSet *)ptrs {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        leakedObjectPtrs = [NSMutableSet new];
    });
    if (!ptrs || !ptrs.count) {
        return NO;
    }
    if ([leakedObjectPtrs intersectsSet:ptrs]) {
        return YES;
    }
    return NO;
}
+ (void)addLeakedObject:(id)object {
    MLeakedObjectProxy *proxy = [MLeakedObjectProxy new];
    proxy.object = object;
    proxy.objectPtr = @((unsigned long)object);
    proxy.viewStack = [object viewStack];
    [leakedObjectPtrs addObject:proxy.objectPtr];
    
}
@end
