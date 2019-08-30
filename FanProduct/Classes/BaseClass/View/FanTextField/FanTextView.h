//
//  FanTextView.h
//  Baletu
//
//  Created by fangkangpeng on 2019/1/2.
//  Copyright © 2019 Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FanTextView : UITextView
/**设置默认文字字号*/
@property (nonatomic ,assign) NSInteger placeholder_font;
/**设置默认文字*/
@property (nonatomic ,copy) NSString *placeholder;
/**默认文字颜色*/
@property (nonatomic ) UIColor *placeholdercolor;
@end
