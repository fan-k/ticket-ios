//
//  HomeModel.m
//  FanProduct
//
//  Created by 99epay on 2019/6/5.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel
+ (instancetype)subModelWithJson:(NSDictionary *)json{
    HomeModel *model = [HomeModel new];
    NSArray *datas = DICTION_OBJECT(json, @"data");
    if ([datas isKindOfClass:[NSArray class]]) {
        __block NSMutableArray *firstSection = [NSMutableArray array];
        [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HomeCellTypeModel *cellTypeModel = [HomeCellTypeModel modelWithJson:obj];
            if (cellTypeModel) {
                if ([cellTypeModel.type isEqualToString:@"slider"]) {
                    [firstSection addObject:[HomeHeaderModel subModelWithJson:@{@"title":cellTypeModel.title}]];
                    [firstSection addObject:cellTypeModel];
                    [firstSection addObject:[FanNilModel new]];
                }else if ([cellTypeModel.type isEqualToString:@"wall"]) {
                    [firstSection addObject:[HomeHeaderModel subModelWithJson:@{@"title":cellTypeModel.title}]];
                    [firstSection addObjectsFromArray:cellTypeModel.contentList];
                    [firstSection addObject:[FanNilModel new]];
                }else{
                    [firstSection addObject:cellTypeModel];
                    [firstSection addObject:[FanNilModel new]];
                }
            }
        }];
        if (firstSection.count) {
            [model.contentList addObject:firstSection];
            return model;
        }
    }
    return nil;
}
@end


@implementation HomeCellTypeModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    HomeCellTypeModel *model = [HomeCellTypeModel new];
    model.title = DICTION_OBJECT(json, @"title");
    model.type = [json.allKeys containsObject:@"view"] ? DICTION_OBJECT(json, @"view"):DICTION_OBJECT(json, @"type");
    NSArray *datas = DICTION_OBJECT(json, @"data");
    if ([datas isKindOfClass:[NSArray class]]) {
        __block NSMutableArray *firstSection = [NSMutableArray array];
        [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HomeContentModel *contentModel = [HomeContentModel modelWithJson:obj];
            if (contentModel) {
                contentModel.fanClassName = model.fanClassName;
                if ([model.type isEqualToString:@"wall"]) {
                    contentModel.cellHeight  = (FAN_SCREEN_WIDTH - 30 )/2 + 10;
                }
                [firstSection addObject:contentModel];
            }
        }];
        if (firstSection.count) {
            [model.contentList addObjectsFromArray:firstSection];
        }
    }
    return model;
}
- (NSArray *)imgUrls{
    if (!_imgUrls) {
         __block NSMutableArray *arr = [NSMutableArray array];
        [self.contentList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[HomeContentModel class]]) {
                HomeContentModel *model = obj;
                if (model.picture) {
                    [arr addObject:model.picture];
                }
            }
        }];
        _imgUrls = arr;
    }return _imgUrls;
}

- (NSString *)fanClassName{
    if ([self.type isEqualToString:@"banner"]) {
        return @"HomeSliderCell";
    }else if ([self.type isEqualToString:@"nav"]) {
        return @"HomeToolsCell";
    }else if ([self.type isEqualToString:@"slider"]) {
        return @"HomeRecommendCell";
    }else if ([self.type isEqualToString:@"wall"]) {
        return @"HomeRecommendNearCell";
    }
    return nomalCellClassName;
}
- (CGFloat)cellHeight{
    if ([self.type isEqualToString:@"banner"]) {
        return FAN_SCREEN_WIDTH/2;
    }else if ([self.type isEqualToString:@"nav"]) {
        return self.contentHeight;
    }else if ([self.type isEqualToString:@"slider"]) {
        return  FanHeight(194);
    }
    return 0.01;
}

- (CGFloat)contentHeight{
    if (!_contentHeight) {
        __block CGFloat height = 0;
        __block CGFloat width = 0;
        CGFloat contentWidth = FAN_SCREEN_WIDTH - 30;
        [self.contentList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HomeContentModel *model = obj;
            model.left = width;
            width = model.width  + model.left;
            if (width > contentWidth) {
                //超出就换行
                width = 0;
                model.left = width;
                width += model.width;
                height += + model.width;
            }
            model.top = height;
        }];
        height += (contentWidth)/4;//加上第一行的高度
        height += 10;//上下间距
        _contentHeight = height;
        
    }return _contentHeight;
}

@end

@implementation HomeHeaderModel
+ (instancetype)subModelWithJson:(NSDictionary *)json{
    HomeHeaderModel *model = [HomeHeaderModel new];
    model.title = DICTION_OBJECT(json, @"title");
    model.cellHeight  = 44;
    model.fanClassName = @"HomeHeaderCell";
    return  model;
}
@end

