//
//  Goods.m
//  Speed Racer
//
//  Created by User-10 on 6/28/15.
//  Copyright (c) 2015 User-10. All rights reserved.
//

#import "Goods.h"

@implementation Goods

+ (Goods *)generateNewGoods;
{
    
    NSString *goodImg=@"";
    NSInteger sizeX,sizeY;
    NSInteger randomGoodType = 0;
    
    switch (randomGoodType) {
        case 0:
            goodImg = @"dollars1.png";
            sizeX = 30;
            sizeY = 30;
            break;
    }
    Goods *goods = [[Goods alloc]
                    initWithImageNamed:goodImg];
    goods.name = @"goods";
    goods.sizeX = sizeX;
    goods.sizeY = sizeY;
    return goods;
}

@end
