//
// Created by zhenhui on 2020/6/3.
// Copyright (c) 2020 zhenhui. All rights reserved.
//

#import "MediaAlbumItem.h"


@implementation MediaAlbumItem
@synthesize albumId = _albumId,itemId = _itemId;

- (void) dealloc {
    _itemId = nil;
}

@end