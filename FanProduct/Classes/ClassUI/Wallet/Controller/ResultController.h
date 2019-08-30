//
//  ResultController.h
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResultController : FanController

@end


@interface ResultStutusModel : FanModel
@property (nonatomic ,copy) NSString *type;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *status;
@property (nonatomic ,copy) NSString *descript;
@property (nonatomic ,copy) NSString *image;
@end


@interface ResultInfoModel : FanModel
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *descript;
@end


@interface ResultStatusCell : FanTableViewCell

@end


@interface ResultInfoCell : FanTableViewCell

@end

NS_ASSUME_NONNULL_END
