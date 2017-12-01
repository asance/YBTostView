//
//  YBTostView.h
//  YoubanLoan
//
//  Created by asance on 2017/8/6.
//  Copyright © 2017年 asance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBTostView : UIView
/**Show toast view*/
+ (void)showWithTitle:(NSString *)title;
/**Show the toast view above the specified view*/
+ (void)showWithTitle:(NSString *)title aboveView:(UIView *)aView;
/**Show the toast view below the specified view*/
+ (void)showWithTitle:(NSString *)title belowView:(UIView *)uView;
@end
