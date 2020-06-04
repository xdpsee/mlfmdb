//
// Created by zhenhui on 2020/6/4.
// Copyright (c) 2020 zhenhui. All rights reserved.
//

#import "NSString+Utils.h"


@implementation NSString (Utils)

- (BOOL)isEmpty {

    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [self stringByTrimmingCharactersInSet:charSet];
    return [trimmed isEqualToString:@""];

}

@end