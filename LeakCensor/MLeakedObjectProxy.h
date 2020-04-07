//
//  MLeakedObjectProxy.h
//  LeakCensor
//
//  Created by tonbright on 2020/3/31.
//  Copyright © 2020 tonbright. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLeakedObjectProxy : NSObject
+ (BOOL)isAnyObjectLeakedAtPtrs:(NSSet *)ptrs;
+ (void)addLeakedObject:(id)object;
@end

NS_ASSUME_NONNULL_END
