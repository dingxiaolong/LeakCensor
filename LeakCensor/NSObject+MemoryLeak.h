//
//  NSObject+MemoryLeak.h
//  LeakCensor
//
//  Created by tonbright on 2020/3/31.
//  Copyright © 2020 tonbright. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MemoryLeak)

- (BOOL)willDealloc;
- (void)willReleaseChild:(id)child;
- (void)willReleaseChildren:(NSArray *)children;

- (NSArray *)viewStack;

+ (void)swizzleSEL:(SEL)originSel withSEL:(SEL)swizzledSEL;

@end

NS_ASSUME_NONNULL_END
