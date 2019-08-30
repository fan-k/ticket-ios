//
//  OrderDetailController.m
//  FanProduct
//
//  Created by 99epay on 2019/7/9.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "OrderDetailController.h"

@interface OrderDetailController ()
@property (nonatomic ,strong) FanTableView *tableView;
@property (nonatomic ,strong) OrderDetailModel *model;
@property (nonatomic ,strong) OrderDetailHeader *headerView;
@property (nonatomic ,strong) OrderDetailFooter *footerView;
@property (nonatomic ,strong) OrderDetailTabbar *tabbarView;
@property (nonatomic ,strong) FanErrorView *errorView;
@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftImage  = @"nav_back";
    self.navTitle = @"订单详情";
    [self initOrderDetailInfo];
    // Do any additional setup after loading the view.
}
- (void)initOrderDetailInfo{
    self.params[@"number"] = DICTION_OBJECT(self.urlParams, @"number");
    self.params[@"token"] = [UserInfo shareInstance].userModel.token;
    [self requestWithUrl:FanUrlOrderDetail loading:YES];
}

/**取票*/
- (void)TicketOut{
    self.params[@"number"] = self.model.o_id;
    self.params[@"token"] = [UserInfo shareInstance].userModel.token;
    [self requestWithUrl:FanUrlOrderTicket loading:NO error:FanErrorTypeTopAlert];
}
/**取消订单*/
- (void)cancelOrder{
    self.params[@"number"] = self.model.o_id;
    self.params[@"token"] = [UserInfo shareInstance].userModel.token;
    [self requestWithUrl:FanUrlOrderCancel loading:NO error:FanErrorTypeTopAlert];
}
/**删除订单*/
- (void)deleteOrder{
    self.params[@"number"] = self.model.o_id;
    self.params[@"token"] = [UserInfo shareInstance].userModel.token;
    [self requestWithUrl:FanUrlOrderDelete loading:NO error:FanErrorTypeTopAlert];

}
/**取消退票*/
- (void)cancelRefund{
    self.params[@"number"] = self.model.o_id;
    self.params[@"token"] = [UserInfo shareInstance].userModel.token;
    [self requestWithUrl:FanUrlRefundCancel loading:NO error:FanErrorTypeTopAlert];
}
- (void)handelFailureRequest:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlOrderDetail]) {
        //添加error
        self.errorView.type = FanErrorTypeError;
    }else{
        [FanAlert alertErrorWithItem:item];
    }
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlOrderDetail]) {
        self.model = [OrderDetailModel modelWithJson:DICTION_OBJECT(item.responseObject, @"data")];
        if (self.model) {
            [self.tableView.viewModel setList:self.model.contentList type:0];
            self.headerView.model = self.model;
            self.tabbarView.model = self.model;
            if (!_errorView) {
                [_errorView removeFromSuperview];
                _errorView = nil;
            }
        }else{
            //添加error
            self.errorView.type = FanErrorTypeError;
        }
    }else{
        [FanAlert alertMessage:DICTION_OBJECT(item.responseObject, @"msg") type:AlertMessageTypeNomal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //刷新数据
            [self initOrderDetailInfo];
        });
       
    }
   
}
- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_CONTENT_HEIGHT) style:UITableViewStylePlain];
        _tableView.tableFooterView = self.footerView;
        _tableView.tableHeaderView = self.headerView;
        [self.view addSubview:_tableView];
        __weak OrderDetailController *weakSelf = self;
        _tableView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_action_cell_click) {
                FanModel *model = obj;
                [weakSelf pushViewControllerWithUrl:model.urlScheme transferData:nil hander:nil];
            }
        };
        _tableView.headRefreshblock = ^{
            [weakSelf initOrderDetailInfo];
        };
    }return _tableView;
}
- (OrderDetailHeader *)headerView{
    if (!_headerView) {
        _headerView = [[OrderDetailHeader alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, 40)];
    }return _headerView;
}
- (OrderDetailFooter *)footerView{
    if (!_footerView) {
        _footerView = [[OrderDetailFooter alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, 40)];
    }return _footerView;
}
- (OrderDetailTabbar *)tabbarView{
    if (!_tabbarView) {
        _tabbarView = [[OrderDetailTabbar alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, FAN_SCREEN_WIDTH, FAN_TABBAR_HEIGHT)];
        [self.view addSubview:_tabbarView];
        __weak OrderDetailController *weakSelf = self;
        _tabbarView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_order_refund_cancel) {
                //取消退票
                [weakSelf cancelRefund];
            }else if (idx == cat_order_delete) {
                //删除订单
                [weakSelf deleteOrder];
            }else if (idx == cat_order_cancel) {
                //取消订单
                [weakSelf cancelOrder];
            }else if (idx == cat_order_ticket_out) {
                //取票
                [weakSelf TicketOut];
            }else if (idx == cat_order_evaluate) {
                //评价
                [weakSelf pushViewControllerWithUrl:[NSString stringWithFormat:@"ScenicEvaluateWriteController?number=%@",weakSelf.model.o_id] transferData:nil hander:nil];
            }else if (idx == cat_order_refund) {
                //退票
                [weakSelf pushViewControllerWithUrl:[NSString stringWithFormat:@"RefundController?number=%@",weakSelf.model.o_id] transferData:nil hander:nil];
            }else if (idx == cat_order_buy_again) {
                //再次购买
                [weakSelf pushViewControllerWithUrl:weakSelf.model.scenicurl transferData:nil hander:nil];
            }else if (idx == cat_order_pay_now) {
                //立刻付款
                [weakSelf pushViewControllerWithUrl:[NSString stringWithFormat:@"OrderPayController?number=%@&endTime=%@&title=%@&price=%@",weakSelf.model.o_id,weakSelf.model.endTime,weakSelf.model.title,weakSelf.model.totalprice] transferData:nil hander:nil];

            }
        };
    }return _tabbarView;
}
- (FanErrorView *)errorView{
    if (!_errorView) {
        _errorView = [[FanErrorView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT)];
        [self.view addSubview:_errorView];
        __weak OrderDetailController *weakSelf = self;
        _errorView.customActionBlock = ^(id obj, cat_action_type idx) {
            [weakSelf initOrderDetailInfo];
        };
    }return _errorView;
}
@end


