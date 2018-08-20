//
//  ViewController.m
//  WTDateUtil
//
//  Created by WT on 2018/8/20.
//  Copyright © 2018年 王通. All rights reserved.
//

#import "ViewController.h"
#import "WTDateUtil.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", [[NSDate date] dateTimeStringWithFormat:@"yyyy MM dd HH mm ss"]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
