//
//  ViewController.m
//  Gesture
//
//  Created by 王江磊 on 2016/10/31.
//  Copyright © 2016年 wenhua. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
{
    
    CGPoint _initialPoint;
    CGFloat _lastScale;
    CGFloat _currentScale;
    CGAffineTransform currentOriginTransform;
}

@property (strong, nonatomic) UIScrollView *mainScrollview;
@property (strong, nonatomic) UIImageView *contentImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(100, 200, 150, 100)];
    
    /** 默认锚点就是CGPointMake(0.5, 0.5)*/
    //    aView.layer.anchorPoint = CGPointMake(0.5, 0.5)
    aView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:aView];
    
    UIView *bView = [[UIView alloc]initWithFrame:CGRectMake(100, 200, 150, 100)];
    bView.layer.anchorPoint = CGPointMake(0, 0
                                          
                                          
                                          
                                          
                                          );
    bView.backgroundColor = [UIColor redColor];
    [self.view addSubview:bView];
    
    
    UIView *cView = [[UIView alloc]initWithFrame:CGRectMake(100, 200, 150, 100)];
//    cView.layer.anchorPoint = CGPointMake(1, 1);
    cView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:cView];
    
    
    
    
//    _currentScale = 1.0;

    
    
    // 移动手势
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragView:)];
//    [self.contentImageView addGestureRecognizer:panGestureRecognizer];
    
}

- (void)adjustAnchorPoingForGesture:(UIPinchGestureRecognizer *)pinch{
    if (pinch.state == UIGestureRecognizerStateBegan ) {
        //1. 手势发生的view上
        UIView *pinchView = pinch.view;
        //2. 后去当前手势在view的位置。
        CGPoint locationInView = [pinch locationInView:pinchView];
        //3.根据view的位置设置锚点
        pinchView.layer.anchorPoint = CGPointMake(locationInView.x/pinchView.bounds.size.width, locationInView.y/pinchView.bounds.size.height);
        //4.防止设置完锚点后，view的位置发生变化，
        CGPoint locationInSuperView = [pinch locationInView:pinchView.superview];
        pinchView.center = locationInSuperView;
    }
}


- (void)pinchAction:(UIPinchGestureRecognizer*)pinch{
    NSLog(@"pinch.state == %ld",(long)pinch.state);
    [self adjustAnchorPoingForGesture:pinch];
    if (pinch.state == UIGestureRecognizerStateChanged || pinch.state == UIGestureRecognizerStateChanged) {
        [pinch view].transform = CGAffineTransformScale([pinch view].transform, [pinch scale], [pinch scale]);
        [pinch setScale:1];
    }
}


- (void)deviceOrientationDidChange:(NSNotification *)notification{
    //Obtain current device orientation
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    [UIView animateWithDuration:0.3 animations:^{
        switch (orientation) {
            case UIDeviceOrientationLandscapeLeft:{
                [self fullMode:YES];
            }
                break;
            case UIDeviceOrientationLandscapeRight:{
                [self fullMode:NO];
            }
                break;
            default:
                break;
        }
    } completion:^(BOOL finished) {
        //       _lastScale = 1.0;
    }];
}

//
//// 处理拖拉手势
//- (void) dragView:(UIPanGestureRecognizer *)panGestureRecognizer{
//    CGPoint p = [panGestureRecognizer translationInView:self.contentImageView.superview];
//    switch (panGestureRecognizer.state) {
//        case UIGestureRecognizerStateBegan:
//            _initialPoint = self.contentImageView.center;
//            break;
//        case UIGestureRecognizerStateChanged:
//            self.contentImageView.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
//            break;
//        default:
//            [self makeRightCenter];
//            break;
//    }
//}
//
//-(void)makeRightCenter{
//    [UIView animateWithDuration:0.3 animations:^{
//        CGPoint pointCurrent = self.contentImageView.center;
//        CGFloat deltaWidth = (_currentScale - 1)*CGRectGetWidth(self.view.bounds)*0.5;
//        CGFloat deltaHeight = (_currentScale - 1)*CGRectGetHeight(self.view.bounds)*0.5;
//        
//        CGFloat pX = 0;
//        CGFloat pY = 0;
//        if (pointCurrent.x >= self.view.center.x) {
//            pX = MIN(pointCurrent.x, self.view.center.x + deltaWidth);
//        }else{
//            pX = MAX(pointCurrent.x, self.view.center.x - deltaWidth);
//        }
//        
//        if (pointCurrent.y >= self.view.center.y) {
//            pY = MIN(pointCurrent.y, self.view.center.y + deltaHeight);
//        }else{
//            pY = MAX(pointCurrent.y, self.view.center.y - deltaHeight);
//        }
//        self.contentImageView.center = CGPointMake(pX, pY);
//    } completion:^(BOOL finished) {
//    }];
//}
//
//
//
-(CGAffineTransform )fullTransform:(BOOL)left{
    CGAffineTransform t1 = CGAffineTransformRotate(CGAffineTransformIdentity,left? M_PI_2:-M_PI_2);
    CGAffineTransform t2 = CGAffineTransformScale(CGAffineTransformIdentity, _currentScale,_currentScale);
    return  CGAffineTransformConcat(t1,t2);
}
//
//-(void)normalMode{
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.contentImageView setTransform:CGAffineTransformIdentity];
//    }];
//}
//
-(void)fullMode:(BOOL)left{
    [UIView animateWithDuration:0.3 animations:^{
//        [self.contentImageView setTransform:[self fullTransform:left]];
        currentOriginTransform =CGAffineTransformRotate(CGAffineTransformIdentity,left? M_PI_2:-M_PI_2);
    } completion:^(BOOL finished) {
//        [self makeRightCenter];
    }];
}




@end
