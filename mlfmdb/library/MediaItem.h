//
// Created by zhenhui on 2020/6/3.
// Copyright (c) 2020 zhenhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaItem : NSObject

@property(nonatomic, copy) NSString *id;
@property(nonatomic, assign) NSInteger source;
@property(nonatomic, copy) NSString *uri;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *grouping;
@property(nonatomic, copy) NSString *artist;
@property(nonatomic, copy) NSString *album;
@property(nonatomic, copy) NSString *genre;
@property(nonatomic, copy) NSString *composer;
@property(nonatomic, assign) NSInteger track;
@property(nonatomic, assign) NSInteger year;
@property(nonatomic, assign) NSInteger duration;
@property(nonatomic, assign) NSInteger playTimes;
@property(nonatomic, assign) BOOL favorite;
@property(nonatomic, retain) NSDate *createdDate;
@property(nonatomic, retain) NSDate *modifiedDate;

@end