@interface OrderDetailTabbar()
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) UIButton *leftButton;
@property (nonatomic ,strong) UIButton *rightButton;
@end
@implementation OrderDetailTabbar
- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
}
- (void)setModel:(OrderDetailModel *)model{
    _model = model;
    //根据不同状态 设置按钮的样式和文字
    /* 0：未付款，1：已付款，2：未取票，3：已取票，4：退票中，5：已退票，6：已完成，7：未评价，8：已评价，9:已取消*/
    if ([model.status isEqualToString:@"0"]) {
        //未付款 取消订单 和立即付款
        [self.leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.rightButton setTitle:@"立即付款" forState:UIControlStateNormal];
    }else if ([model.status isEqualToString:@"1"] || [model.status isEqualToString:@"2"]) {
        //已付款和未取票  申请退票 和取票
        [self.leftButton setTitle:@"退票" forState:UIControlStateNormal];
        [self.rightButton setTitle:@"取票" forState:UIControlStateNormal];
    }else if ([model.status isEqualToString:@"3"] || [model.status isEqualToString:@"6"] || [model.status isEqualToString:@"7"]) {
        //已取票 等于已完成 评价和再次购买
        [self.leftButton setTitle:@"填写评价" forState:UIControlStateNormal];
        [self.rightButton setTitle:@"再次购买" forState:UIControlStateNormal];
    }else if ([model.status isEqualToString:@"4"]) {
        //退票中 取消退票
        self.leftButton.hidden = YES;
        self.rightButton.left = 0;
        self.rightButton.width = self.width;
        [self.rightButton setTitle:@"取消退票" forState:UIControlStateNormal];
    }else if ([model.status isEqualToString:@"5"] || [model.status isEqualToString:@"9"] ||[model.status isEqualToString:@"8"]  ) {
        //已退票 已评价 已取消  删除订单 再次购买
        [self.leftButton setTitle:@"删除订单" forState:UIControlStateNormal];
        [self.rightButton setTitle:@"再次购买" forState:UIControlStateNormal];
    }
}

