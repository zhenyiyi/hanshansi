//
//  NetworkReachability.m
//  FLNetwork
//
//  Created by 王江磊 on 2017/1/21.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "NetworkReachability.h"
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>



static void networkReachabilityCallBack(SCNetworkReachabilityRef target,
                                          SCNetworkReachabilityFlags flags,
                                          void			     * info){
    
};

static void postNetworkReachablility(SCNetworkReachabilityFlags flags, NetworkReachabilityStatus block){
    
};


static const void * retainInfo(const void *info){
    return Block_copy(info);
}
static void releadseInfo(const void *info){
    return Block_release(info);
}


typedef void(^NetworkReachabilityChangedBlcok)();// NetworkReachabilityStatus status

@interface NetworkReachability()
@property(nonatomic,assign,readonly) SCNetworkReachabilityRef networkReachabilityRef;
@property(nonatomic,assign,readwrite)NetworkReachabilityStatus reachablilityStatus;

@end

@implementation NetworkReachability

+(instancetype)shareManager{
    static NetworkReachability *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self manager];
    });
    return instance;
}

+(instancetype)manager{
    struct sockaddr_in address;
    bzero(&address, sizeof(address));
    NSLog(@"address-> %lu",sizeof(address));
    address.sin_len = sizeof(address);
    address.sin_family = AF_INET;
    return [self managerForAddress:&address];
}


+(instancetype)managerForDomain:(NSString *)domain{
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, [domain UTF8String]);
    
    NetworkReachability * manager = [[[self class] alloc] initWithReachability:reachability];
    
    CFRelease(reachability);
    
    return manager;
}

+(instancetype)managerForAddress:(const void *)address{
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, address);
    
    NetworkReachability * manager = [[[self class] alloc] initWithReachability:reachability];
    
    CFRelease(reachability);
    
    return manager;
}

-(instancetype)initWithReachability:(SCNetworkReachabilityRef)reachability{
    self = [super init];
    if (!self) {
        return nil;
    }
    _networkReachabilityRef = reachability;
    self.reachablilityStatus = NetworkReachabilityStatusUnKnown;
    return nil;
}

-(instancetype)init NS_UNAVAILABLE{
    return nil;
}

-(void)dealloc{
    if (_networkReachabilityRef != NULL) {
        CFRelease(_networkReachabilityRef);
    }
}

-(void)startMonitoring{

    NetworkReachabilityChangedBlcok callback = ^{
        
    };
    SCNetworkReachabilityContext context = {0, (__bridge void *)callback,retainInfo,releadseInfo,NULL };
    SCNetworkReachabilitySetCallback(self.networkReachabilityRef, networkReachabilityCallBack, &context);
    SCNetworkReachabilityScheduleWithRunLoop(self.networkReachabilityRef, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(self.networkReachabilityRef, &flags)) {
            postNetworkReachablility(flags,callback);
        }
    });
}

-(void)stopMonitoring{
    
}

-(void)setNetworkReachabilityChanged:(void(^)(NetworkReachabilityStatus status))changed{
    
}

@end
