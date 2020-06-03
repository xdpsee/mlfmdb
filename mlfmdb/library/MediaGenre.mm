//
// Created by zhenhui on 2020/6/3.
// Copyright (c) 2020 zhenhui. All rights reserved.
//

#import "MediaGenre.h"


@implementation MediaGenre
@synthesize id = _id, title = _title, grouping = _grouping;

- (void)dealloc {

    _id = nil;
    _title = nil;
    _grouping = nil;

}

@end