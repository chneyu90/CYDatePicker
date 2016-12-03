//
//  FECDatePickView.h
//  DatePicker
//
//  Created by mac on 2016/12/2.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DatePickCompletion)(NSString *dateStr);

@interface FECDatePickView : UIView
/**
    datePicker 开放出来，便于自定义修改一些属性
 */
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
// 0表示alert类型  1表示action类型
@property (nonatomic, assign) NSInteger viewStyle;
// 时间格式  默认 yyyy-MM-dd
@property (nonatomic, copy) NSString *dateFormatterStr;

+ (instancetype)shareInstanceAlert;
+ (instancetype)shareInstanceAction;
- (void)showDatePickView:(DatePickCompletion)block;
@end
