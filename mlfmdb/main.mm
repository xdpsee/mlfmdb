
#import <Foundation/Foundation.h>
#import "MediaItem.h"
#import "MediaLibrary.h"

static void __test();

int main(int argc, const char *argv[]) {


    [MediaLibrary setup];

    __test();


    return 0;
}


void __test() {


    MediaItem *mediaItem = [[MediaItem alloc] init];

    mediaItem.id = @"12345678";


}