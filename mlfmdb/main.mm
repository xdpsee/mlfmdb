
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "MediaItem.h"
#import "MediaLibrary.h"
#import "MediaLibrary+Operation.h"
#import "NSString+SHA1.h"

static void __test();

int main(int argc, const char *argv[]) {

    @autoreleasepool {
        [MediaLibrary sharedInstance];

        __test();
    }

    return 0;
}


void __test() {

    MediaItem *mediaItem = [[MediaItem alloc] init];

    mediaItem.source = 0;
    mediaItem.uri = @"/Users/zhenhui/audio_test/za112.flac";
    mediaItem.id = [mediaItem.uri sha1];
    mediaItem.title = @"不知道";
    mediaItem.grouping = @"B";
    mediaItem.artist = @"李克勤";
    mediaItem.album = @"最爱";
    mediaItem.genre = @"流行";
    mediaItem.composer = @"林夕";
    mediaItem.year = 2007;
    mediaItem.track = 1;
    mediaItem.duration = 284;
    mediaItem.createdDate = [NSDate now];
    mediaItem.modifiedDate = [NSDate now];


    CFTimeInterval c = CACurrentMediaTime();
    [[MediaLibrary sharedInstance] insertMediaItem:mediaItem];
    NSLog(@"use time: %@", @(CACurrentMediaTime() - c));

}