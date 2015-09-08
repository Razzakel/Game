//
//  Car.m
//  Speed Racer
//
//  Created by User-10 on 7/4/15.
//  Copyright (c) 2015 User-10. All rights reserved.
//

#import "Car.h"

@implementation Car

- (instancetype)initWithImageNamed:(NSString*)name sizeX:(NSInteger)sizeX sizeY:(NSInteger)sizeY  carDirection:(NSInteger)carDirection
{
    self = [super initWithImageNamed:name];
    if (self) {
        self.sizeX = sizeX;
        self.sizeY = sizeY;
        self.carDirection = carDirection;
        self.startPosition = 100;
        self.speedY = 4;
    }
    return self;
}

@end
