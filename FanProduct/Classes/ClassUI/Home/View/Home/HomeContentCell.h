//
//  HomeContentCell.h
//  FanProduct
//
//  Created by 99epay on 2019/6/6.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanTableViewCell.h"
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeContentCell : FanTableViewCell

@end

@interface HomeStarView : UIView
@property (nonatomic ,assign) NSInteger star;
@end


@interface HomeSliderCell : FanTableViewCell

@end

@interface HomeToolsCell : FanTableViewCell

@end

@interface HomeToolsView : FanView
@property (nonatomic ,strong) HomeContentModel *model;
@end

@interface HomeRecommendCell : FanTableViewCell

@end

@interface HomeRecommendView: UIView
@property (nonatomic ,strong) HomeContentModel *model;
@end
@interface HomeRecommendNearCell : FanTableViewCell

@end

@interface HomeHeaderCell : FanTableViewCell

@end


NS_ASSUME_NONNULL_END
