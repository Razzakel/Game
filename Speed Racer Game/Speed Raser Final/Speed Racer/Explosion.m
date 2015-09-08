//
//  Explosion.m
//  Speed Racer
//
//  Created by User-10 on 6/21/15.
//  Copyright (c) 2015 User-10. All rights reserved.
//

#import "Explosion.h"

@implementation Explosion

- (instancetype)initWithImageNamed:(NSString*)imgName
{
    self = [super init];
    if (self) {
        
    NSString* explAtlasName,*explTexture;
    if ([imgName isEqualToString:@"expl11.png"]) {
        explAtlasName = @"expl";
        explTexture = @"expl%d";
        self.sizeX = 100;
        self.sizeY = 100;
        self.stakZPosition = 101;
    }
    if ([imgName isEqualToString:@"explos11.png"]) {
        explAtlasName = @"expl1";
        explTexture = @"explos%d";
        self.sizeX = 65;
        self.sizeY = 65;
         self.stakZPosition = 2;
    }
        NSMutableArray *explFrames = [NSMutableArray array];
        SKTextureAtlas *explosionAtlas = [SKTextureAtlas atlasNamed:explAtlasName];
        NSInteger numImages = explosionAtlas.textureNames.count;
        for (int i=1; i <= numImages; i++) {
            NSString *textureName = [NSString stringWithFormat:explTexture, i];
            SKTexture *temp = [explosionAtlas textureNamed:textureName];
            [explFrames addObject:temp];
        }
        self.explosionFrames=explFrames;
    }
    return self;
}


+ (Explosion *)generateNewExplosion:(NSString*) name
{
    Explosion *explosion = [[Explosion alloc]initWithImageNamed:name];
    return explosion;
}

@end
