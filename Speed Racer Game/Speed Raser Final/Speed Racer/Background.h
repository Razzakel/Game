//
//  Background.h
//  Speed Racer
//
//  Created by User-10 on 6/21/15.
//  Copyright (c) 2015 User-10. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Background : SKSpriteNode
+ (Background *)generateNewBackground :(NSString*)level;
@end
