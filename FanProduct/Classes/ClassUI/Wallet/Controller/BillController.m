//
//  BillController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "BillController.h"
#import "FanClassView.h"
#import "HomeSectionHeaderView.h"

@interface BillController ()
@property (nonatomic ,strong) HomeSectionHeaderView *headerView;
@property (nonatomic ,strong) FanClassView *hoverView;

@end

@implementation BillController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle = @"账单明细";
     [self.view addSubview:self.hoverView];
    
}


- (FanClassView *)hoverView{
    if (!_hoverView) {
        __block NSMutableArray *views = [NSMutableArray array];
        [self.headerView.model.contentList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BillListController *list = [BillListController new];
            list.transferData = obj;
            [views addObject:list];
        }];
        _hoverView=  [[FanClassView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT) tables:views titleView:self.headerView];
    }return _hoverView;
}

- (HomeSectionHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[HomeSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, 60)];
        NSArray *menus = @[@{@"title":@"全部",@"type":@"all"},@{@"title":@"收入",@"type":@"shouru"},@{@"title":@"支出",@"type":@"zhichu"}];
        _headerView.buttonWidth = (FAN_SCREEN_WIDTH - 20)/menus.count;
        _headerView.menus = menus;
    }return _headerView;
}

@end





@implementation BillListController
- (void)viewDidLoad{
    [super viewDidLoad];
    __weak BillListController *weakSelf = self;
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
    self.params[@"type"] = model.type;
    self.params[@"lastid"] = model.lastId;
    [self requestWithUrl:FanUrlUserBill object:self.tableView loading:NO error:model.lastId ? FanErrorTypeTopAlert:FanErrorTypeError];
}
- (void)handelFailureRequest:(FanRequestItem *)item{
    
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    HomeSectionHeaderModel *model = self.transferData;
    BillCellModel *cellModel = [BillCellModel modelWithJson:item.responseObject];
    if (cellModel && cellModel.contentList.count) {
        [model.contentList addObjectsFromArray:cellModel.contentList];
        model.ismore = cellModel.ismore;
        model.lastId = cellModel.lastId;
    }
    [self.tableView.viewModel setList:model.contentList type:0];
    self.tableView.more = model.ismore;
}
- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectZero];
        _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT - 60);
        __weak BillListController *weakSelf = self;
        _tableView.footRefreshblock = ^{
            [weakSelf loadMore];
        };
        _tableView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_action_cell_click){
                FanModel *model = obj;
                [weakSelf pushViewControllerWithUrl:model.urlScheme transferData:nil hander:nil];
            }
        };
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}


@end


@interface BillDetailController ()
@property (nonatomic ,strong) FanTableView *tableView;

@end
@implementation BillDetailController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle  = @"账单详情";
    [self initBillDetailInfo];
   
}
- (void)initBillDetailInfo{
    self.params[@"id"] = DICTION_OBJECT(self.urlParams, @"id");
    [self requestWithUrl:FanUrlUserBillDetail object:self.tableView loading:YES error:FanErrorTypeError];
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    NSMutableArray *list = @[].mutableCopy;
    BillCellModel *model = [BillCellModel modelWithJson:DICTION_OBJECT(item.responseObject, @"data")];
    if (model) {
        model.cellHeight = 55;
        model.fanClassName = @"BillDetailAmountCell";
        [list addObject:model];
        [list addObject:[BillDetailCellModel modelWithJson:@{@"title":@"交易类型",@"desc":model.action}]];
        [list addObject:[BillDetailCellModel modelWithJson:@{@"title":@"交易时间",@"desc":model.time}]];
        [list addObject:[BillDetailCellModel modelWithJson:@{@"title":@"流水单号",@"desc":model.number}]];
        BillDetailCellModel *cellModel = [BillDetailCellModel modelWithJson:@{@"title":@"备注",@"desc":model.from}];
        if (cellModel) {
            cellModel.cellHeight = 60;
            [list addObject:cellModel];
        }
        [self.tableView.viewModel setList:list type:0];
    }
    
   
}

- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectZero];
        _tableView.frame = CGRectMake(0, FAN_NAV_HEIGHT, self.view.frame.size.width, FAN_CONTENT_HEIGHT);
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}
@end

@implementation BillDetailCellModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    BillDetailCellModel *model = [BillDetailCellModel new];
    model.title = DICTION_OBJECT(json, @"title");
    model.desc  =DICTION_OBJECT(json, @"desc");
    model.cellHeight = 40;
    model.fanClassName = @"BillDetailCell";
    return model;
}

@end
@interface BillDetailAmountCell()
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) UILabel *amountLb;
@end
@implementation BillDetailAmountCell

- (void)initView{
    self.FanSeparatorStyle = FanTableViewCellSeparatorStyle0_0;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLb.frame = CGRectMake(15, self.height/2 - 10, self.width/3 * 2, 20);
    self.amountLb.frame = CGRectMake(self.width - self.width/3 , self.height/2 - 10, self.width/3 - 15, 20);
    
}
- (void)cellModel:(id)cellModel{
    BillCellModel *model =  cellModel;
    [self.titleLb setText:model.title];
    if ([model.type isEqualToString:@"支出"]) {
        [self.amountLb setText:[NSString stringWithFormat:@"-%@",model.amount]];
        [self.amountLb setTextColor:COLOR_PATTERN_STRING(@"_333333_color")];
    }else{
        [self.amountLb setText:[NSString stringWithFormat:@"+%@",model.amount]];
        [self.amountLb setTextColor:COLOR_PATTERN_STRING(@"_red_color")];
    }
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = FanFont(15);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        [self addSubview:_titleLb];
    }return _titleLb;
}

