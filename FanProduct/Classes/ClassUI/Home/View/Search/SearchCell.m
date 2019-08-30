//
//  SearchCell.m
//  FanProduct
//
//  Created by 99epay on 2019/6/11.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "SearchCell.h"


@interface SearchCell ()
@property (nonatomic ,strong) UILabel *titlelb;
@end

@implementation SearchCell
- (void)initView{
    self.FanSeparatorStyle = FanTableViewCellSeparatorStyle15_15;
}
- (void)cellModel:(id)cellModel{
    SearchCellModel *model = cellModel;
    [self.titlelb setText:model.title];
}
- (UILabel *)titlelb{
    if (!_titlelb) {
        _titlelb = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 44)];
        _titlelb.font = FanFont(15);
        _titlelb.textColor = [UIColor blackColor];
        [self addSubview:_titlelb];
    }return _titlelb;
}
@end



@interface SearchLabelCell ()
@property (nonatomic ,strong) UILabel *titlelb;
@property (nonatomic ,strong) UIButton *deleteBtn;
@end

@implementation SearchLabelCell
- (void)layoutSubviews{
    [super layoutSubviews];
}
- (void)buttonClick:(UIButton *)button{
    SearchHotModel *model = self.cellModel;
    SearchHotModel *hotModel = model.contentList[button.tag - 101];
    if (self.customActionBlock) {
        self.customActionBlock(hotModel, cat_action_cell_click);
    }
}
- (void)cellModel:(id)cellModel{
    SearchHotModel *model = cellModel;
    self.titlelb.text = model.title;
    self.deleteBtn.hidden = !model.showDelete;
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.hidden = YES;
        }
    }
    for (int i = 0 ; i < model.contentList.count; i ++) {
        SearchHotModel *hotModel = model.contentList[i];
        UIButton *button = [self viewWithTag:101 + i];
        if (!button) {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:COLOR_PATTERN_STRING(@"_f7f7f7_color")];
            [button setTitleColor:COLOR_PATTERN_STRING(@"_363636_color") forState:UIControlStateNormal];
            button.titleLabel.font = FanFont(12);
            button.layer.cornerRadius = 3;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 101 + i;
            [self addSubview:button];
        }
        button.hidden =  NO;
        [button setTitle:hotModel.lbTxt forState:UIControlStateNormal];
        button.frame = CGRectMake(hotModel.left, hotModel.top, hotModel.width, 30);
    }
}

- (UILabel *)titlelb{
    if (!_titlelb) {
        _titlelb = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 40)];
        _titlelb.font = FanFont(15);
        _titlelb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        [self addSubview:_titlelb];
    }return _titlelb;
}
@end




