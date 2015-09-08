//
//  CarGenerator.m
//  Speed Racer
//
//  Created by User-10 on 7/4/15.
//  Copyright (c) 2015 User-10. All rights reserved.
//

#import "CarGenerator.h"

@implementation CarGenerator

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        Car *polise1 = [[Car alloc] initWithImageNamed: @"police1.png" sizeX:40 sizeY:85 carDirection:1];
        Car *polise2 = [[Car alloc] initWithImageNamed: @"police2.png" sizeX:45 sizeY:85 carDirection:1];
        Car *taxi = [[Car alloc] initWithImageNamed: @"taxi.png" sizeX:45 sizeY:80 carDirection:1];
        Car *truck2 = [[Car alloc] initWithImageNamed: @"truck2.png" sizeX:45 sizeY:90 carDirection:1];
        Car *truck3 = [[Car alloc] initWithImageNamed: @"truck3.png" sizeX:45 sizeY:85  carDirection:1];
        Car *truck4 = [[Car alloc] initWithImageNamed: @"truck4.png" sizeX:45 sizeY:130  carDirection:1];
        Car *lineika = [[Car alloc] initWithImageNamed: @"lineika.png" sizeX:45 sizeY:100  carDirection:1];
        Car *kola6b = [[Car alloc] initWithImageNamed: @"kola6b.png" sizeX:45 sizeY:80  carDirection:1];
        Car *kola7b = [[Car alloc] initWithImageNamed: @"kola7b.png" sizeX:45 sizeY:70  carDirection:1];
        Car *kola8b = [[Car alloc] initWithImageNamed: @"kola8b.png" sizeX:45 sizeY:75  carDirection:1];
        Car *kola2 = [[Car alloc] initWithImageNamed: @"kola2.png" sizeX:45 sizeY:88  carDirection:1];
        Car *kola3 = [[Car alloc] initWithImageNamed: @"kola3.png" sizeX:45 sizeY:90  carDirection:1];
        Car *kola4 = [[Car alloc] initWithImageNamed: @"kola5b.png" sizeX:45 sizeY:70  carDirection:1];
        
        self.carArray = @[polise1,polise2,taxi,truck2,truck3,truck4,lineika,kola6b,kola7b,kola8b,kola2,kola3,kola4];
        
    }
    return self;
}

-(Car*) generateCar

{
    NSInteger randomHole = arc4random_uniform(12);
    return [self.carArray objectAtIndex:randomHole];
}

-(Car*) carAtIndex:(NSInteger) carIndex
{
    return [self.carArray objectAtIndex:carIndex];
}

@end
