//
//  FECDatePickView.m
//  DatePicker
//
//  Created by mac on 2016/12/2.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "FECDatePickView.h"

#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A/1.0]
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface FECDatePickView ()
@property (weak, nonatomic) IBOutlet UIView *pickBjView;
@property (weak, nonatomic) IBOutlet UIView *btnsView;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property (weak, nonatomic) IBOutlet UIButton *btn_sure;
@property (weak, nonatomic) IBOutlet UIButton *btn_back;

@property (nonatomic, copy) DatePickCompletion completion;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftCon;

@end
static FECDatePickView *instance = nil;
@implementation FECDatePickView

#pragma mark - 初始化
+ (instancetype)shareInstanceAlert {
    
    instance = [[[NSBundle mainBundle] loadNibNamed:@"FECDatePickView" owner:nil options:nil]lastObject];
    instance.viewStyle = 0;
    return instance;
}

+ (instancetype)shareInstanceAction {
    instance = [[[NSBundle mainBundle] loadNibNamed:@"FECDatePickViewAction" owner:nil options:nil]lastObject];
    instance.viewStyle = 1;
    return instance;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker setMinimumDate:[NSDate date]];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (_viewStyle == 1) { // action 类型
        
        _btnsView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _btnsView.layer.shadowOffset = CGSizeMake(0, 2);
        _btnsView.layer.shadowOpacity = 0.3;//阴影透明度，默认0
        _btnsView.layer.shadowRadius = 2;//阴影半径，默认3
        [_pickBjView bringSubviewToFront:_btnsView];
    }else {
        _btn_sure.layer.cornerRadius = 4;
        _btn_sure.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _btn_sure.layer.borderWidth = 1;
        
        _btn_cancel.layer.cornerRadius = 4;
        _btn_cancel.layer.borderColor = COLOR(186, 185, 185, 1).CGColor;
        _btn_cancel.layer.borderWidth = 1;
        
        _pickBjView.layer.cornerRadius = 5;
        _pickBjView.layer.masksToBounds = YES;
        
        _btnsView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        _btnsView.layer.shadowOffset = CGSizeMake(0, 4);
        _btnsView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
        _btnsView.layer.shadowRadius = 4;//阴影半径，默认3
        [_pickBjView bringSubviewToFront:_btnsView];
        
        if (kScreenWidth > 380) { // 6+
            _rightCon.constant = 40;
            _leftCon.constant = 40;
        }
    }
}

#pragma mark - 取消按钮
- (IBAction)cancelBtnClick:(UIButton *)sender {
    if (self.viewStyle == 0) {
        [self buttonAnimation:sender];
    }
    [self hiddenView];
}

#pragma mark - 确定按钮
- (IBAction)sureBtnClick:(UIButton *)sender {
    if (self.viewStyle == 0) {
        [self buttonAnimation:sender];
    }
    [self hiddenView];
    NSString *time = [self getDateStringWithDateFormatte:self.dateFormatterStr];
    if (self.completion) {
        self.completion(time);
    }
}

#pragma mark - 背景按钮点击方法
- (IBAction)aciotnBackClick:(UIButton *)sender {
    [self hiddenView];
}

#pragma mark - 公共方法
// 隐藏
- (void)hiddenView {
    __weak typeof(self) weakSelf = self;
    if (self.viewStyle == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.alpha = 0;
            weakSelf.pickBjView.transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
        } completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
            instance = nil;
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
            instance = nil;
        }];
    }
    
}

// 弹出动画
- (void)showDatePickView:(DatePickCompletion)block {
    self.completion = block;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.frame = keyWindow.bounds;
    [keyWindow addSubview:self];
    
    if (self.viewStyle == 1) { // Action style
        _pickBjView.transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.pickBjView.transform = CGAffineTransformIdentity;
        }];
    }
}

// 按钮点击动画
- (void)buttonAnimation:(UIView *)view {
    /* 放大缩小 */
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    animation.duration = 0.1; // 动画持续时间
    animation.repeatCount = -1; // 重复次数
    animation.autoreverses = YES; // 动画结束时执行逆动画
    
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:0.9]; // 结束时的倍率
    
    // 添加动画
    [view.layer addAnimation:animation forKey:@"scale-layer"];
}

// 获取选择器时间
- (NSString *)getDateStringWithDateFormatte:(NSString *)formatter {
    NSDate *selected = [self.datePicker date];
    NSDateFormatter *fomatte = [[NSDateFormatter alloc] init];
    fomatte.dateFormat = formatter ? formatter : @"yyyy-MM-dd";
    NSString *timeStr = [fomatte stringFromDate:selected];
    return timeStr;
}

@end
