//
//  ViewController.m
//  BlockKits
//
//  Created by 王江磊 on 2016/10/31.
//  Copyright © 2016年 wenhua. All rights reserved.
//

#import "ViewController.h"
#import "NSArray+FLAdd.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *img;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray <NSString *> *arr = @[@1,@"2",@YES];
    
    
    [arr fl_each:^(NSString *obj) {
        NSLog(@"%@",[obj class]);
        NSLog(@"%@",obj);
    }];
    
    
}



@end
