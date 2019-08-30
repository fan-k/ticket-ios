//
//  FanTime.h
//  FanProduct
//
//  Created by 99epay on 2019/7/10.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FanTime : NSObject

/**时间戳转星期*/
+ (NSString *)weekWithTimeInterval:(NSString *)timeInterval;

/**判断某个日期是今天昨天明天后天 ，其他显示星期*/
+ (NSString *)dateToStr:(NSString *)datestring;
/**
 *  获取当天的字符串
 *  @return 格式为年-月-日 时分秒
 */
+ (NSString *)getCurrentTimeyyyymmdd;
/**
 *  获取时间差值  截止时间-当前时间
 *  nowDateStr : 当前时间
 *  deadlineStr : 截止时间
 *  @return 时间戳差值
 */
+ (NSInteger)getDateDifferenceWithNowDateStr:(NSString*)nowDateStr deadlineStr:(NSString*)deadlineStr;
/**
 根据时间戳 自定义时间格式 把时间戳转为字符串string
 
 @param time NSTimeInterval
 @return NSString
 */
+(NSString *)TimeIntervalIntoString:(NSTimeInterval)time formatter:(NSString *)foramatter;
@end

NS_ASSUME_NONNULL_END
