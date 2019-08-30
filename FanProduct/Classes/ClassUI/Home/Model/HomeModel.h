//
//  HomeModel.h
//  FanProduct
//
//  Created by 99epay on 2019/6/5.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeModel : FanModel

@end



@interface HomeCellTypeModel : FanModel


@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *type;

//轮播图的图片链接数组
@property (nonatomic ,strong) NSArray *imgUrls;
@property (nonatomic ,assign) CGFloat contentHeight;

@end



@interface HomeContentModel : FanModel
/**标题*/
@property (nonatomic ,copy) NSString *title;
/**描述*/
@property (nonatomic ,copy) NSString *descript;
/**图片*/
@property (nonatomic ,copy) NSString *picture;
/**星级*/
@property (nonatomic ,copy) NSString *star;
/**景区AAAA等级*/
@property (nonatomic ,copy) NSString *grade;
/**已售数量*/
@property (nonatomic ,copy) NSString *sellCount;
/**距离*/
@property (nonatomic ,copy) NSString *distance;
/**评分*/
@property (nonatomic ,copy) NSString *score;
/**推荐值*/
@property (nonatomic ,copy) NSString *recommend;
/**价钱*/
@property (nonatomic ,copy) NSString *price;
/**url*/
@property (nonatomic ,copy) NSString *url;
/**优惠*/
@property (nonatomic ,copy) NSString *discount;

/**found  price*/
@property (nonatomic ,strong) NSMutableAttributedString *found_price_att;
/**home  price*/
@property (nonatomic ,strong) NSMutableAttributedString *price_att;
/**distance + start*/
@property (nonatomic ,copy) NSString *distance_star_att;
/**recommend + score*/
@property (nonatomic ,strong) NSMutableAttributedString *recommend_score_att;


/**frame*/
@property (nonatomic ,assign) CGFloat left;
@property (nonatomic ,assign) CGFloat top;
@property (nonatomic ,assign) CGFloat width;

@end

@interface HomeHeaderModel : FanModel
@property (nonatomic ,copy) NSString *title;
@end

@interface HomeSectionHeaderModel : FanModel
/**切换时是否滚动到相对应的偏移位置*/
@property (nonatomic ,assign) CGFloat scroll;
/**记录列表滚动的位置 切换列表时滚动回去   默认是表头的位置*/
@property (nonatomic ,assign) CGFloat contentOffsetY;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *type;

@property (nonatomic ,assign) CGFloat titleWidth;
@property (nonatomic ,assign) CGFloat titleTxtWidth;

@property (nonatomic ,assign) NSInteger currentIndex;
@property (nonatomic ,strong) NSArray *currentContentList;

//首页区分列表 加载数据
- (void)managerHomeList:(FanRequestItem *)item;
//发现页面 加载数据
- (void)managerFoundList:(FanRequestItem *)item;
@end

NS_ASSUME_NONNULL_END
