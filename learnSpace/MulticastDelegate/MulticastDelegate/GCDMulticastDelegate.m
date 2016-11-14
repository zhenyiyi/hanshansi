//
//  GCDMulticastDelegate.m
//  MulticastDelegate
//
//  Created by fenglin on 2016/11/14.
//  Copyright © 2016年 fenglin. All rights reserved.
//

#import "GCDMulticastDelegate.h"

@interface GCDMulticastDelegateNode : NSObject
@property(nonatomic,weak)id delegate;
@property(nonatomic,strong) dispatch_queue_t delegateQueue;

- (instancetype)initWithDelegate:(id)delegate delegateQueeu:(dispatch_queue_t)delegateQueue;
@end

@implementation GCDMulticastDelegateNode
- (instancetype)initWithDelegate:(id)delegate delegateQueeu:(dispatch_queue_t)delegateQueue{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.delegateQueue = delegateQueue;
    }
    return self;
}
@end


@interface GCDMulticastDelegateEnumerator()
@property(nonatomic,strong)NSMutableArray *delegateNodes;
-(instancetype)initWithDelegateNodes:(NSMutableArray *)delegateNodes;
@end


@implementation GCDMulticastDelegateEnumerator

-(instancetype)initWithDelegateNodes:(NSMutableArray *)delegateNodes{
    self = [super init];
    if (self) {
        _delegateNodes = [delegateNodes copy];
    }
    return self;
}


- (NSUInteger)count{
    return self.delegateNodes.count;
}
- (NSUInteger)countOfClass:(Class)aClass{
    [self.delegateNodes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
}
- (NSUInteger)countForSelector:(SEL)aSelector{
    
}

- (BOOL)getNextDelegate:(id *)delPtr delegateQueue:(dispatch_queue_t *)dqPtr{
    
}
- (BOOL)getNextDelegate:(id *)delPtr delegateQueue:(dispatch_queue_t *)dqPtr ofClass:(Class)aClass{
    
}
- (BOOL)getNextDelegate:(id *)delPtr delegateQueue:(dispatch_queue_t *)dqPtr forSelector:(SEL)aSelector{
    
}

@end






@interface GCDMulticastDelegate()
@property(nonatomic,strong)NSMutableArray *delegateNodes;
@end

@implementation GCDMulticastDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegateNodes = [NSMutableArray array];
    }
    return self;
}
/**
 * 添加delegate到某个队列。
 */
- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue{
    NSParameterAssert(delegate != nil);
    GCDMulticastDelegateNode *node = [[GCDMulticastDelegateNode alloc] initWithDelegate:delegate delegateQueeu:delegateQueue];
    [self.delegateNodes addObject:node];
}

/**
 移除某个队列的delegate
 */
- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue{
    NSParameterAssert(delegate != nil);
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [self.delegateNodes enumerateObjectsUsingBlock:^(GCDMulticastDelegateNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.delegate == delegate && (delegateQueue == NULL || delegateQueue = obj.delegateQueue)) {
            obj.delegate = nil;
            [indexSet addIndex:idx];
        }
    }];
    [self.delegateNodes removeObjectsAtIndexes:indexSet];
}

/**
 移除某个delegate。
 */
- (void)removeDelegate:(id)delegate{
    NSParameterAssert(delegate != nil);
    [self removeDelegate:delegate delegateQueue:NULL];
}

/**
 移除所有的delegates。
 */
- (void)removeAllDelegates{
    [self.delegateNodes enumerateObjectsUsingBlock:^(GCDMulticastDelegateNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.delegate = nil;
    }];
    [self.delegateNodes removeAllObjects];
}

/**
 数量
 */
- (NSUInteger)count{
    return self.delegateNodes.count;
}

/**
 某个类的数量。
 */
- (NSUInteger)countOfClass:(Class)aClass{
    NSUInteger count = 0;
    [self.delegateNodes enumerateObjectsUsingBlock:^(GCDMulticastDelegateNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.delegate isKindOfClass:aClass]) {
            count++
        }
    }];
    return count;
}

/**
 某个selector的数量。
 */
- (NSUInteger)countForSelector:(SEL)aSelector{
    NSUInteger count = 0;
    [self.delegateNodes enumerateObjectsUsingBlock:^(GCDMulticastDelegateNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.delegate respondsToSelector:aSelector]) {
            count++
        }
    }];
    return count;
}

/**
 某个delegate响应某个方法。
 */
- (BOOL)hasDelegateThatRespondsToSelector:(SEL)aSelector{
    [self.delegateNodes enumerateObjectsUsingBlock:^(GCDMulticastDelegateNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.delegate respondsToSelector:aSelector]) {
            return YES;
        }
    }];
    return false;
}

- (GCDMulticastDelegateEnumerator *)delegateEnumerator{
    return [[GCDMulticastDelegateEnumerator alloc] initWithDelegateNodes:self.delegateNodes];
}

@end










