//
// Created by zhenhui on 2020/6/3.
// Copyright (c) 2020 zhenhui. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MediaLibrary : NSObject {
@protected
    FMDatabaseQueue *_databaseQueue;
}

+ (id) sharedInstance;

@end