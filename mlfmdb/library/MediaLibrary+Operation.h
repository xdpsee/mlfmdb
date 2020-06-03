//
// Created by zhenhui on 3.6.20.
// Copyright (c) 2020 zhenhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaLibrary.h"

@class MediaItem;


@interface MediaLibrary (Operation)

- (BOOL) insertMediaItem:(MediaItem*) mediaItem;

@end