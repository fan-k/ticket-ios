//
//  SearchModel.h
//  FanProduct
//
//  Created by 99epay on 2019/6/11.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanModel.h"
#import "HomeModel.h"
NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    SearchTypeCity = 0,//城市搜索
    SearchTypeCityNomal = 1,//城市搜索默认状态
    SearchTypeScenic = 2, //景区搜索
    SearchTypeScenicNomal = 3,//景区搜索默认状态
} SearchType;

@class SearchCellModel;

@interface SearchModel : FanModel
/** 用于填充搜索历史*/
@property (nonatomic ,strong) NSDictionary *dict;
/**搜索历史*/
@property (nonatomic ,strong) NSMutableArray *lateLys;
/**热门*/
@property (nonatomic ,strong) NSMutableArray *hots;
@property (nonatomic ,assign) SearchType searchType;
/**搜索成功的关键字*/
@property (nonatomic ,strong) SearchCellModel *searchModel;

@end




@interface SearchHotModel : FanModel
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,assign) BOOL  showDelete;
@property (nonatomic ,copy) NSString *lbTxt;

/**frame*/
@property (nonatomic ,assign) CGFloat left;
@property (nonatomic ,assign) CGFloat top;
@property (nonatomic ,assign) CGFloat width;

@property (nonatomic ,assign) CGFloat contentHeight;
@end


@interface SearchCellModel : FanModel
@property (nonatomic ,copy) NSString *title;

@end


NS_ASSUME_NONNULL_END
