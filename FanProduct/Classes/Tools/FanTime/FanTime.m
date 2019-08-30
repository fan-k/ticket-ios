//
//  FanTime.m
//  FanProduct
//
//  Created by 99epay on 2019/7/10.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanTime.h"

enum{
    Sun = 1,
    Mon,
    Tue,
    Wed,
    Thu,
    Fri,
    Sat
};


@implementation FanTime

+ (NSString *)weekWithTimeInterval:(NSString *)timeInterval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval.integerValue];
    
    NSString *flagString ;
    NSCalendar* clendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSChineseCalendar];
    NSUInteger unitFlags = NSWeekdayCalendarUnit;
    NSDateComponents *cps = [clendar components:unitFlags fromDate:date];
    switch ([cps weekday]) {
        case Sun:
            flagString = @"星期天";
            break;
        case Mon:
            flagString = @"星期一";
            break;
        case Tue:
            flagString = @"星期二";
            break;
        case Wed:
            flagString = @"星期三";
            break;
        case Thu:
            flagString = @"星期四";
            break;
        case Fri:
            flagString = @"星期五";
            break;
        case Sat:
            flagString = @"星期六";
            break;
        default:
            break;
    }
    return flagString;
}
+ (NSString *)TimeIntervalIntoString:(NSTimeInterval)time formatter:(NSString *)foramatter{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:foramatter];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *string = [formatter stringFromDate:date];
    return string;
}


/**
 *  获取时间差值  截止时间-当前时间
 *  nowDateStr : 当前时间
 *  deadlineStr : 截止时间
 *  @return 时间戳差值
 */
+ (NSInteger)getDateDifferenceWithNowDateStr:(NSString*)nowDateStr deadlineStr:(NSString*)deadlineStr {
    
    NSInteger timeDifference = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [formatter dateFromString:nowDateStr];
    NSDate *deadline = [formatter dateFromString:deadlineStr];
    NSTimeInterval oldTime = [nowDate timeIntervalSince1970];
    NSTimeInterval newTime = [deadline timeIntervalSince1970];
    timeDifference = newTime - oldTime;
    
    return timeDifference;
}

/**
 *  获取当天的字符串
 *  @return 格式为年-月-日 时分秒
 */
+ (NSString *)getCurrentTimeyyyymmdd {
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
}

+ (NSString *)dateToStr:(NSString *)datestring
{
    datestring = [datestring stringByReplacingOccurrencesOfString:@"-" withString:@""];
    datestring = [datestring stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyyMMdd"];
    NSDate* date = [inputFormatter dateFromString:datestring];
    
    NSString *flagString = nil;
    
    // 当前日期
    int currentDate = [FanTime getIntegerFromDate:[NSDate date]];
    // 目标日期
    int tar = [FanTime getIntegerFromDate:date];
    // 时间差
    int diff = tar - currentDate;
    
    if ( diff < 3 && diff >= 0)
    {
        switch (diff)
        {
            case 0:
                flagString = @"今天";
                break;
            case 1:
                flagString = @"明天";
                break;
            case 2:
                flagString = @"后天";
                break;
            default:
                break;
        }
    }
    else if (diff == -1)
    {
        flagString = @"昨天";
    }
    else
    {
        flagString = @"";
//        NSCalendar* clendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSChineseCalendar];
//        NSUInteger unitFlags = NSWeekdayCalendarUnit;
//        NSDateComponents *cps = [clendar components:unitFlags fromDate:date ];
//        switch ([cps weekday]) {
//            case Sun:
//                flagString = @"星期天";
//                break;
//            case Mon:
//                flagString = @"星期一";
//                break;
//            case Tue:
//                flagString = @"星期二";
//                break;
//            case Wed:
//                flagString = @"星期三";
//                break;
//            case Thu:
//                flagString = @"星期四";
//                break;
//            case Fri:
//                flagString = @"星期五";
//                break;
//            case Sat:
//                flagString = @"星期六";
//                break;
//            default:
//                break;
//        }
    }
    
    return flagString ;
}


+ (int)getIntegerFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *todayStr = [formatter stringFromDate:date];
    int presentDay = [todayStr intValue];
    return presentDay;
}



@end