@implementation HomeContentModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    HomeContentModel *model = [HomeContentModel new];
    if([json.allKeys containsObject:@"data"]){
        NSArray *datas = DICTION_OBJECT(json, @"data");
        if ([datas isKindOfClass:[NSArray class]]) {
            __block NSMutableArray *firstSection = [NSMutableArray array];
            [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HomeContentModel *contentModel = [HomeContentModel modelWithJson:obj];
                if (contentModel) {
                    [firstSection addObject:contentModel];
                    if (idx == json.count - 1) {//最后一个
                        model.lastId = contentModel.o_id;
                    }
                }
            }];
            if (firstSection.count) {
                [model.contentList addObjectsFromArray:firstSection];
                if (json.count < 30) {
                    model.ismore = NO;
                }
            }
        }
    }else{
        model.title = DICTION_OBJECT(json, @"title");
        model.descript = DICTION_OBJECT(json, @"descript");
        model.picture = DICTION_OBJECT(json, @"picture");
        model.urlScheme = DICTION_OBJECT(json, @"url");
        model.star = DICTION_OBJECT(json, @"rating");
        model.grade = DICTION_OBJECT(json, @"grade");
        model.sellCount = DICTION_OBJECT(json, @"sellCount");
        model.distance = DICTION_OBJECT(json, @"distance");
        model.score = DICTION_OBJECT(json, @"score");
        model.recommend = DICTION_OBJECT(json, @"recommend");
        model.price = DICTION_OBJECT(json, @"price");
        model.o_id = DICTION_OBJECT(json, @"id");
        model.fanClassName = @"HomeContentCell";
        model.cellHeight = FanWidth(109) + 30;
    }
  return model;
}
- (NSMutableAttributedString *)found_price_att{
    if (!_found_price_att) {
        _found_price_att = [[NSMutableAttributedString alloc] initWithString:self.price];
        _found_price_att.font = FanMediumFont(18);
        _found_price_att.color = COLOR_PATTERN_STRING(@"_ff8925_color");
        [_found_price_att changeStringStyleWithText:@"￥" color:COLOR_PATTERN_STRING(@"_ff8925_color") font:FanMediumFont(11)];
        [_found_price_att changeStringStyleWithText:@"起" color:COLOR_PATTERN_STRING(@"_888888_color") font:FanRegularFont(11)];
    }return _found_price_att;
}
- (NSMutableAttributedString *)price_att{
    if (!_price_att) {
        _price_att = [[NSMutableAttributedString alloc] initWithString:self.price];
        _price_att.font = FanMediumFont(20);
        _price_att.color = COLOR_PATTERN_STRING(@"_363636_color");
        [_price_att changeStringStyleWithText:@"￥" color:COLOR_PATTERN_STRING(@"_363636_color") font:FanMediumFont(13)];
        [_price_att changeStringStyleWithText:@"起" color:COLOR_PATTERN_STRING(@"_363636_color") font:FanRegularFont(16)];
    }return _price_att;
}
- (NSString *)distance_star_att{
    if (!_distance_star_att) {
        _distance_star_att = [NSString stringWithFormat:@"%@   %@",self.distance,self.grade];
    }return _distance_star_att;
}
- (NSMutableAttributedString *)recommend_score_att{
    if (!_recommend_score_att) {
        _recommend_score_att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@推荐",self.score,self.recommend]];
        _recommend_score_att.color = COLOR_PATTERN_STRING(@"_ff8925_color");
        _recommend_score_att.alignment = NSTextAlignmentRight;
        _recommend_score_att.font =  FanRegularFont(14);
        [_recommend_score_att changeStringStyleWithText:self.score color:COLOR_PATTERN_STRING(@"_ff8925_color") font:FanRegularFont(16)];
    }return _recommend_score_att;
}
- (CGFloat)width{
    if (!_width) {
        _width = (FAN_SCREEN_WIDTH - 30) /4;
    }return _width;
}
@end


@implementation HomeSectionHeaderModel
+ (instancetype)subModelWithJson:(NSDictionary *)json{
    HomeSectionHeaderModel *model = [HomeSectionHeaderModel new];
    model.title = DICTION_OBJECT(json, @"title");
    model.type = DICTION_OBJECT(json, @"type");
    return model;
}

- (void)managerHomeList:(FanRequestItem *)item{
    self.isLoadData = YES;
    // 判断加载更多 和下拉刷新  判断页码数
    NSArray *json = DICTION_OBJECT(item.responseObject, @"data");
    if ([json isKindOfClass:[NSArray class]]) {
        __block NSMutableArray *content = [NSMutableArray array];
        [json enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HomeContentModel *contentModel = [HomeContentModel modelWithJson:obj];
            if (contentModel) {
                [content addObject:contentModel];
                if (idx == json.count - 1) {//最后一个
                    self.lastId = contentModel.o_id;
                }
                [content addObject:[FanNilModel new]];
            }
        }];
        if (content.count) {
            if (self.refresh) {
                self.contentList = content;
            }else{
                [self.contentList addObjectsFromArray:content];
            }
            if (json.count < 30) {
                self.ismore = NO;
            }
        }else{
            //无数据
            self.ismore = NO;
            if (!self.contentList.count) {
                //无数据 添加一个error
                
            }
        }
    }
}

- (void)managerFoundList:(FanRequestItem *)item{
    // 判断加载更多 和下拉刷新  判断页码数
    NSArray *json = DICTION_OBJECT(item.responseObject, @"data");
    if ([json isKindOfClass:[NSArray class]]) {
        __block NSMutableArray *content = [NSMutableArray array];
        [json enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HomeContentModel *contentModel = [HomeContentModel modelWithJson:obj];
            if (contentModel) {
                [content addObject:contentModel];
                if (idx == json.count - 1) {//最后一个
                    self.lastId = contentModel.o_id;
                }
            }
        }];
        if (content.count) {
            [self.contentList addObjectsFromArray:content];
            if (json.count < 30) {
                self.ismore = NO;
            }
        }
    }
}
- (NSArray *)currentContentList{
    HomeSectionHeaderModel *model = self.contentList[self.currentIndex];
    return model.contentList;
}

- (CGFloat)titleWidth{
    if (!_titleWidth) {
        _titleWidth = [FanSize getWidthWithString:self.title fontSize:14] + 10;
        if (_titleWidth < 60) {
            _titleWidth = 60;
        }
    }return _titleWidth;
}

- (CGFloat)titleTxtWidth{
    if (!_titleTxtWidth) {
        _titleTxtWidth = [FanSize getWidthWithString:self.title fontSize:15] + 10;
    }return _titleTxtWidth;
}
@end
