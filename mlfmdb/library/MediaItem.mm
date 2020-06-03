//
// Created by zhenhui on 2020/6/3.
// Copyright (c) 2020 zhenhui. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "MediaItem.h"


@implementation MediaItem
@synthesize id = _id, source = _source, uri = _uri, title = _title, grouping = _grouping, album = _album, artist = _artist, genre = _genre, composer = _composer, track = _track, year = _year, duration = _duration, playTimes = _playTimes;

- (void)dealloc {
    _id = nil;
    _uri = nil;
    _title = nil;
    _grouping = nil;
    _album = nil;
    _artist = nil;
    _genre = nil;
    _composer = nil;
    _createdDate = nil;
    _modifiedDate = nil;
}

@end