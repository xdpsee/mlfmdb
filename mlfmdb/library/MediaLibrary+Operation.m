//
// Created by zhenhui on 3.6.20.
// Copyright (c) 2020 zhenhui. All rights reserved.
//

#import <FMDB/FMDatabaseQueue.h>
#import "MediaLibrary+Operation.h"
#import "MediaItem.h"
#import "Schema.h"

@implementation MediaLibrary (Operation)

- (BOOL)insertMediaItem:(MediaItem *)mediaItem {

    [_databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {

        BOOL success = [db executeUpdate:kInsertMediaItemTable withArgumentsInArray:@[
                mediaItem.id,
                @(mediaItem.source),
                mediaItem.uri,
                mediaItem.grouping,
                mediaItem.title,
                mediaItem.artist,
                mediaItem.album,
                mediaItem.genre,
                mediaItem.composer,
                @(mediaItem.track),
                @(mediaItem.year),
                @(mediaItem.duration),
                mediaItem.createdDate,
                mediaItem.modifiedDate
        ]];
        if (success) {

        }
    }];

    return NO;
}


@end