//
// Created by zhenhui on 2020/6/3.
// Copyright (c) 2020 zhenhui. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MediaDirectory : NSObject

@property(nonatomic, retain) NSNumber *id;
@property(nonatomic, copy) NSString *parent;
@property(nonatomic, copy) NSString *name;


@end