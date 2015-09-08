//
//  Explosion.h
//  Speed Racer
//
//  Created by User-10 on 6/21/15.
//  Copyright (c) 2015 User-10. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Explosion : SKSpriteNode

@property NSArray *explosionFrames;
@property NSInteger sizeX;
@property NSInteger sizeY;
@property NSInteger stakZPosition;

- (instancetype)initWithImageNamed:(NSString*)imgName;
+ (Explosion *)generateNewExplosion:(NSString*) name;
@end
