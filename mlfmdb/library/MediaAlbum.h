//
// Created by zhenhui on 2020/6/3.
// Copyright (c) 2020 zhenhui. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MediaAlbum : NSObject

@property(nonatomic, assign) NSInteger id;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, assign) NSInteger homonym;
@property(nonatomic, copy) NSString *grouping;
@property(nonatomic, copy) NSString *comment;
@property(nonatomic, retain) NSDate *createdDate;
@property(nonatomic, retain) NSDate *modifiedDate;

@end