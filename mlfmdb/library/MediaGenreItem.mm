//
// Created by zhenhui on 2020/6/3.
// Copyright (c) 2020 zhenhui. All rights reserved.
//

#import "MediaGenreItem.h"


@implementation MediaGenreItem
@synthesize genreId, itemId = _itemId;

- (void)dealloc {

    _itemId = nil;

}

@end