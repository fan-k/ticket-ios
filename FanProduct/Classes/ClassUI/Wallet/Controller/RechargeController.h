//
//  RechargeController.h
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanController.h"
#import "BankModel.h"
NS_ASSUME_NONNULL_BEGIN

/**充值提现页面*/
@interface RechargeController : FanController

@end
/**选择银行*/
@interface ChanceBankView : FanView
- (void)reloadCell:(BankCardModel *)cardModel;
@property (nonatomic ,strong) BankCardModel *model;
@end

/**添加银行卡*/
@interface AddBankModel : FanModel
@end

/**添加银行卡Cell*/
@interface ChanceAddBankCell : FanTableViewCell
@end
/*银行卡Cell*/
@interface ChanceBankCell : FanTableViewCell
@end
NS_ASSUME_NONNULL_END
