//
// Created by zhenhui on 2020/6/3.
// Copyright (c) 2020 zhenhui. All rights reserved.
//

#import <FMDB/FMDatabase.h>
#import <FMDB/FMDatabaseQueue.h>
#import "MediaLibrary.h"
#import "Schema.h"

@interface MediaLibrary ()

- (instancetype)init;

- (void)setup;

@end

@implementation MediaLibrary

+ (id)sharedInstance {
    static MediaLibrary *sharedMyInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[MediaLibrary alloc] init];
    });
    return sharedMyInstance;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

- (id)init {
    if (self = [super init]) {
        _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:@"/Users/zhenhui/medias.db"];
        [self setup];
    }

    return self;
}


- (void)setup {
    [_databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
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

@end