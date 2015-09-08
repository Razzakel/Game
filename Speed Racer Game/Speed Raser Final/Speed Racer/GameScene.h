//
//  GameScene.h
//  Speed Racer
//

//  Copyright (c) 2015 User-10. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@interface GameScene : SKScene

@property NSInteger level;

-(id)initWithSize:(CGSize)size andLavel:(NSInteger)level;

@end
