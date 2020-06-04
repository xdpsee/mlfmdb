//
// Created by zhenhui on 2020/6/3.
// Copyright (c) 2020 zhenhui. All rights reserved.
//

#import "MediaDirectory.h"


@implementation MediaDirectory
@synthesize id = _id, parent = _parent, name = _name, grouping = _grouping;

- (void)dealloc {

    _name = nil;
    _grouping = nil;
    _parent = nil;

}

@end