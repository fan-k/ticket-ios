//
//  FanTableViewCell.h
//  Baletu
//
//  Created by fangkangpeng on 2018/12/20.
//  Copyright © 2018 Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FanView.h"


static NSString *nomalCellClassName = @"FanTableViewCell";

typedef enum : NSUInteger {
    FanTableViewCellSeparatorStyleNone = 0,    //无分割线
    FanTableViewCellSeparatorStyle0_0,         //从0开始，居右0的分割线
    FanTableViewCellSeparatorStyle15_15,       //左15 右15 分割线
    FanTableViewCellSeparatorStyle15_0,       //左15 右0 分割线
    FanTableViewCellSeparatorStyle0_0_15_15, //左15 右 15 top 0 0 分割线
    FanTableViewCellSeparatorStyle41_15,      //左41 右15 分割线
} FanTableViewCellSeparatorStyle;



@interface FanTableViewCell : UITableViewCell



@property (nonatomic ,strong) id cellModel;
- (void)cellModel:(id)cellModel;
- (void)initView;
/**分割线的样式*/
@property (nonatomic ,assign) FanTableViewCellSeparatorStyle FanSeparatorStyle;
/**分割线*/
@property (nonatomic ,strong) UIView * dividingLine;
@end


#pragma mark -- publick cell

/**空cell 主要做列表内的比较高的分割区域*/
@interface FanNilCell : FanTableViewCell

@end
/**errorCell*/
@interface FanErrorCell : FanTableViewCell

@end


/*
 *区头形式的cell
 * 内容为图片+文字
 * 图片为固定大小图片 20 *20
 * 文字 为一行文字
 */
@interface FanHeaderCell : FanTableViewCell

@end
//
///**列表无更多数据cell*/
//@interface FanMoreCell : FanTableViewCell
//
//@end


/*
 * 一般的cell  title + descript + accessView
 */
@interface FanNomalCell : FanTableViewCell

@end
