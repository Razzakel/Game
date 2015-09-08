//
//  Goods.h
//  Speed Racer
//
//  Created by User-10 on 6/28/15.
//  Copyright (c) 2015 User-10. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Goods : SKSpriteNode

@property NSInteger sizeX;
@property NSInteger sizeY;

+ (Goods *)generateNewGoods;
@end
