//
//  OrderController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/5.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "OrderController.h"
#import "OrderModel.h"
#import "FanClassView.h"
#import "OrderHeaderView.h"


@interface OrderController ()
@property (nonatomic ,strong) OrderHeaderView *headerView;
@property (nonatomic ,strong) FanClassView *hoverView;
@end

@implementation OrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.navigationView.bounds;
    UIColor *startColor =  [UIColor colorWithRed:253/255.0 green:192/255.0 blue:22/255.0 alpha:1];
    UIColor *endColor =  [UIColor colorWithRed:254/255.0 green:231/255.0 blue:15/255.0 alpha:1];
    gradient.colors = @[(id)startColor.CGColor,(id)endColor.CGColor];
    gradient.startPoint = CGPointMake(1, 1);
    gradient.endPoint = CGPointMake(0, 0);
    [self.navigationView.layer addSublayer:gradient];
    self.navTitle = @"我的订单";
    [self initClassInfo];
    // Do any additional setup after loading the view.
}
- (void)initClassInfo{
    NSArray *menus = @[@{@"title":@"全部",@"type":@"all"},
                       @{@"title":@"待付款",@"type":@"all"},
                       @{@"title":@"待取票",@"type":@"all"},
                       @{@"title":@"待评价",@"type":@"all"},
                       @{@"title":@"退票/售后",@"type":@"all"},
                       ];
    self.headerView.menus = menus;
    [self.view addSubview:self.hoverView];
}
- (FanClassView *)hoverView{
    if (!_hoverView) {
        __block NSMutableArray *views = [NSMutableArray array];
        [self.headerView.model.contentList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            OrderListController *list = [OrderListController new];
            list.transferData = obj;
            [views addObject:list];
        }];
        _hoverView=  [[FanClassView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT) tables:views titleView:self.headerView];
    }return _hoverView;
}

- (OrderHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[OrderHeaderView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, 44)];
    }return _headerView;
}


@end


@interface OrderListController ()
@property (nonatomic ,strong) FanTableView *tableView;

@end
@implementation OrderListController

- (void)viewDidLoad{
    [super viewDidLoad];
    __weak OrderListController *weakSelf = self;
    self.resultActionBlock = ^(id obj, cat_action_type idx) {
        [weakSelf initListData];
    };
}
- (void)initListData{
    if (!self.tableView.viewModel.isRequested) {
        [self loadMore];
    }
}
- (void)loadMore{
    HomeSectionHeaderModel *model = self.transferData;
    self.params[@"token"] = [UserInfo shareInstance].userModel.token;
    self.params[@"type"] = model.type;
    self.params[@"lastid"] = model.lastId;
    [self requestWithUrl:FanUrlOrderList object:self.tableView loading:NO error:model.lastId ? FanErrorTypeTopAlert:FanErrorTypeError];
}
/**取票*/
- (void)TicketOut:(NSString *)number{
    self.params[@"number"] = number;
    self.params[@"token"] = [UserInfo shareInstance].userModel.token;
    [self requestWithUrl:FanUrlOrderTicket loading:NO error:FanErrorTypeTopAlert];
}
/**取消退票*/
- (void)cancelRefund:(NSString *)number{
    self.params[@"number"] = number;
    self.params[@"token"] = [UserInfo shareInstance].userModel.token;
    [self requestWithUrl:FanUrlRefundCancel loading:NO error:FanErrorTypeTopAlert];
}
- (void)handelFailureRequest:(FanRequestItem *)item{
     [FanAlert alertErrorWithItem:item];
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlOrderList]) {
        //如果是全部 并且是第一页 添加上标签
        HomeSectionHeaderModel *model = self.transferData;
        OrderListCellModel *listModel = [OrderListCellModel modelWithJson:item.responseObject];
        if (listModel && listModel.contentList.count) {
            [model.contentList addObjectsFromArray:listModel.contentList];
            model.ismore = listModel.ismore;
            model.lastId = listModel.lastId;
        }
        [self.tableView.viewModel setList:model.contentList type:0];
        self.tableView.more = model.ismore;
    }else{
        [FanAlert alertMessage:DICTION_OBJECT(item.responseObject, @"msg") type:AlertMessageTypeNomal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //刷新数据
            HomeSectionHeaderModel *model = self.transferData;
            model.lastId = nil;
            [self loadMore];
        });
    }
 
}
- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectZero];
        _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT - 60);
        _tableView.viewModel.errorType = FanErrorTypeNoData;
        __weak OrderListController *weakSelf = self;
        _tableView.footRefreshblock = ^{
            [weakSelf loadMore];
        };
        _tableView.headRefreshblock = ^{
            HomeSectionHeaderModel *model = weakSelf.transferData;
            model.lastId = nil;
            [weakSelf loadMore];
        };
        _tableView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_action_cell_click){
                FanModel *model = obj;
                [weakSelf pushViewControllerWithUrl:model.urlScheme transferData:nil hander:nil];
            }else  if (idx == cat_order_refund_cancel) {
                //取消退票
                OrderListCellModel *model = obj;
                [weakSelf cancelRefund:model.o_id];
            }else if (idx == cat_order_ticket_out) {
                //取票
                OrderListCellModel *model = obj;
                [weakSelf TicketOut:model.o_id];
            }else if (idx == cat_order_evaluate) {
                //评价
                OrderListCellModel *model = obj;
                [weakSelf pushViewControllerWithUrl:[NSString stringWithFormat:@"ScenicEvaluateWriteController?number=%@",model.o_id] transferData:nil hander:nil];
            }else if (idx == cat_order_refund) {
                //退票
                OrderListCellModel *model = obj;
                [weakSelf pushViewControllerWithUrl:[NSString stringWithFormat:@"RefundController?number=%@",model.o_id] transferData:nil hander:nil];
            }else if (idx == cat_order_buy_again) {
                //再次购买
                OrderListCellModel *model = obj;
                [weakSelf pushViewControllerWithUrl:model.scenicurl transferData:nil hander:nil];
            }else if (idx == cat_order_pay_now) {
                //立刻付款
                OrderListCellModel *model = obj;
                [weakSelf pushViewControllerWithUrl:[NSString stringWithFormat:@"OrderPayController?number=%@&endTime=%@&title=%@&price=%@",model.o_id,model.endTime,model.title,model.totalprice] transferData:nil hander:nil];
                
            }
        };
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}
@end
