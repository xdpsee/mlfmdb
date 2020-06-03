//
// Created by zhenhui on 2020/6/3.
// Copyright (c) 2020 zhenhui. All rights reserved.
//

#import "MediaArtistItem.h"


@implementation MediaArtistItem
@synthesize artistId = _artistId, itemId = _itemId;

- (void)dealloc {
    _itemId = nil;
}

@end