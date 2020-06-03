//
// Created by zhenhui on 2020/6/3.
// Copyright (c) 2020 zhenhui. All rights reserved.
//

#import <FMDB/FMDatabase.h>
#import <FMDB/FMDatabaseQueue.h>
#import "MediaLibrary.h"
#import "Schema.h"

@implementation MediaLibrary

+ (void)setup {
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.db"];

    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:path];
    if (queue) {
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            BOOL success = [db executeStatements:kCreateMediaItemTable];
            success &= [db executeStatements:kCreateMediaArtistTable];
            success &= [db executeStatements:kCreateMediaAlbumTable];
            success &= [db executeStatements:kCreateMediaGenreTable];
            success &= [db executeStatements:kCreateMediaAlbumArtistTable];
            success &= [db executeStatements:kCreateMediaArtistItemTable];
            success &= [db executeStatements:kCreateMediaAlbumItemTable];
            success &= [db executeStatements:kCreateMediaGenreItemTable];
            success &= [db executeStatements:kCreateMediaDirectoryTable];
            success &= [db executeStatements:kCreateMediaDirectoryItemTable];
            *rollback = !success;
        }];
    }

}

@end