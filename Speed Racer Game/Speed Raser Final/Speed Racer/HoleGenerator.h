//
//  HoleGenerator.h
//  Speed Racer
//
//  Created by User-10 on 7/4/15.
//  Copyright (c) 2015 User-10. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UniceHole.h"


@interface HoleGenerator : NSObject

@property (nonatomic) NSArray *holeArray;

-(UniceHole*) generateHole;

@end

