//
//  FanModel.h
//  Baletu
//
//  Created by fangkangpeng on 2018/12/17.
//  Copyright © 2018 Fan. All rights reserved.
//

#import "FanObject.h"
#import "UIColor+HexString.h"



@interface FanModel : FanObject<NSCopying,NSMutableCopying>
#pragma mark -- 自定义属性
/**model对应的cell的高度*/
@property (nonatomic ,assign) CGFloat cellHeight;
/**model对应的cell的在列表上的top*/
@property (nonatomic ,assign) CGFloat cellTop;
/**model对应的cell的在列表上的bottom*/
@property (nonatomic ,assign) CGFloat cellBottom;
/**model对应的cell的在列表上的left*/
@property (nonatomic ,assign) CGFloat cellLeft;
/**model对应的cell的在列表上的right*/
@property (nonatomic ,assign) CGFloat cellRight;
/**model对应的cell的row*/
@property (nonatomic ,assign) NSInteger row;
/**model对应的cell的section*/
@property (nonatomic ,assign) NSInteger section;
/**model内数据元素的集合数组*/
@property (nonatomic ,strong) NSMutableArray *contentList;
/**model的业务跳转url*/
@property (nonatomic ,copy) NSString * urlScheme;
/**model的json解析数据记录*/
@property (nonatomic ,copy) NSDictionary * jsonData;

/**model 的ID ,可记录需要跳转页面的ID 等参数*/
@property (nonatomic ,copy) NSString * o_id;
/**model 是否刷新*/
@property (nonatomic ,assign) BOOL refresh;
/**当前列表的最后一条数据ID 用于加载更多*/
@property (nonatomic ,copy) NSString *lastId;
/**当前列表数据的状态 是否有更多数据*/
@property (nonatomic ,assign) BOOL ismore;
/**判断当前model 是否加载数据*/
@property (nonatomic ,assign) BOOL isLoadData;

#pragma mark -- 解析方法
/**
 model 数据解析

 @param json json
 @return instancetype
 */
+ (instancetype)modelWithJson:(NSDictionary *)json;


/**
 model的子类实现的具体解析方法

 @param json json
 @return instancetype
 */
+ (instancetype)subModelWithJson:(NSDictionary *)json;
@end

#pragma mark -- Public model
/**空model*/
@interface FanNilModel :FanModel
@end

/**空model*/
@interface FanErrorCellModel :FanModel
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *errorType;
@end


@interface FanHeaderModel : FanModel
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *img;
@property (nonatomic ,copy) NSString *more;
@property (nonatomic ,assign) BOOL accessView;
@end



@interface FanNomalModel : FanModel
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *descript;
@end
