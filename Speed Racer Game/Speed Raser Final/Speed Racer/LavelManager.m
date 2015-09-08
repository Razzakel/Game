//
//  LavelManager.m
//  Speed Racer
//
//  Created by User-10 on 7/2/15.
//  Copyright (c) 2015 User-10. All rights reserved.
//

#import "LavelManager.h"
#import "SharedDownloader.h"

@interface LavelManager()

@property (nonatomic) SKSpriteNode *level1,*level2,*level3,*bacGround;
@property (nonatomic) SKLabelNode *label1,*label2,*label3,*garage,*options;
@property (nonatomic) SKSpriteNode *arrows,*arrLeft,*arrRight,*exit,*dummyExit;
@property (nonatomic) float ratioX,ratioY;

@end

@implementation LavelManager

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        
        self.ratioX = (self.frame.size.width/320);
        self.ratioY = (self.frame.size.height/480);
        
        self.bacGround = [SKSpriteNode spriteNodeWithImageNamed:@"Roadmap1.png"];
        self.bacGround.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.bacGround.xScale = 1.1*self.ratioX;
        self.bacGround.yScale = 1.8*self.ratioY;
        [self addChild:self.bacGround];
        
        self.level1 = [self creatButtonWithName:@"Level1" posX:50*self.ratioX  posY:100 zPos:100 imgName:@"cone1.png"];
        [self addChild:self.level1];
        
        self.level2 = [self creatButtonWithName:@"Level2" posX:150*self.ratioX posY:100 zPos:100 imgName:@"cone2.png"];
        [self addChild:self.level2];
        
        self.level3 = [self creatButtonWithName:@"Level3" posX:250*self.ratioX posY:100 zPos:100 imgName:@"cone3.png"];
        [self addChild:self.level3];
        
        self.label1 = [self creatLabelFont:@"Chalkduster" text:@"1" fontSize:35 posX:50*self.ratioX posY:80];
        [self addChild:self.label1];
        
        self.label2 = [self creatLabelFont:@"Chalkduster" text:@"2" fontSize:35 posX:150*self.ratioX posY:80];
        [self addChild:self.label2];
        
        self.label3 = [self creatLabelFont:@"Chalkduster" text:@"3" fontSize:35 posX:250*self.ratioX posY:80];
        [self addChild:self.label3];
        
        self.garage = [self creatLabelFont:@"Chalkduster" text:@"Garage" fontSize:14 posX:85*self.ratioX posY:278];
        [self addChild:self.garage];
        
        self.options = [self creatLabelFont:@"Chalkduster" text:@"Options" fontSize:14 posX:83*self.ratioX posY:310];
        [self addChild:self.options];
        
        self.options = [self creatLabelFont:@"Chalkduster" text:@"Exit" fontSize:20 posX:50*self.ratioX posY:430];
        [self addChild:self.options];
        
        self.arrows = [SKSpriteNode spriteNodeWithImageNamed:@"sign2.png"];
        self.arrows.position = CGPointMake(85*self.ratioX, 275);
        self.arrows.size = CGSizeMake(90*self.ratioX, 120);
        [self addChild:self.arrows];
        
        self.arrRight = [self creatButtonWithName:@"rightArrow" posX:90 posY:318 zPos:200 imgName:@"arrow1.png"];
        self.arrRight.size = CGSizeMake(80*self.ratioX, 25);
        self.arrRight.alpha = 0;
        [self addChild:self.arrRight];
        
        self.arrLeft = [self creatButtonWithName:@"leftArrow" posX:80 posY:285 zPos:200 imgName:@"arrow2.png"];
        self.arrLeft.size = CGSizeMake(80*self.ratioX, 25);
        self.arrLeft.alpha = 0;
        [self addChild:self.arrLeft];
    }
    return self;
}
-(SKSpriteNode*) creatButtonWithName:(NSString*)name posX:(NSInteger)posX posY:(NSInteger)posY zPos:(NSInteger)zPos imgName:(NSString*)imgName
{
    SKSpriteNode *button = [[SKSpriteNode alloc]initWithImageNamed:imgName];
    button.position = CGPointMake(posX, posY);
    button.zPosition = zPos;
    button.xScale = 0.5;
    button.yScale = 0.5;
    button.alpha =1;
    button.name = name;
    return button;
}
-(SKLabelNode*)creatLabelFont:(NSString*)font text:(NSString*)text fontSize:(float)fontSize posX:(NSInteger)posX posY:(NSInteger)posY
{
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:font];
    label.text = text;
    label.fontSize = fontSize;
    label.fontColor = [SKColor blackColor];
    label.position = CGPointMake(posX, posY);
    label.zPosition = 101;
    return label;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        NSArray *nodes = [self nodesAtPoint:location];
        for (SKNode *node in nodes) {
            if([node.name isEqualToString:@"Level1"])
            {
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                SKScene * gameLevel1 = [[GameScene alloc] initWithSize:self.size andLavel:1];
                [self.view presentScene:gameLevel1 transition: reveal];
            }
            if([node.name isEqualToString:@"Level2"])
            {
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                SKScene * gameLevel2 = [[GameScene alloc] initWithSize:self.size andLavel:2];
                [self.view presentScene:gameLevel2 transition: reveal];
            }
            if([node.name isEqualToString:@"Level3"])
            {
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                SKScene * gameLevel2 = [[GameScene alloc] initWithSize:self.size andLavel:3];
                [self.view presentScene:gameLevel2 transition: reveal];
            }
            if([node.name isEqualToString:@"rightArrow"])
            {
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                SKScene * gameLevel1 = [[GarageScene alloc] initWithSize:self.size];
                [self.view presentScene:gameLevel1 transition: reveal];
            }
            if([node.name isEqualToString:@"leftArrow"])
            {
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                SKScene * gameLevel2 = [[GarageScene alloc] initWithSize:self.size];
                [self.view presentScene:gameLevel2 transition: reveal];
            }
        }
        
    }
}



@end
