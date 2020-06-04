#import "Schema.h"

NSString *const kCreateMediaItemTable = @"create table if not exists medias\n"
                                        "(\n"
                                        "    id            varchar(40)  not null primary key,\n"
                                        "    source        integer      not null,\n"
                                        "    uri           varchar(256) not null,\n"
                                        "    grouping      char         not null,\n"
                                        "    title         varchar(128) not null,\n"
                                        "    artist        varchar(64) default '',\n"
                                        "    album         varchar(64) default '',\n"
                                        "    genre         varchar(64) default '',\n"
                                        "    composer      varchar(64) default '',\n"
                                        "    track         integer     default -1,\n"
                                        "    year          integer     default -1,\n"
                                        "    duration      integer     default -1,\n"
                                        "    play_times    integer     default 0,\n"
                                        "    favorite      tinyint     default 0,\n"
                                        "    created_date  datetime     not null,\n"
                                        "    modified_date datetime     not null\n"
                                        ");";

NSString *const kCreateMediaArtistTable = @"create table if not exists artists\n"
                                          "(\n"
                                          "    id            integer     not null primary key autoincrement,\n"
                                          "    grouping      char        not null,\n"
                                          "    title         varchar(64) not null,\n"
                                          "    homonym       integer      default 0, \n"
                                          "    comment       varchar(256) default '',\n"
                                          "    created_date  datetime    not null,\n"
                                          "    modified_date datetime    not null,\n"
                                          "    constraint uk_title_homonym unique (title, homonym)\n"
                                          ");";

NSString *const kCreateMediaAlbumTable = @"create table if not exists albums\n"
                                         "(\n"
                                         "    id            integer     not null primary key autoincrement,\n"
                                         "    title         varchar(64) not null,\n"
                                         "    grouping      char        not null,\n"
                                         "    homonym       integer      default 0,\n"
                                         "    comment       varchar(256) default '',\n"
                                         "    created_date  datetime    not null,\n"
                                         "    modified_date datetime    not null,\n"
                                         "    constraint uk_title_homonym unique (title, homonym)\n"
                                         ");";

NSString *const kCreateMediaGenreTable = @"create table if not exists genres\n"
                                         "(\n"
                                         "    id       integer     not null primary key autoincrement,\n"
                                         "    grouping char        not null,\n"
                                         "    title    varchar(64) not null unique\n"
                                         ");";

NSString *const kCreateMediaAlbumArtistTable = @"create table if not exists album_artists\n"
                                               "(\n"
                                               "    album_id  integer     not null,\n"
                                               "    artist_id varchar(40) not null,\n"
                                               "    constraint uk_album_artist unique (album_id, artist_id)\n"
                                               ");";

NSString *const kCreateMediaArtistItemTable = @"create table if not exists artist_items\n"
                                              "(\n"
                                              "    artist_id integer     not null,\n"
                                              "    item_id  varchar(40) not null,\n"
                                              "    constraint uk_genre_item unique (artist_id, item_id)\n"
                                              ");";

NSString *const kCreateMediaAlbumItemTable = @"create table if not exists album_items\n"
                                             "(\n"
                                             "    album_id integer     not null,\n"
                                             "    item_id  varchar(40) not null,\n"
                                             "    constraint uk_album_item unique (album_id, item_id)\n"
                                             ");";

NSString *const kCreateMediaGenreItemTable = @"create table if not exists genre_items\n"
                                             "(\n"
                                             "    genre_id integer     not null,\n"
                                             "    item_id  varchar(40) not null,\n"
                                             "    constraint uk_genre_item unique (genre_id, item_id)\n"
                                             ");";

NSString *const kCreateMediaDirectoryTable = @"create table if not exists directories\n"
                                             "(\n"
                                             "    id     integer      not null primary key autoincrement,\n"
                                             "    parent varchar(256) not null,\n"
                                             "    name   varchar(256) not null,\n"
                                             "    constraint uk_path unique (parent, name)\n"
                                             ");";

NSString *const kCreateMediaDirectoryItemTable = @"create table if not exists directory_items\n"
                                                 "(\n"
                                                 "    directory_id integer     not null,\n"
                                                 "    item_id      varchar(40) not null,\n"
                                                 "    constraint uk_directory_item unique (directory_id, item_id)\n"
                                                 ");";