//
//  GCDMulticastDelegate.h
//  MulticastDelegate
//
//  Created by fenglin on 2016/11/14.
//  Copyright © 2016年 fenglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCDMulticastDelegateEnumerator;

@interface GCDMulticastDelegate : NSObject

/**
 * 添加delegate到某个队列。
 */
- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

/**
 移除某个队列的delegate
 */
- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

/**
 移除某个delegate。
 */
- (void)removeDelegate:(id)delegate;

/**
 移除所有的delegates。
 */
- (void)removeAllDelegates;

/**
 数量
 */
- (NSUInteger)count;

/**
 某个类的数量。
 */
- (NSUInteger)countOfClass:(Class)aClass;

/**
 某个selector的数量。
 */
- (NSUInteger)countForSelector:(SEL)aSelector;

/**
 某个delegate响应某个方法。
 */
- (BOOL)hasDelegateThatRespondsToSelector:(SEL)aSelector;

/**
 delegate枚举器
 */
- (GCDMulticastDelegateEnumerator *)delegateEnumerator;



@end



@interface GCDMulticastDelegateEnumerator : NSObject

- (NSUInteger)count;
- (NSUInteger)countOfClass:(Class)aClass;
- (NSUInteger)countForSelector:(SEL)aSelector;

- (BOOL)getNextDelegate:(id *)delPtr delegateQueue:(dispatch_queue_t *)dqPtr;
- (BOOL)getNextDelegate:(id *)delPtr delegateQueue:(dispatch_queue_t *)dqPtr ofClass:(Class)aClass;
- (BOOL)getNextDelegate:(id *)delPtr delegateQueue:(dispatch_queue_t *)dqPtr forSelector:(SEL)aSelector;

@end
