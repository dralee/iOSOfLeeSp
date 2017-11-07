//
//  ViewController.m
//  Hello3_OC
//
//  Created by leven on 2017/11/3.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, copy) void (^completionCallback)();
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData:^{
        NSLog(@"%@", self.view);
    }];
}

- (void)loadData:(void (^)(void)) completion{
    // 使用属性记录block
    self.completionCallback = completion;
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSLog(@"耗时操作 %@", [NSThread currentThread]);
        
        [NSThread sleepForTimeInterval: 2.0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 执行block
            completion();
        });
    });
    
}

- (void)dealloc
{
    NSLog(@"我去了");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
