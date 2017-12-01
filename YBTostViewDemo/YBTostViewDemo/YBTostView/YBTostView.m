//
//  YBTostView.m
//  YoubanLoan
//
//  Created by asance on 2017/8/6.
//  Copyright © 2017年 asance. All rights reserved.
//

#import "YBTostView.h"
#import "UIColor+HexInt.h"
#import "NSNumber+LayoutAdaptation.h"

@interface YBTostView ()<CAAnimationDelegate>
@property(strong, nonatomic) UIView *contentView;
@property(strong, nonatomic) UILabel *desLabel;
@property(assign, nonatomic) CGFloat animationDuration;
@property(assign, nonatomic) CGRect showReleateRect;
@property(assign, nonatomic) BOOL isAbove;
@end

@implementation YBTostView

+ (void)showWithTitle:(NSString *)title{
    YBTostView *view = [[YBTostView alloc] initWithFrame:[UIScreen mainScreen].bounds showReleateRect:CGRectZero above:YES];
    view.backgroundColor = [UIColor clearColor];
    [view setTitle:title];
    [[[UIApplication sharedApplication] keyWindow] addSubview:view];
    [view showWithAnmation];
    
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0f*NSEC_PER_SEC);
    dispatch_after(timer, dispatch_get_main_queue(), ^{
        [view dismissWithAnmation];
    });
}
+ (void)showWithTitle:(NSString *)title aboveView:(UIView *)aView{
    CGRect rect = CGRectZero;
    if(aView){
        rect = [aView.superview convertRect:aView.frame toView:nil];
    }
    YBTostView *view = [[YBTostView alloc] initWithFrame:[UIScreen mainScreen].bounds showReleateRect:rect above:YES];
    view.backgroundColor = [UIColor clearColor];
    [view setTitle:title];
    [[[UIApplication sharedApplication] keyWindow] addSubview:view];
    [view showWithAnmation];
    
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0f*NSEC_PER_SEC);
    dispatch_after(timer, dispatch_get_main_queue(), ^{
        [view dismissWithAnmation];
    });
}
+ (void)showWithTitle:(NSString *)title belowView:(UIView *)uView{
    CGRect rect = CGRectZero;
    if(uView){
        rect = [uView.superview convertRect:uView.frame toView:nil];
    }
    YBTostView *view = [[YBTostView alloc] initWithFrame:[UIScreen mainScreen].bounds showReleateRect:rect above:NO];
    view.backgroundColor = [UIColor clearColor];
    [view setTitle:title];
    [[[UIApplication sharedApplication] keyWindow] addSubview:view];
    [view showWithAnmation];
    
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0f*NSEC_PER_SEC);
    dispatch_after(timer, dispatch_get_main_queue(), ^{
        [view dismissWithAnmation];
    });
}
- (id)initWithFrame:(CGRect)frame showReleateRect:(CGRect)showReleateRect above:(BOOL)above{
    self = [super initWithFrame:frame];
    if(self){
        self.showReleateRect = showReleateRect;
        self.isAbove = above;
        self.animationDuration = 0.2f;
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.desLabel];
    }
    return self;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if(flag){
        [self removeFromSuperview];
    }
}

#pragma mark -
- (void)showWithAnmation{
    [self.contentView.layer addAnimation:[self fadeAnimation] forKey:@"fade"];
}
- (void)dismissWithAnmation{
    [self.contentView.layer addAnimation:[self disFadeAnimation] forKey:@"fade"];
}
- (void)setTitle:(NSString *)title{
    self.desLabel.text = title;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    CGFloat halfWidth = (width*0.7);
    
    CGFloat leftMargin = 10;
    
    CGFloat titleMinHeight = 23;
    CGFloat titleMaxWidth = (halfWidth-leftMargin*2);
    
    CGSize titleSize = [self textBoundingSizeWithMaxSize:CGSizeMake(titleMaxWidth, 1000) label:self.desLabel];
    CGFloat titleWidth = titleSize.width;
    titleWidth+=18;
    
    CGFloat titleHeight = titleSize.height;
    titleHeight+=5;
    if(titleHeight<titleMinHeight){
        titleHeight = titleMinHeight;
    }

    CGFloat contentWidth = titleWidth;
    CGFloat contentHeight = titleHeight;

    self.desLabel.frame = CGRectMake(0, 0, titleWidth, titleHeight);
    
    self.contentView.frame = CGRectMake(0, 0, contentWidth, contentHeight);
    
    if(self.showReleateRect.size.width==0||self.showReleateRect.size.height==0){
        self.contentView.center = CGPointMake(width*0.5, height*0.5-[NSNumber adaptToHeight:50]);
    }
    else{
        if(self.isAbove&&self.showReleateRect.origin.y>50){
            self.contentView.center = CGPointMake(width*0.5, self.showReleateRect.origin.y-contentHeight*0.5-8);
        }
        if((NO==self.isAbove)&&CGRectGetMaxY(self.showReleateRect)>0){
            self.contentView.center = CGPointMake(width*0.5, CGRectGetMaxY(self.showReleateRect)+contentHeight*0.5+8);
        }
    }
}

- (UIView *)contentView{
    if(!_contentView){
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.clipsToBounds = YES;
        _contentView.layer.cornerRadius = 5;
        _contentView.backgroundColor = [UIColor hexColor:@"000000" alpha:0.7];
    }
    return _contentView;
}
- (UILabel *)desLabel{
    if(!_desLabel){
        _desLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _desLabel.text = @"成功";
        _desLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _desLabel.numberOfLines = 0;
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.textColor = [UIColor whiteColor];
        _desLabel.font = [UIFont systemFontOfSize:[NSNumber adaptToHeight:14]];
    }
    return _desLabel;
}
- (CABasicAnimation *)disRiseAnimation{
    CGPoint point = self.contentView.layer.position;
    CGFloat edgeCenterY = (CGRectGetHeight(self.contentView.frame));
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.delegate = self;
    positionAnimation.repeatCount = 0;
    positionAnimation.duration = self.animationDuration;
    positionAnimation.removedOnCompletion = NO;
    positionAnimation.fillMode = kCAFillModeForwards;
    positionAnimation.fromValue = [NSValue valueWithCGPoint:point];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, point.y+edgeCenterY)];
    return positionAnimation;
}
- (CABasicAnimation *)fadeAnimation{
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    fadeAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    fadeAnimation.duration = self.animationDuration;
    fadeAnimation.removedOnCompletion = NO;
    fadeAnimation.fillMode = kCAFillModeForwards;
    return fadeAnimation;
}
- (CABasicAnimation *)disFadeAnimation{
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.delegate = self;
    fadeAnimation.fromValue = [NSNumber numberWithFloat:self.contentView.alpha];
    fadeAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    fadeAnimation.duration = self.animationDuration;
    fadeAnimation.removedOnCompletion = NO;
    fadeAnimation.fillMode = kCAFillModeForwards;
    return fadeAnimation;
}
- (CGSize)textBoundingSizeWithMaxSize:(CGSize)maxSize label:(UILabel *)label{
    if(0==label.text.length) return CGSizeZero;
    
    CGRect rect = [label.text boundingRectWithSize:maxSize
                                          options:(NSStringDrawingOptions)(NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin)
                                       attributes:@{NSFontAttributeName:label.font}
                                          context:nil];
    
    CGSize newrect = CGSizeMake(rect.size.width+5, rect.size.height+5);
    return newrect;
}
@end
