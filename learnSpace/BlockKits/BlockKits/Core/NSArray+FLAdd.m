//
//  NSArray+FLAdd.m
//  BlocksKit
//
//  Created by 王江磊 on 2016/10/29.
//  Copyright © 2016年 wenhua. All rights reserved.
//

#import "NSArray+FLAdd.h"
#import <objc/runtime.h>

@implementation NSArray (FLAdd)

- (void)fl_each:(void (^ )(id))block{
    
    NSParameterAssert(block != nil);
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj);
    }];
}

- (void)fl_apply:(void (^)(id))block{
    
    NSParameterAssert(block);
    
    [self enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj);
    }];
}


- (id)fl_match:(BOOL (^)(id))block{
    
    NSParameterAssert(block != nil);

    // Returns the index of the first object in the array that passes a test in a given block
    // 返回数组匹配到的第一个元素的索引。然后停止遍历
    NSUInteger index = [self indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return  block(obj);
    }];
    if (index == NSNotFound) {
        return nil;
    }
    return self[index];
}


- (NSArray *)fl_select:(BOOL (^)(id))block{
    
    NSParameterAssert(block != nil);
    // Returns the indexes of objects in the array that pass a test in a given block.
    // 返回所有匹配的对象的索引。
    NSIndexSet *indexSet = [self indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@",obj);
        return block(obj);
    }];
    
    return [self objectsAtIndexes:indexSet];
}


- (NSArray *)fl_reject:(BOOL (^)(id))block{
    NSParameterAssert(block != nil);
    
    NSIndexSet *indexes = [self indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return !block(obj);
    }];
    return [self objectsAtIndexes:indexes];
}




@end
