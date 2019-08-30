//
//  NSObject+FanRequest.m
//  Baletu
//
//  Created by fangkangpeng on 2018/12/20.
//  Copyright © 2018 Fan. All rights reserved.
//

#import "NSObject+FanRequest.h"
#import <objc/runtime.h>

static const char *FanRequestParams = "FanRequestParams";
static const char *FanRequestQueue = "FanRequestQueue";
static const char *FanItemQueue = "FanItemQueue";

static const char *FanItmMethod = "FanItmMethod";
static const char *FanItemContentType = "FanItemContentType";


@implementation NSObject (FanRequest)

#pragma mark -- 网络
- (void)requestWithUrl:(NSString *)url  object:(id)object loading:(BOOL)loading error:(FanErrorType)error{
    FanRequestItem *item = [FanRequestItem new];
    item.url = url;
    item.errorType = error;
    item.object = object;
    item.method = self.itemMethod;
    self.itemMethod = nil;
    if(self.itemContentType){
        item.contentType = self.itemContentType;
        self.itemContentType = nil;
    }
    item.params = [NSMutableDictionary dictionaryWithDictionary:self.params];
    self.params = nil;
    item.requestQueue = [NSMutableArray arrayWithArray:self.requestQueue];
    item.itemQueue = [NSMutableArray arrayWithArray:self.itemQueue];
    item.showLoadIng = loading;
    //判断网络
    if (![FanRequestTool net]) {
        //无网络
        item.responseObject  = @{@"code":code_112,@"msg":@"暂无网络连接噢"};
        item.errorType = error >= 4 ? FanErrorTypeNet :FanErrorTypeTopAlertNet;
        [self managerErrorWithItem:item];
        [self managerTableStatusWithItem:item];
        [self handelFailureRequest:item];
        return;
    }
    __weak __typeof(&*self)weakSelf = self;
    item.completeBlock = ^(FanRequestItem *complteItem) {
        [weakSelf managerTableStatusWithItem:complteItem];
        if (complteItem.success) {
            [weakSelf hideErrorWithItem:complteItem];
            [weakSelf handelSuccessRequest:complteItem];
        }else{
            [weakSelf managerErrorWithItem:complteItem];
            [weakSelf handelFailureRequest:complteItem];
        }
    };
    [item startRequest];
}

- (void)requestWithUrl:(NSString *)url loading:(BOOL)loading error:(FanErrorType)error{
    [self requestWithUrl:url object:nil loading:loading error:error];
}
- (void)requestWithUrl:(NSString *)url loading:(BOOL)loading{
    [self requestWithUrl:url object:nil loading:loading error:FanErrorTypeNil];
}
- (void)handelFailureRequest:(FanRequestItem *)item{}
- (void)handelSuccessRequest:(FanRequestItem *)item{}

