//
//  MBProgressHUD+SQ.h
//
//  Created by SQ on 15-12-18.
//  Copyright (c) 2015年 Conquer. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (SQ)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end
