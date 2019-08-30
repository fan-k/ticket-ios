//
//  FanModel.m
//  Baletu
//
//  Created by fangkangpeng on 2018/12/17.
//  Copyright © 2018 Fan. All rights reserved.
//

#import "FanModel.h"
#import <objc/runtime.h>





@implementation FanModel
- (instancetype)init{
    self.ismore = YES;
    return [super init];
}
#pragma mark -- 解析
+ (instancetype)modelWithJson:(NSDictionary *)json{
    if (json && [json isKindOfClass:[NSDictionary class]]) {
        FanModel *model = [self subModelWithJson:json];
        if(model) {
            model.jsonData = json;
        }
        return model;
    } return nil;
}
+ (instancetype)subModelWithJson:(NSDictionary *)json{
    return nil;
}
#pragma Mark -- 归档反归档
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int outCount;
        Ivar * ivars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i ++) {
            Ivar ivar = ivars[i];
            NSString * key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            if ([aDecoder decodeObjectForKey:key]) {
                [self setValue:[aDecoder decodeObjectForKey:key]  forKey:key];
            }
        }
        free(ivars);
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int outCount;
    Ivar * ivars = class_copyIvarList([self class], &outCount);
    for (int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        NSString * key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        if ([self valueForKey:key]) {
            [aCoder encodeObject:[self valueForKey:key] forKey:key];
        }
    }
    free(ivars);
}

#pragma mark -- copy

-(id)copyWithZone:(NSZone *)zone{
    id model = [[[self class] allocWithZone:zone]init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:propertyName];
        if (value) {
            [model setValue:value forKey:propertyName];
        }
    }
    free(properties);
    return model ;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    NSString *class = NSStringFromClass([self class]);
    id model = [NSClassFromString(class) new];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:propertyName];
        if (value) {
            [model setValue:value forKey:propertyName];
        }
    }
    free(properties);
    
    return model;
}

- (NSMutableArray *)contentList{
    if (!_contentList) {
        _contentList = [NSMutableArray array];
    }return _contentList;
}

@end



@implementation FanNilModel
- (CGFloat)cellHeight{
    return 8;
}
@end

@implementation FanErrorCellModel
+ (instancetype)subModelWithJson:(NSDictionary *)json{
    FanErrorCellModel *model = [FanErrorCellModel new];
    model.title = DICTION_OBJECT(json, @"title");
    model.errorType = DICTION_OBJECT(json, @"errorType");
    model.fanClassName = @"FanErrorCell";
    model.cellHeight = 300;
    return model;
}

@end

@implementation FanHeaderModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    FanHeaderModel *model = [FanHeaderModel new];
    model.title = DICTION_OBJECT(json, @"title");
    model.img = DICTION_OBJECT(json, @"img");
    model.more = DICTION_OBJECT(json, @"more");
    model.accessView = [DICTION_OBJECT(json, @"accessView") boolValue];
    model.urlScheme = DICTION_OBJECT(json, @"urlScheme");
    return model;
}
- (CGFloat)cellHeight{
    return 40;
}
- (NSString *)fanClassName{
    return @"FanHeaderCell";
}

@end


@implementation FanNomalModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    FanNomalModel *model = [FanNomalModel new];
    model.title = DICTION_OBJECT(json, @"title");
    model.descript = DICTION_OBJECT(json, @"descript");
    return model;
}
- (CGFloat)cellHeight{
    return 56;
}
- (NSString *)fanClassName{
    return @"FanNomalCell";
}

@end