- (UILabel *)amountLb{
    if (!_amountLb) {
        _amountLb = [UILabel new];
        _amountLb.font = FanFont(15);
        _amountLb.textColor = COLOR_PATTERN_STRING(@"_red_color");
        _amountLb.textAlignment = NSTextAlignmentRight;
        [self addSubview:_amountLb];
    }return _amountLb;
}


@end
@interface BillDetailCell()
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) UILabel *descLb;
@end
@implementation BillDetailCell


- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLb.frame = CGRectMake(15, 10, self.width/2 -15, 20);
    self.descLb.frame = CGRectMake(self.width/2 , 10, self.width/2 - 15, 20);
    
}
- (void)cellModel:(id)cellModel{
    BillDetailCellModel *model =  cellModel;
    [self.titleLb setText:model.title];
    [self.descLb setText:[NSString stringWithFormat:@"%@",model.desc]];
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = FanFont(13);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_999999_color");
        [self addSubview:_titleLb];
    }return _titleLb;
}

- (UILabel *)descLb{
    if (!_descLb) {
        _descLb = [UILabel new];
        _descLb.font = FanFont(13);
        _descLb.textColor = COLOR_PATTERN_STRING(@"_999999_color");
        _descLb.textAlignment = NSTextAlignmentRight;
        [self addSubview:_descLb];
    }return _descLb;
}


@end




@implementation BillCellModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    BillCellModel *model = [BillCellModel new];
    if ([json.allKeys containsObject:@"data"]) {
        NSArray *data = DICTION_OBJECT(json, @"data");
        if (isValidArray(data)) {
            __block NSMutableArray *content = [NSMutableArray array];
            [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BillCellModel *cellModel = [BillCellModel modelWithJson:obj];
                if (cellModel) {
                    [content addObject:cellModel];
                    model.lastId = cellModel.o_id;
                }
            }];
            if (content.count) {
                [model.contentList addObjectsFromArray:content];
                if (content.count < 30) {
                    model.ismore = NO;
                }
            }
        }
    }else{
        model.title = DICTION_OBJECT(json, @"title");
        model.time = DICTION_OBJECT(json, @"time");
        model.amount = DICTION_OBJECT(json, @"amount");
        model.number = DICTION_OBJECT(json, @"number");
        model.action = DICTION_OBJECT(json, @"action");
        model.type = DICTION_OBJECT(json, @"type");
        model.from = DICTION_OBJECT(json, @"from");
        model.o_id = DICTION_OBJECT(json, @"id");
        model.fanClassName = @"BillCell";
    }
    return model;
}
- (NSString *)urlScheme{
    return [NSString stringWithFormat:@"BillDetailController?id=%@",self.o_id];
}
- (CGFloat)cellHeight{
    return 70;
}
@end


@interface BillCell()
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) UILabel *timeLb;
@property (nonatomic ,strong) UILabel *amountLb;
@end
@implementation BillCell

- (void)initView{
    self.FanSeparatorStyle = FanTableViewCellSeparatorStyle0_0;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLb.frame = CGRectMake(15, self.height/2 - 25, self.width/3 * 2, 20);
    self.timeLb.frame = CGRectMake(15, self.height/2, self.width/3 * 2, 20);
    self.amountLb.frame = CGRectMake(self.width - self.width/3 , self.height/2 - 10, self.width/3 - 30, 20);
    
}
- (void)cellModel:(id)cellModel{
    BillCellModel *model =  cellModel;
    [self.titleLb setText:model.title];
    [self.timeLb setText: model.time];
    if ([model.type isEqualToString:@"支出"]) {
        [self.amountLb setText:[NSString stringWithFormat:@"-%@",model.amount]];
        [self.amountLb setTextColor:COLOR_PATTERN_STRING(@"_333333_color")];
    }else{
        [self.amountLb setText:[NSString stringWithFormat:@"+%@",model.amount]];
        [self.amountLb setTextColor:COLOR_PATTERN_STRING(@"_red_color")];
    }
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = FanFont(15);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        [self addSubview:_titleLb];
    }return _titleLb;
}
- (UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [UILabel new];
        _timeLb.font = FanFont(12);
        _timeLb.textColor = COLOR_PATTERN_STRING(@"_999999_color");
        [self addSubview:_timeLb];
    }return _timeLb;
}
- (UILabel *)amountLb{
    if (!_amountLb) {
        _amountLb = [UILabel new];
        _amountLb.font = FanFont(15);
        _amountLb.textColor = COLOR_PATTERN_STRING(@"_red_color");
        _amountLb.textAlignment = NSTextAlignmentRight;
        [self addSubview:_amountLb];
    }return _amountLb;
}

@end
