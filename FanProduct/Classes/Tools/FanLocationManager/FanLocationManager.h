//
//  FanLocationManager.h
//  Baletu
//
//  Created by fangkangpeng on 2019/1/9.
//  Copyright © 2019 Fan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


/*
 *提供需要当前位置的页面的定位服务
 */
@interface FanLocationManager : NSObject
/**位置信息*/
@property(nonatomic ,strong) CLLocation *location;
/**城市信息*/
@property (nonatomic ,copy) NSString *cityName;

/**单例*/
+ (instancetype)shareInstance;
/**开始定位*/
- (void)startUpdatingLocation;
/**中止定位*/
- (void)stopUpdatingLocation;


/**
 调用地图定位 并返回当前地理位置信息

 @param hander 回调
 */
+ (void)startUpdatingLocationWithHander:(void (^ )(CLLocation *location ,cat_action_type idx ))hander;
@end
