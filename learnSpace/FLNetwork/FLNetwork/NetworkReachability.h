//
//  NetworkReachability.h
//  FLNetwork
//
//  Created by 王江磊 on 2017/1/21.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>


typedef NS_ENUM(NSInteger, NetworkReachabilityStatus) {
    NetworkReachabilityStatusUnKnown = -1,
    NetworkReachabilityStatusNotReachable = 0,
    NetworkReachabilityStatusReachableViaWLAN = 1,
    NetworkReachabilityStatusReachableViaWIFI = 2
};

@interface NetworkReachability : NSObject

@property(nonatomic,assign,readonly)NetworkReachabilityStatus reachablilityStatus;

@property(nonatomic,assign,readonly,getter=isReachable)BOOL reachable;

@property(nonatomic,assign,readonly,getter=isReachableViaWLAN)BOOL reachableViaWLAN;

@property(nonatomic,assign,readonly,getter=isReachableViaWIFI)BOOL reachableViaWIFI;








+(instancetype)shareManager;

+(instancetype)manager;

+(instancetype)managerForDomain:(NSString *)domain;

+(instancetype)managerForAddress:(const void *)address;

-(instancetype)initWithReachability:(SCNetworkReachabilityRef)reachability NS_DESIGNATED_INITIALIZER ;

-(instancetype)init NS_UNAVAILABLE;

-(void)startMonitoring;

-(void)stopMonitoring;

-(void)setNetworkReachabilityChanged:(void(^)(NetworkReachabilityStatus status))changed;




@end

