//
//  UniceHole.m
//  Speed Racer
//
//  Created by User-10 on 7/4/15.
//  Copyright (c) 2015 User-10. All rights reserved.
//

#import "UniceHole.h"




@implementation UniceHole

- (instancetype)initWithImageNamed:(NSString*)name sizeX:(NSInteger)sizeX sizeY:(NSInteger)sizeY
{
    self = [super initWithImageNamed:name];
    if (self) {
        self.sizeX = sizeX;
        self.sizeY = sizeY;
    }
    return self;
}
@end
