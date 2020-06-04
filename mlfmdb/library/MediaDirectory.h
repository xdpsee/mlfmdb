//
// Created by zhenhui on 2020/6/3.
// Copyright (c) 2020 zhenhui. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MediaDirectory : NSObject

@property(nonatomic, assign) NSInteger id;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *grouping;
@property(nonatomic, copy) NSString *parent;

@end