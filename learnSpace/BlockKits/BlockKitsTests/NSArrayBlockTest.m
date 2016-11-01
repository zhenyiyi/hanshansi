//
//  NSArrayBlockTest.m
//  BlockKits
//
//  Created by 王江磊 on 2016/10/31.
//  Copyright © 2016年 wenhua. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSArray+FLAdd.h"


@interface NSArrayBlockTest : XCTestCase

@end

@implementation NSArrayBlockTest{
    NSArray *_subjects;
    NSArray *_integers;
    NSArray *_floats;
    NSUInteger _total;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _subjects = @[@"1",@"22",@"333"];
    _integers = @[@1,@2,@3];
    _floats = @[@.1,@.2,@.3];
    _total = 0;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testEash{
    void (^addBlock)(NSString *)= ^(NSString *sender){
        _total += sender.length;
    };
    [_subjects fl_each:addBlock];
    XCTAssertEqual(_total, 6, @"total length of \"122333\" is %ld",_total);
}


- (void)testMacth{
    BOOL (^valitationBlock)(NSString *) = ^(NSString * sender){
        _total += sender.length;
        if (sender.integerValue > 10) {
            return YES;
        }
        return NO;
    };
    id found = [_subjects fl_match:valitationBlock];
    
    XCTAssertEqual(found, @"22");
    XCTAssertEqual(_total, 3, @"total length of \"122333\" is %ld",_total);
}

- (void)testSelete{
    
    BOOL (^seleteBlock)(NSString *) = ^(NSString *sender){
        _total += sender.length;
        BOOL ret = sender.integerValue > 10 ? YES : NO;
        return ret;
    };
    id found = [_subjects fl_select:seleteBlock];
    
    XCTAssertEqual([found count], 2);
    
    XCTAssertEqual(_total, 6, @"total length of \"122333\" is %ld",_total);
}

- (void)testReject {
    BOOL (^valitationBlock)(NSString *) = ^(NSString *sender){
        _total += sender.length;
        BOOL ret = sender.integerValue > 10 ? YES : NO;
        return ret;
    };
    id found = [_subjects fl_reject:valitationBlock];
    XCTAssertEqual([found firstObject], @"1");
    XCTAssertEqual([found count], 1);
    XCTAssertEqual(_total, 6, @"total length of \"122333\" is %ld",_total);
}

@end
