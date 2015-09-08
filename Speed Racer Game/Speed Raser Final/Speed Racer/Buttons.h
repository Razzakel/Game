//
//  Buttons.h
//  Speed Racer
//
//  Created by User-10 on 6/30/15.
//  Copyright (c) 2015 User-10. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Buttons : SKSpriteNode


@property NSInteger sizeX;
@property NSInteger sizeY;

+ (Buttons *)generateNewButton:(NSString*)name;
@end
