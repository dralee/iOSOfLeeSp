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
    
//    // 解除循环引用1：__weak
//    __weak typeof(self) weakSelf = self;
//    [self loadData:^{
//        NSLog(@"%@", weakSelf.view);
//    }];

    // 解除循环引用2：__unsafe_unretained
    // 高级 iOS 程序员如果需要自行管理内存，可以考虑使用，但是不建议使用！
    // EXC_BAD_ACCESS 坏内存访问，野指针访问
    // __unsafe_unretained 同样是 assign 的引用（MRC 中没有 weak）
    // 在 MRC 中如果要弱引用对象都是使用 assign，不会增加引用计数但是一旦对象被释放，地址不会改变，继续访问，出现野指针
    // 在 ARC 中 weak，本质上是一个观察者模式，一旦发现对象被释放，会自动将地址设置为nil，更加安全
    
    // 效率：weak 的效率会略微差一些！
    __unsafe_unretained typeof(self) weakSelf = self;
    [self loadData:^{
        NSLog(@"%@", weakSelf.view);
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
