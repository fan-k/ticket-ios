//
//  BillController.h
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanController.h"
NS_ASSUME_NONNULL_BEGIN

@interface BillController : FanController

@end


@interface BillListController : FanController
@property (nonatomic ,strong) FanTableView *tableView;

@end

@interface BillDetailController : FanController

@end

@interface BillDetailCellModel : FanModel
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *desc;
@end
@interface BillDetailAmountCell : FanTableViewCell

@end
@interface BillDetailCell : FanTableViewCell

@end




@interface BillCellModel : FanModel
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *time;
@property (nonatomic ,copy) NSString *amount;
@property (nonatomic ,copy) NSString *number;
@property (nonatomic ,copy) NSString *action;
@property (nonatomic ,copy) NSString *type;
@property (nonatomic ,copy) NSString *from;

@end



@interface BillCell : FanTableViewCell

@end
NS_ASSUME_NONNULL_END
