//
//  FanLocationManager.m
//  Baletu
//
//  Created by fangkangpeng on 2019/1/9.
//  Copyright © 2019 Fan. All rights reserved.
//

#import "FanLocationManager.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface FanLocationManager()<AMapLocationManagerDelegate>
/**回调block 一次定位仅提供一次回调*/
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@property (nonatomic ,copy)void (^hander)(CLLocation *location ,cat_action_type idx );
/**定位manager*/
@property (nonatomic, strong) AMapLocationManager *locationManager;

@end

@implementation FanLocationManager
+ (void)startUpdatingLocationWithHander:(void (^)(CLLocation *location ,cat_action_type idx ))hander{
    [FanLocationManager shareInstance].hander = hander;
    [[FanLocationManager shareInstance] startUpdatingLocation];
}

+ (instancetype)shareInstance{
    static FanLocationManager *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[FanLocationManager alloc] init];
    });
    return tools;
}
- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:5];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:5];
    __weak FanLocationManager *weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        __strong FanLocationManager *strongSelf = weakSelf;
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
        {
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
        //修改label显示内容
        if (regeocode){
            strongSelf.cityName = regeocode.city;
            strongSelf.location =location;
            if (strongSelf.hander) {
                strongSelf.hander(strongSelf.location,cat_action_nil);
            }
        }else{
            //地理信息获取失败 默认上海
            strongSelf.cityName = @"上海";
            strongSelf.location = location;
            if (strongSelf.hander) {
                strongSelf.hander(strongSelf.location,cat_action_nil);
            }
        }
    };
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}

- (void)startUpdatingLocation{
    if (self.location) {
        if (self.hander) {
            self.hander(self.location,cat_action_nil);
        }
    }else{
        [self configLocationManager];
    }
}
- (void)cleanUpAction{
    //停止定位
    [self.locationManager stopUpdatingLocation];
    [self.locationManager setDelegate:nil];
}


- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager *)locationManager
{
    [locationManager requestAlwaysAuthorization];
}

@end
