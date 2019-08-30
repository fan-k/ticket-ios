//
//  SearchModel.m
//  FanProduct
//
//  Created by 99epay on 2019/6/11.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel

- (void)setSearchType:(SearchType)searchType{
    _searchType = searchType;
    [self.contentList removeAllObjects];
    if (searchType == SearchTypeCityNomal) {
        //默认状态 城市
        // 1:当前定位成功
        if ([[FanLocationManager shareInstance].cityName isNotBlank]) {
            SearchHotModel *hotModel = [SearchHotModel modelWithJson:@{@"data":@[@{@"title":[NSString stringWithFormat:@"%@",[FanLocationManager shareInstance].cityName],@"id":@"城市ID"}],@"title":@"当前定位城市"}];
            if (hotModel.contentList.count) {
                [self.contentList addObject:hotModel];
            }
        }
    }
    // 2:搜索历史
    SearchHotModel *historyModel = [SearchHotModel modelWithJson:@{@"data":self.lateLys,@"title":@"最近搜索",@"delete":@"1"}];
    if (historyModel.contentList.count) {
        [self.contentList addObject:historyModel];
    }
    // 3：热门城市
    SearchHotModel *hotModel = [SearchHotModel modelWithJson:@{@"data":self.hots,@"title":searchType == SearchTypeCityNomal ?@"热门城市":@"热门景区"}];
    if (hotModel.contentList.count) {
        [self.contentList addObject:hotModel];
    }
}
- (void)setSearchModel:(SearchCellModel *)searchModel{
    [self managerLate:searchModel];
    if (self.searchType == SearchTypeCityNomal) {
        [[NSUserDefaults standardUserDefaults] setObject:self.lateLys forKey:@"lateLysdata_city"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else  if (self.searchType == SearchTypeScenicNomal) {
        [[NSUserDefaults standardUserDefaults] setObject:self.lateLys forKey:@"lateLysdata_scenic"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (void)managerLate:(SearchCellModel *)searchModel{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"title"] = searchModel.title;
    dict[@"id"] = searchModel.o_id;
    if ([self.lateLys containsObject:dict]) {
        [self.lateLys removeObject:dict];
    }
    [self.lateLys insertObject:dict atIndex:0];
    if (self.lateLys.count > 8) {
        [self.lateLys removeLastObject];
    }
}

- (NSMutableArray *)hots{
    if (!_hots) {
        _hots = [NSMutableArray array];
        if (self.searchType == SearchTypeCityNomal) {
            NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"hots_city"];
            if (arr && [arr isKindOfClass:[NSArray class]] && arr.count) {
                [_hots addObjectsFromArray:arr];
            }
        }else  if (self.searchType == SearchTypeScenicNomal) {
            NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"hots_scenic"];
            if (arr && [arr isKindOfClass:[NSArray class]] && arr.count) {
                [_hots addObjectsFromArray:arr];
            }
        }
    }return _hots;
}
- (NSMutableArray *)lateLys{
    if (!_lateLys) {
        _lateLys = [NSMutableArray array];
        if (self.searchType == SearchTypeCityNomal) {
            NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"lateLysdata_city"];
            if (arr && [arr isKindOfClass:[NSArray class]] && arr.count) {
                [_lateLys addObjectsFromArray:arr];
            }
        }else  if (self.searchType == SearchTypeScenicNomal) {
            NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"lateLysdata_scenic"];
            if (arr && [arr isKindOfClass:[NSArray class]] && arr.count) {
                [_lateLys addObjectsFromArray:arr];
            }
        }
    }
    return _lateLys;
}

@end



@implementation SearchHotModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    SearchHotModel *model = [SearchHotModel new];
    if ([json.allKeys containsObject:@"data"] && [DICTION_OBJECT(json, @"data") isKindOfClass:[NSArray class]]) {
        model.title = DICTION_OBJECT(json, @"title");
        model.showDelete = [DICTION_OBJECT(json, @"delete") boolValue];
        NSArray *datas = DICTION_OBJECT(json, @"data");
        [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SearchHotModel *hotModel = [SearchHotModel modelWithJson:obj];
            if (hotModel) {
                [model.contentList addObject:hotModel];
            }
        }];
    }else{
        model.title = DICTION_OBJECT(json, @"title");
        model.lbTxt = DICTION_OBJECT(json, @"title");
        model.o_id = DICTION_OBJECT(json, @"id");
    }
   
    return model;
}
- (NSString *)urlScheme{
    return [NSString stringWithFormat:@"ScenicSpotController?id=%@",self.o_id];
}
- (NSString *)fanClassName{
    return  @"SearchLabelCell";
}
- (CGFloat)cellHeight{
    return self.contentHeight;
}
- (CGFloat)contentHeight{
    if (!_contentHeight) {
        __block CGFloat height = 40;//标题
        __block CGFloat width = 15;
        [self.contentList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SearchHotModel *model = obj;
            model.left = width;
            width = model.width + 15 + model.left;
            if (width > FAN_SCREEN_WIDTH) {
                //超出就换行
                width = 15;
                model.left = width;
                width += model.width + 15;
                height += 15 + 30;
            }
            model.top = height;
        }];
        height += 30;//加上第一行的高度
        height += 15;//下间距
        _contentHeight = height;
        
    }return _contentHeight;
}
- (CGFloat)width{
    if (!_width) {
        _width = (FAN_SCREEN_WIDTH - 75 ) /4;
    }return _width;
}
@end



@implementation SearchCellModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    SearchCellModel *model = [SearchCellModel new];
    if ([json.allKeys containsObject:@"data"] && [DICTION_OBJECT(json, @"data") isKindOfClass:[NSArray class]]) {
        NSArray *data = DICTION_OBJECT(json, @"data");
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SearchCellModel *cellModel = [SearchCellModel modelWithJson:obj];
            if (cellModel) {
                [model.contentList addObject:cellModel];
            }
        }];
    }else{
        model.title = DICTION_OBJECT(json, @"title");
        model.o_id = DICTION_OBJECT(json, @"id");
        
    }
    return model;
}
- (NSString *)urlScheme{
    return [NSString stringWithFormat:@"ScenicSpotController?id=%@",self.o_id];
}
- (CGFloat)cellHeight{
    return 44;
}
- (NSString *)fanClassName{
    return @"SearchCell";
}
@end
