//
//  ViewController.m
//  DatePicker
//
//  Created by mac on 2016/12/2.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ViewController.h"
#import "FECDatePickView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)click:(id)sender {
    FECDatePickView *date = [FECDatePickView shareInstanceAction];
    date.datePicker.datePickerMode = UIDatePickerModeTime;
    date.dateFormatterStr = @"HH:mm";
    [date showDatePickView:^(NSString *dateStr) {
        self.lb_time.text = dateStr;
    }];
}

- (IBAction)clickMehtod:(id)sender {
    FECDatePickView *date = [FECDatePickView shareInstanceAlert];
    [date showDatePickView:^(NSString *dateStr) {
        self.lb_time.text = dateStr;
    }];
}

@end