#pragma mark -- 处理列表刷新状态
- (void)managerTableStatusWithItem:(FanRequestItem *)item{
    if ([item.object isKindOfClass:[FanCollection class]]) {
        FanCollection *tb = item.object;
        tb.viewModel.isRequested = YES;
        [tb endRefreshing];
    }else if ([item.object isKindOfClass:[FanTableView class]]) {
        FanTableView *tb = item.object;
        tb.viewModel.isRequested = YES;
        [tb endRefreshing];
    }else if ([item.object isKindOfClass:[FanViewModel class]]){
        FanViewModel *vm = item.object;
        vm.isRequested = YES;
        [vm.tableView endRefreshing];
    }else if ([item.object isKindOfClass:[FanCollectionDelegate class]]){
        FanCollectionDelegate *vm = item.object;
        vm.isRequested = YES;
        [vm.collection endRefreshing];
    }
}
#pragma Mark--  处理error 提示
- (void)managerErrorWithItem:(FanRequestItem *)item{
    if (!item.errorType) {
        return;
    }
    if (item.errorType <= FanErrorTypeTopAlertTimeOut) {
        [FanAlert alertErrorWithItem:item];
    }else{
       
        UIView *supView;
        if ([item.object isKindOfClass:[FanViewModel class]]) {
            FanViewModel *vm = item.object;
            supView = vm.tableView;
        }else if ([item.object isKindOfClass:[FanTableView class]]){
            supView = item.object;
        }else if ([item.object isKindOfClass:[NSClassFromString(@"FanCollectionDelegate") class]]){
            FanCollectionDelegate *delegate = item.object;
            supView = delegate.collection;
        }else if ([item.object isKindOfClass:[UIView class]]){
            supView = item.object;
        }
        if (supView) {
            //先判断是否存在error
            FanErrorView *errorView = [supView viewWithTag:404];
            if (!errorView || ![errorView isKindOfClass:[FanErrorView class]]) {
                errorView = [FanErrorView new];
                errorView.tag = 404;
                weak_self
                errorView.customActionBlock = ^(id obj, cat_action_type idx) {
                    //默认加载 也可以直接在具体的页面中实现
                    if ([weakSelf respondsToSelector:@selector(handelErrorLoadWithItem:)]) {
                        [weakSelf handelErrorLoadWithItem:obj];
                    }
                };
                [supView addSubview:errorView];
                [supView bringSubviewToFront:errorView];
            }
            errorView.frame = CGRectMake(0, 0, supView.width, supView.height);
            errorView.item = item;
        }
    }
}
- (void)hideErrorWithItem:(FanRequestItem *)item{
    if (item.errorType >= FanErrorTypeTimeOut) {
        //先找到error  然后移除   error添加在列表 或view上 即item.object上
        FanErrorView *errorView;
        if ([item.object isKindOfClass:[FanViewModel class]]) {
            FanViewModel *vm = item.object;
            errorView = [vm.tableView viewWithTag:404];
        }else if ([item.object isKindOfClass:[FanTableView class]]){
            FanTableView *tb = item.object;
            errorView = [tb viewWithTag:404];
        }else if ([item.object isKindOfClass:[UIView class]]){
            UIView *v = item.object;
            errorView = [v viewWithTag:404];
        }
        if (errorView && [errorView isKindOfClass:[FanErrorView class]]) {
            [errorView removeFromSuperview];
            errorView.customActionBlock = nil;
            errorView = nil;
        }
        
        
    }
}

#pragma mark -- get
- (void)setItemMethod:(NSString *)itemMethod{
    objc_setAssociatedObject(self, FanItmMethod, itemMethod, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)itemMethod{
    NSString *method = objc_getAssociatedObject(self,FanItmMethod);
    if (!method) {
        method = @"GET";
        objc_setAssociatedObject(self, FanItmMethod, method, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }return method;
}
- (void)setItemContentType:(NSString *)itemContentType{
    objc_setAssociatedObject(self, FanItemContentType, itemContentType, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)itemContentType{
   return  objc_getAssociatedObject(self,FanItmMethod);
}
- (void)setParams:(NSMutableDictionary *)params{
    objc_setAssociatedObject(self, FanRequestParams, params, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableDictionary *)params{
    NSMutableDictionary *dict = objc_getAssociatedObject(self,FanRequestParams);
    if (!dict) {
        dict = [NSMutableDictionary new];
        objc_setAssociatedObject(self, FanRequestParams, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dict;
}
- (void)setRequestQueue:(NSMutableArray *)requestQueue{
    objc_setAssociatedObject(self, FanRequestQueue, requestQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableArray *)requestQueue{
    NSMutableArray *arr = objc_getAssociatedObject(self,FanRequestQueue);
    if (!arr) {
        arr = [NSMutableArray new];
        objc_setAssociatedObject(self, FanRequestQueue, arr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return arr;
}
- (void)setItemQueue:(NSMutableArray *)itemQueue{
    objc_setAssociatedObject(self, FanItemQueue, itemQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableArray *)itemQueue{
    NSMutableArray *arr = objc_getAssociatedObject(self,FanItemQueue);
    if (!arr) {
        arr = [NSMutableArray new];
        objc_setAssociatedObject(self, FanItemQueue, arr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return arr;
}



@end
