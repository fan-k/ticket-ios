//
//  NSObject+Category.h
//  Baletu
//
//  Created by fangkangpeng on 2018/12/17.
//  Copyright © 2018 Fan. All rights reserved.
//




#import <Foundation/Foundation.h>

@interface NSObject (Category)
/**当前类的类名字符串*/
@property (nonatomic ,copy) NSString *fanClassName;

/**当前类的神策统计共用参数*/
@property (nonatomic ,strong) NSMutableDictionary *sensor_params;
/**构建神策数据源*/
- (NSMutableDictionary *)SensorParams;


#pragma mark -- 扩展事件传递block
/**事件外传递block*/
@property (nonatomic, copy) void (^customActionBlock)(id obj, cat_action_type idx);
/**事件接收block*/
@property (nonatomic ,copy) void (^resultActionBlock)(id obj, cat_action_type idx);




#pragma makr -- 数据处理



@end

@interface UIView (Category)
/**点击事件*/
@property (nonatomic ,copy) void (^viewClickBlock)(id obj, cat_action_type idx);

@end



