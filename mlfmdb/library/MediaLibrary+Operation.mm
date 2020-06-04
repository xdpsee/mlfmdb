//
// Created by zhenhui on 3.6.20.
// Copyright (c) 2020 zhenhui. All rights reserved.
//

#import <FMDB/FMDatabaseQueue.h>
#import "MediaLibrary+Operation.h"
#import "NSString+Utils.h"
#import "MediaItem.h"
#import "MediaArtist.h"
#import "MediaAlbum.h"

static NSString *UNKNOWN = @"未知";

@implementation MediaLibrary (Operation)

- (BOOL)insertMediaItem:(MediaItem *)mediaItem {

    [self prepare:mediaItem];

    __block BOOL result = NO;
    [_databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL success = [db executeUpdate:@"insert into medias (id,source,uri,grouping,title,artist,album,genre,composer,track,year,duration,created_date,modified_date) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
                    withArgumentsInArray:@[
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
        if (!success) {
            *rollback = YES;
            return;
        }

        NSInteger artistId = [self insertArtist:mediaItem.artist inDB:db ignoreUnique:NO];
        if (artistId <= 0) {
            *rollback = YES;
            return;
        }

        NSInteger albumId = [self insertAlbum:mediaItem.album inDB:db ignoreUnique:NO];
        if (albumId <= 0) {
            *rollback = YES;
            return;
        }

        NSInteger genreId = [self insertGenre:mediaItem.genre inDB:db];
        if (genreId <= 0) {
            *rollback = YES;
            return;
        }

        success = [self bindArtist:artistId item:mediaItem.id inDB:db];
        success &= [self bindAlbum:albumId item:mediaItem.id inDB:db];
        success &= [self bindGenre:genreId item:mediaItem.id inDB:db];
        success &= [self bindAlbum:albumId artist:artistId inDB:db];
        if (!success) {
            *rollback = YES;
            return;
        }

        if (mediaItem.source == 0) { // local file
            NSInteger directoryId = [self insertDirectory:mediaItem inDB:db];
            if (directoryId > 0 && [self bindDirectory:directoryId item:mediaItem.id inDB:db]) {
                success = YES;
            } else {
                *rollback = YES;
                success = NO;
            }
        }

        result = success;
    }];

    return result;
}

#pragma mark - Private Methods

- (void)prepare:(MediaItem *)mediaItem {

    mediaItem.id = [mediaItem.uri sha1];

    if (!mediaItem.title || [mediaItem.title isEmpty]) {
        mediaItem.title = [self extractFilenameFromUri:mediaItem.uri];
    }

    mediaItem.grouping = [mediaItem.title headLetter];

    if (!mediaItem.artist || [mediaItem.artist isEmpty]) {
        mediaItem.artist = UNKNOWN;
    }
    if (!mediaItem.album || [mediaItem.album isEmpty]) {
        mediaItem.album = UNKNOWN;
    }
    if (!mediaItem.genre || [mediaItem.genre isEmpty]) {
        mediaItem.genre = UNKNOWN;
    }

    if (!mediaItem.composer || [mediaItem.composer isEmpty]) {
        mediaItem.composer = UNKNOWN;
    }

    if (!mediaItem.createdDate) {
        mediaItem.createdDate = [NSDate now];
    }

    if (!mediaItem.modifiedDate) {
        mediaItem.modifiedDate = [NSDate now];
    }

}

- (NSInteger)insertArtist:(NSString *)artist inDB:(FMDatabase *)db ignoreUnique:(BOOL)ignore {

    NSInteger artistId = 0;
    BOOL success;
    NSError *error;

    NSInteger homonym = ignore ? [self selectArtistCount:artist inDB:db] : 0;
    success = [db executeUpdate:@"insert or ignore into artists(title,homonym,grouping,comment,created_date,modified_date) values(?,?,?,?,?,?)"
                         values:@[artist, @(homonym), [artist headLetter], @"", [NSDate now], [NSDate now]]
                          error:&error];
    if (success) {
        artistId = [self selectArtistId:artist homonym:homonym inDB:db];
    }

    if (error) {
        NSLog(@"insertAlbum:ignoreUnique: error, %@", error);
    }

    return artistId;
}

- (NSInteger)insertAlbum:(NSString *)album inDB:(FMDatabase *)db ignoreUnique:(BOOL)ignore {

    NSInteger albumId = 0;
    BOOL success;
    NSError *error;

    NSInteger homonym = ignore ? [self selectAlbumCount:album inDB:db] : 0;
    success = [db executeUpdate:@"insert or ignore into albums(title,homonym,grouping,comment,created_date,modified_date) values(?,?,?,?,?,?)"
                         values:@[album, @(homonym), [album headLetter], @"", [NSDate now], [NSDate now]]
                          error:&error];
    if (success) {
        albumId = [self selectAlbumId:album homonym:homonym inDB:db];
    }

    if (error) {
        NSLog(@"insertAlbum:ignoreUnique: error, %@", error);
    }

    return albumId;
}

- (NSInteger)insertGenre:(NSString *)genre inDB:(FMDatabase *)db {

    NSInteger genreId = 0;
    NSError *error;
    BOOL success = [db executeUpdate:@"insert or ignore into genres(title,grouping) values(?,?)"
                              values:@[genre, [genre headLetter]]
                               error:&error];
    if (success) {
        genreId = [self selectGenreId:genre inDB:db];
    }

    if (error) {
        NSLog(@"insertGenre:inDB: error, %@", error);
    }

    return genreId;

}

- (NSInteger)insertDirectory:(MediaItem *)mediaItem inDB:(FMDatabase *)db {

    if (mediaItem.source != 0) {
        return 0;
    }

    // TODO:
    return 0;

}

- (NSString *)extractFilenameFromUri:(NSString *)uri {

    if ([uri isEmpty]) {
        return nil;
    }

    NSArray *parts = [uri componentsSeparatedByString:@"/"];
    NSString *filename = [parts lastObject];
    NSRange range = [filename rangeOfString:@"." options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        return [filename substringToIndex:range.location];
    }

    return filename;
}


- (NSArray<MediaArtist *> *)selectArtists:(NSString *)artist inDB:(FMDatabase *)db {

    NSError *error;
    FMResultSet *rs = [db executeQuery:@"select * from artists where title = ?" values:@[artist] error:&error];
    if (error) {
        NSLog(@"selectArtists:inDB: error, %@", error);
    }

    NSMutableArray<MediaArtist *> *result = [[NSMutableArray alloc] init];
    while (rs.next) {
        MediaArtist *item = [[MediaArtist alloc] init];
        item.id = [rs intForColumn:@"id"];
        item.title = [rs stringForColumn:@"title"];
        item.homonym = [rs intForColumn:@"homonym"];
        item.grouping = [rs stringForColumn:@"grouping"];
        item.comment = [rs stringForColumn:@"comment"];
        item.createdDate = [rs dateForColumn:@"created_date"];
        item.modifiedDate = [rs dateForColumn:@"modified_date"];
        [result addObject:item];
    }

    [rs close];

    return result;
}

- (NSArray<MediaAlbum *> *)selectAlbums:(NSString *)album inDB:(FMDatabase *)db {

    NSError *error;
    FMResultSet *rs = [db executeQuery:@"select * from albums where title = ?" values:@[album] error:&error];
    if (error) {
        NSLog(@"selectAlbums:inDB: error, %@", error);
    }

    NSMutableArray<MediaAlbum *> *result = [[NSMutableArray alloc] init];
    while (rs.next) {
        MediaAlbum *item = [[MediaAlbum alloc] init];
        item.id = [rs intForColumn:@"id"];
        item.title = [rs stringForColumn:@"title"];
        item.homonym = [rs intForColumn:@"homonym"];
        item.grouping = [rs stringForColumn:@"grouping"];
        item.comment = [rs stringForColumn:@"comment"];
        item.createdDate = [rs dateForColumn:@"created_date"];
        item.modifiedDate = [rs dateForColumn:@"modified_date"];
        [result addObject:item];
    }

    [rs close];

    return result;
}

- (NSInteger)selectArtistId:(NSString *)artist homonym:(NSInteger)homonym inDB:(FMDatabase *)db {

    NSError *error = nil;
    FMResultSet *rs = [db executeQuery:@"select id from artists where title = ? and homonym = ? limit 1"
                                values:@[artist, @(homonym)]
                                 error:&error];
    if (error) {
        NSLog(@"selectArtistId:homonym:inDB: error, %@", error);
    }

    if (rs.next) {
        return [rs intForColumnIndex:0];
    }

    return 0;
}

- (NSInteger)selectArtistCount:(NSString *)artist inDB:(FMDatabase *)db {
    NSError *error = nil;
    FMResultSet *rs = [db executeQuery:@"select count(1) from artists where title = ?"
                                values:@[artist]
                                 error:&error];
    if (error) {
        NSLog(@"selectArtistCount:inDB: error, %@", error);
    }

    if (rs.next) {
        return [rs intForColumnIndex:0];
    }

    return 0;
}

- (NSInteger)selectAlbumId:(NSString *)album homonym:(NSInteger)homonym inDB:(FMDatabase *)db {
    NSError *error = nil;
    FMResultSet *rs = [db executeQuery:@"select id from albums where title = ? and homonym = ? limit 1"
                                values:@[album, @(homonym)]
                                 error:&error];
    if (error) {
        NSLog(@"selectAlbumId:homonym:inDB: error, %@", error);
    }

    if (rs.next) {
        return [rs intForColumnIndex:0];
    }

    return 0;
}

- (NSInteger)selectAlbumCount:(NSString *)album inDB:(FMDatabase *)db {
    NSError *error = nil;
    FMResultSet *rs = [db executeQuery:@"select count(1) from albums where title = ?"
                                values:@[album]
                                 error:&error];
    if (error) {
        NSLog(@"selectAlbumCount:inDB: error, %@", error);
    }

    if (rs.next) {
        return [rs intForColumnIndex:0];
    }

    return 0;
}

- (NSInteger)selectGenreId:(NSString *)genre inDB:(FMDatabase *)db {
    NSError *error = nil;
    FMResultSet *rs = [db executeQuery:@"select id from genres where title = ? limit 1"
                                values:@[genre]
                                 error:&error];
    if (error) {
        NSLog(@"selectGenreId:inDB: error, %@", error);
    }

    if (rs.next) {
        return [rs intForColumnIndex:0];
    }

    return 0;
}

- (BOOL)bindArtist:(NSInteger)artistId item:(NSString *)itemId inDB:(FMDatabase *)db {

    NSError *error = nil;
    BOOL success = [db executeUpdate:@"insert or ignore into artist_items(artist_id, item_id) values(?,?)" values:@[@(artistId), itemId] error:&error];
    if (error) {
        NSLog(@"bindArtist:item:inDB: error, %@", error);
    }

    return success;
}

- (BOOL)bindAlbum:(NSInteger)albumId item:(NSString *)itemId inDB:(FMDatabase *)db {

    NSError *error = nil;
    BOOL success = [db executeUpdate:@"insert or ignore into album_items(album_id, item_id) values(?,?)" values:@[@(albumId), itemId] error:&error];
    if (error) {
        NSLog(@"bindAlbum:item:inDB: error, %@", error);
    }

    return success;
}

- (BOOL)bindGenre:(NSInteger)genreId item:(NSString *)itemId inDB:(FMDatabase *)db {
    NSError *error = nil;
    BOOL success = [db executeUpdate:@"insert or ignore into genre_items(genre_id, item_id) values(?,?)" values:@[@(genreId), itemId] error:&error];
    if (error) {
        NSLog(@"bindGenre:item:inDB: error, %@", error);
    }

    return success;
}

- (BOOL)bindAlbum:(NSInteger)albumId artist:(NSInteger)artistId inDB:(FMDatabase *)db {
    NSError *error = nil;
    BOOL success = [db executeUpdate:@"insert or ignore into album_artists(album_id, artist_id) values(?,?)" values:@[@(albumId), @(artistId)] error:&error];
    if (error) {
        NSLog(@"bindGenre:item:inDB: error, %@", error);
    }

    return success;
}

- (BOOL)bindDirectory:(NSInteger)directoryId item:(NSString *)itemId inDB:(FMDatabase *)db {
    NSError *error = nil;
    BOOL success = [db executeUpdate:@"insert or ignore into directory_items(directoryId, itemId) values(?,?)" values:@[@(directoryId), itemId] error:&error];
    if (error) {
        NSLog(@"bindDirectory:item:inDB: error, %@", error);
    }

    return success;
}

@end

