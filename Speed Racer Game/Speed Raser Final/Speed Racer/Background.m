//
//  Background.m
//  Speed Racer
//
//  Created by User-10 on 6/21/15.
//  Copyright (c) 2015 User-10. All rights reserved.
//

#import "Background.h"

@implementation Background
+ (Background *)generateNewBackground :(NSString*)level
{
    NSString * temp = [NSString stringWithFormat:@"finalRoadMap%@.jpg",level ];
    Background *background = [[Background alloc]
                              initWithImageNamed:temp];
    background.anchorPoint = CGPointMake(0, 0);
    background.name = @"background";
    background.position = CGPointMake(0, 0);
    return background;
}
@end
