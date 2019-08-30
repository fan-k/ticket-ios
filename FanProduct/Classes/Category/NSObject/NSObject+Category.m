//
//  NSObject+Category.m
//  Baletu
//
//  Created by fangkangpeng on 2018/12/17.
//  Copyright © 2018 Fan. All rights reserved.
//

#import "NSObject+Category.h"
#import <objc/runtime.h>


static const char *FanClassNameId = "FanClassNameId";
static const char *FanSenSorParams = "FanSenSorParams";

static const char *FanCustomActionBlock = "FanCustomActionBlock";
static const char *FanResultActionBlock = "FanResultActionBlock";

@implementation NSObject (Category)

- (void)setFanClassName:(NSString *)fanClassName{
    objc_setAssociatedObject(self, FanClassNameId, fanClassName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)fanClassName{
    NSString *className =  objc_getAssociatedObject(self,FanClassNameId);
    if (!className) {
        className = NSStringFromClass(self.class);
        objc_setAssociatedObject(self, FanClassNameId, className, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return className;
}

- (void)setSensor_params:(NSMutableDictionary *)sensor_params{
    objc_setAssociatedObject(self, FanSenSorParams, sensor_params, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableDictionary *)sensor_params{
    id params = objc_getAssociatedObject(self,FanSenSorParams);
    if(!params){
        if([self respondsToSelector:@selector(SensorParams)]){
            params = [self SensorParams];}
    }
    return params;
}


#pragma mark -- 事件
- (void)setCustomActionBlock:(void (^)(id, cat_action_type))customActionBlock{
    objc_setAssociatedObject(self, FanCustomActionBlock, customActionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setResultActionBlock:(void (^)(id, cat_action_type))resultActionBlock{
    objc_setAssociatedObject(self, FanResultActionBlock, resultActionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(id, cat_action_type))customActionBlock{
    return objc_getAssociatedObject(self,FanCustomActionBlock);
}
- (void (^)(id, cat_action_type))resultActionBlock{
    return objc_getAssociatedObject(self,FanResultActionBlock);
}


#pragma mark -- 数据处理

@end


static const char *FanViewClickBlock = "FanViewClickBlock";


@implementation UIView (Category)
-(void)tapClick{
    if (self.viewClickBlock){
        self.viewClickBlock(self, cat_action_click);
    }
}

- (void)setViewClickBlock:(void (^)(id, cat_action_type))viewClickBlock{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    objc_setAssociatedObject(self, FanViewClickBlock, viewClickBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void (^)(id, cat_action_type))viewClickBlock{
    return objc_getAssociatedObject(self,FanViewClickBlock);
}


@end


