//
//  FanSystemDefine.h
//  Baletu
//
//  Created by fangkangpeng on 2018/12/18.
//  Copyright © 2018 Fan. All rights reserved.
//

#ifndef FanSystemDefine_h
#define FanSystemDefine_h


/**项目构建版本号*/
#define FanBundleVersion  [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]
/**系统版本号*/
#define FanSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]




#endif /* FanSystemDefine_h */
