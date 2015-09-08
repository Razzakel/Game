//
//  Buttons.m
//  Speed Racer
//
//  Created by User-10 on 6/30/15.
//  Copyright (c) 2015 User-10. All rights reserved.
//

#import "Buttons.h"

@implementation Buttons

+ (Buttons *)generateNewButton:(NSString*)name
{
    Buttons *button = [[Buttons alloc]
                 initWithImageNamed:name];
    
    button.sizeX = 250;
    button.sizeY = 250;
    
    return button;
}

@end
