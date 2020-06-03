
#import <Foundation/Foundation.h>
#import "MediaItem.h"
#import "MediaLibrary.h"
#import "MediaLibrary+Operation.h"

static void __test();

int main(int argc, const char *argv[]) {

    [MediaLibrary sharedInstance];

    __test();


    return 0;
}


void __test() {


    MediaItem *mediaItem = [[MediaItem alloc] init];

    mediaItem.id = @"12345678";

    [[MediaLibrary sharedInstance] insertMediaItem:mediaItem];

}