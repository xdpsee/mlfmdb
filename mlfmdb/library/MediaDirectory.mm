//
// Created by zhenhui on 2020/6/3.
// Copyright (c) 2020 zhenhui. All rights reserved.
//

#import "MediaDirectory.h"


@implementation MediaDirectory
@synthesize id = _id, parent = _parent, name = _name;

- (void)dealloc {

    _id = nil;
    _parent = nil;
    _name = nil;

}

@end