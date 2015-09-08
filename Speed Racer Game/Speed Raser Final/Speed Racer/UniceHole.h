//
//  UniceHole.h
//  Speed Racer
//
//  Created by User-10 on 7/4/15.
//  Copyright (c) 2015 User-10. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface UniceHole : SKSpriteNode


@property NSInteger sizeX,sizeY;

- (instancetype)initWithImageNamed:(NSString*)name sizeX:(NSInteger)sizeX sizeY:(NSInteger)sizeY;

@end
