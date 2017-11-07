//
//  Book.m
//  Hello4_OC
//
//  Created by leven on 2017/11/3.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "Book.h"

@implementation Book

- (instancetype)init
{
    // 1. 调用 父类的方法给父类初始化
    self = [super init];
    
    // 2. 为什么要有 if 呢？ -> 有可能会初始化错误
    if (self) {
        _bookName = @"iPhone";
    }
    return self;
}
@end
