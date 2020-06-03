//
// Created by zhenhui on 2020/6/3.
// Copyright (c) 2020 zhenhui. All rights reserved.
//

#import "MediaAlbum.h"


@implementation MediaAlbum
@synthesize id = _id, title = _title, homonym = _homonym, grouping = _grouping, comment = _comment, createdDate = _createdDate, modifiedDate = _modifiedDate;

- (void)dealloc {
    _id = nil;
    _title = nil;
    _grouping = nil;
    _comment = nil;
    _createdDate = nil;
    _modifiedDate = nil;
}

@end