- (void)leftMethod{
    if ([_model.status isEqualToString:@"5"] || [_model.status isEqualToString:@"9"] ||[_model.status isEqualToString:@"8"]  ) {
        //删除订单
        [FanAlert showAlertControllerWithTitle:@"提示" message:@"是否删除该订单,不可恢复" _cancletitle_:@"取消" _confirmtitle_:@"确定" handler1:nil handler2:^(UIAlertAction * _Nonnull action) {
            if (self.customActionBlock) {
                self.customActionBlock(nil, cat_order_delete);
            }
        }];
    }else if ([_model.status isEqualToString:@"0"]){
        //取消订单
        [FanAlert showAlertControllerWithTitle:@"提示" message:@"是否取消该订单?" _cancletitle_:@"取消" _confirmtitle_:@"确定" handler1:nil handler2:^(UIAlertAction * _Nonnull action) {
            if (self.customActionBlock) {
                self.customActionBlock(nil, cat_order_cancel);
            }
        }];
        
    }else if ([_model.status isEqualToString:@"1"] || [_model.status isEqualToString:@"2"]) {
        //退票
        if (self.customActionBlock) {
            self.customActionBlock(nil, cat_order_refund);
        }
    }else if ([_model.status isEqualToString:@"3"] || [_model.status isEqualToString:@"6"] || [_model.status isEqualToString:@"7"]) {
        //填写评价
        if (self.customActionBlock) {
            self.customActionBlock(nil, cat_order_evaluate);
        }
    }
   
}
- (void)rightMethod{
    if ([_model.status isEqualToString:@"5"] || [_model.status isEqualToString:@"9"] ||[_model.status isEqualToString:@"8"]  || [_model.status isEqualToString:@"3"] || [_model.status isEqualToString:@"6"] || [_model.status isEqualToString:@"7"]) {
        //再次购买
        if (self.customActionBlock) {
            self.customActionBlock(nil, cat_order_buy_again);
        }
    }else if ([_model.status isEqualToString:@"0"]){
        //立即付款
        if (self.customActionBlock) {
            self.customActionBlock(nil, cat_order_pay_now);
        }
    }else if ([_model.status isEqualToString:@"1"] || [_model.status isEqualToString:@"2"]) {
        //取票
        if (self.customActionBlock) {
            self.customActionBlock(nil, cat_order_ticket_out);
        }
    }else if ([_model.status isEqualToString:@"4"]) {
        //取消退票
        [FanAlert showAlertControllerWithTitle:@"提示" message:@"是否取消退票" _cancletitle_:@"取消" _confirmtitle_:@"确定" handler1:nil handler2:^(UIAlertAction * _Nonnull action) {
            if (self.customActionBlock) {
                self.customActionBlock(nil, cat_order_refund_cancel);
            }
        }];
    }
    
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.frame = CGRectMake(0, 0, FAN_SCREEN_WIDTH, 49);
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.borderColor = COLOR_PATTERN_STRING(@"_line_color").CGColor;
        _bgView.layer.borderWidth  = FAN_LINE_HEIGHT;
        [self addSubview:_bgView];
    }return _bgView;
}

- (UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(0, 0, self.width/2, self.bgView.height);
        [_leftButton setBackgroundColor:[UIColor whiteColor]];
        [_leftButton setTitleColor:COLOR_PATTERN_STRING(@"_8c8c8c_color") forState:UIControlStateNormal];
        [_leftButton.titleLabel setFont:FanFont(15)];
        [_leftButton addTarget:self action:@selector(leftMethod) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_leftButton];
    }return _leftButton;
}
- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(self.width/2, 0, self.width/2, self.bgView.height);
        [_rightButton setBackgroundColor:COLOR_PATTERN_STRING(@"_fdc716_color")];
        [_rightButton setTitleColor:COLOR_PATTERN_STRING(@"_212121_color") forState:UIControlStateNormal];
        [_rightButton.titleLabel setFont:FanFont(15)];
        [_rightButton addTarget:self action:@selector(rightMethod) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_rightButton];
    }return _rightButton;
}

@end



@interface OrderDetailHeader()
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) UILabel *descriptLb;

@end
@implementation OrderDetailHeader

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLb.frame = CGRectMake(15, self.height/2 - 10, self.width/2 - 15, 20);
    self.descriptLb.frame = CGRectMake(self.titleLb.right, self.titleLb.top, self.titleLb.width, self.titleLb.height);
}
- (void)setModel:(OrderDetailModel *)model{
    _model = model;
    [self.titleLb setText:model.statusTxt];
    [self.descriptLb setText:[NSString stringWithFormat:@"￥%@",model.price]];
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _titleLb.font = FanMediumFont(16);
        [self addSubview:_titleLb];
    }return _titleLb;
}

- (UILabel *)descriptLb{
    if (!_descriptLb) {
        _descriptLb = [UILabel new];
        _descriptLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _descriptLb.font = FanMediumFont(16);
        _descriptLb.textAlignment = NSTextAlignmentRight;
        [self addSubview:_descriptLb];
    }return _descriptLb;
}

@end

@implementation OrderDetailFooter

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = FanRegularFont(13);
        self.textColor = COLOR_PATTERN_STRING(@"_text_ploacher_color");
        self.text = @"——三重保障升级·让您购票无忧——";
        self.backgroundColor = COLOR_PATTERN_STRING(@"_base_background_color");
    }return self;
}

@end



