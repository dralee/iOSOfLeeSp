//
//  ViewController.m
//  OCDelayLoad
//
//  Created by leven on 2017/11/7.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"开始加载");
    
    // 2秒
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
    /**
     延时加载

     @param when: 从现在开始经过多少纳秒
     @param dispatch_get_main_queue ：由队列调度任务
     @return return value description
     */
    dispatch_after(when, dispatch_get_main_queue(), ^{
        NSLog(@"----------------");
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
