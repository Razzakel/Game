//
//  HoleGenerator.m
//  Speed Racer
//
//  Created by User-10 on 7/4/15.
//  Copyright (c) 2015 User-10. All rights reserved.
//

#import "HoleGenerator.h"


@implementation HoleGenerator


- (instancetype)init
{
    self = [super init];
    if (self) {
        UniceHole *hole0 = [[UniceHole alloc] initWithImageNamed:@"hole1.png" sizeX:60 sizeY:80];
        UniceHole *hole1 = [[UniceHole alloc] initWithImageNamed:@"hole2.png" sizeX:60 sizeY:70];
        UniceHole *hole2 = [[UniceHole alloc] initWithImageNamed:@"hole3.png" sizeX:60 sizeY:75];
        UniceHole *hole3 = [[UniceHole alloc] initWithImageNamed:@"waterPuddle1.png" sizeX:60 sizeY:70];
        UniceHole *hole4 = [[UniceHole alloc] initWithImageNamed:@"waterPuddle2.png" sizeX:60 sizeY:75];
        self.holeArray = @[hole0,hole1,hole2,hole3,hole4];
    }
    return self;
}

-(UniceHole*) generateHole
{
    NSInteger randomHole = arc4random_uniform(5);
    return [self.holeArray objectAtIndex:randomHole];
}


@end
