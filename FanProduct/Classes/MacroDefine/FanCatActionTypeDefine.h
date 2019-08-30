//
//  FanCatActionTypeDefine.h
//  Baletu
//
//  Created by fangkangpeng on 2018/12/20.
//  Copyright © 2018 Fan. All rights reserved.
//

typedef NS_ENUM(int ,cat_action_type) {
    cat_action_nil = 0,
    cat_close,
    cat_action_cell_click ,                          //cell的点击事件
    cat_action_click   ,                             //点击事件
    cat_action_scrollView_didScroll,
    
    
    cat_nav_left_click,                              //导航左按钮
    cat_nav_right_click,                             //导航右按钮
    cat_nav_alpha,
    
    
    cat_scenic_info,
    cat_scenic_evaluate,
    cat_scenic_order,
    cat_collect,                                    //收藏
    
    cat_login,                                      //去登录
    cat_login_success,                              //登录成功
    cat_login_failure,                              //登录失败
    
    cat_table_heightForSectionHeader,
    cat_table_viewForSectionHeader,
    cat_table_refresh,
    cat_table_load,
    
    cat_input_password,
    cat_input_password_start,
    cat_error_button,
    cat_error_close,
    cat_error_net,
    cat_error_pwd,
    cat_mine_set,                                   //个人中心设置
    cat_mine_userinfo,                              //个人中心个人资料
    
    
    cat_message,
    cat_search,
    cat_search_ScenicSpot,
    cat_search_city,
    
    cat_found_class_add,
    
    //textfield
    cat_textfield_content_changed_nil,
    cat_textfield_content_changed_unnil,
    cat_textfield_right_btn,
    cat_rightoffresignFirstResponder,
    cat_textfield_keyboard_show,
    cat_textfield_keyboard_hide,
    
    cat_forget,
    
    //time
    cat_time_out,
    //选择时间
    cat_datePicker_confirm_click,
    //选择性别 居住地
    cat_pickerView_confirm_click,
    
    //订单切换日期
    cat_check_price_date,
    cat_chance_touristinfo,
    cat_submit_touristinfo,
    cat_submit_order,
    
    
    cat_pay_success,
    cat_pay_failure,
    cat_pay_unsure,
    
    cat_order_delete,
    cat_order_cancel,
    cat_order_ticket_out,
    cat_order_evaluate,
    cat_order_refund_cancel,
    cat_order_refund,
    cat_order_buy_again,
    cat_order_pay_now,
    
    
    cat_refund_update_info,
};
