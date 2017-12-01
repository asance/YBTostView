//
//  ViewController.m
//  YBTostViewDemo
//
//  Created by asance on 2017/12/1.
//  Copyright © 2017年 asance. All rights reserved.
//

#import "ViewController.h"
#import "YBTostView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YBTostView showWithTitle:@"hello"];
}

@end
