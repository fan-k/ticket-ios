//
//  NSData+Category.m
//  Baletu
//
//  Created by fangkangpeng on 2018/12/18.
//  Copyright © 2018 Fan. All rights reserved.
//

#import "NSData+Category.h"

@implementation NSData (Category)


- (NSDictionary *)toDict{
    NSError *error;
    id dict = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:&error];
    return dict;;
}
@end
