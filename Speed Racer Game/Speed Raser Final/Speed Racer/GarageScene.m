//
//  GarageScene.m
//  Speed Racer
//
//  Created by User-23 on 2.07.15.
//  Copyright (c) 2015 г. User-10. All rights reserved.
//
#import "SharedDownloader.h"
#import "GarageScene.h"
#import "LavelManager.h"

@import AVFoundation;

@interface GarageScene ()<UIVideoEditorControllerDelegate>

@property (nonatomic) SKSpriteNode *bacGround, *carRed, *carTaxi, *carPoliceA, *carPoliceB, *carPink, *carAmbulance, *carTruck, *lockTaxi, *lockPoliceA, *lockPoliceB, *lockAmbulance, *lockTruck, *lockLife1, *lockLife2, *lockLife3, *lifeButton1, *lifeButton2, *lifeButton3, *currentCar, *money, *mechanic, *speechBubble, *moneyIcon,*wayOut;

@property (nonatomic) SKLabelNode *nickName, *nickNameValue, *moneyValue, *mechanicLable, *mechanicLable2, *mechanicLable3;

-(SKLabelNode *) lableNodeAtPosition:(CGPoint) point andText:(NSString *) text andZPosition:(float) zPosition andLableName:(NSString *) lableName;

-(SKSpriteNode *) carWithName:(NSString *) carName andImageName:(NSString *) image andPosition:(CGPoint) point andSize:(CGSize) size andAlpha:(float) alpha andZPosition:(float) zPositon andInteraction:(BOOL) isInteracting;

@end

@implementation GarageScene

-(void)selectWithCarNode:(SKSpriteNode *) carNode
{
    self.carRed.size = CGSizeMake(38, 80);
    self.carRed.alpha = 1;
    self.carTaxi.size = CGSizeMake(38, 80);
    self.carTaxi.alpha = 1;
    self.carPoliceA.size = CGSizeMake(38, 80);
    self.carPoliceA.alpha = 1;
    self.carPoliceB.size = CGSizeMake(38, 80);
    self.carPoliceB.alpha = 1;
    self.carPink.size = CGSizeMake(38, 80);
    self.carPink.alpha = 1;
    self.carAmbulance.size = CGSizeMake(38, 80);
    self.carAmbulance.alpha = 1;
    self.carTruck.size = CGSizeMake(38, 160);
    self.carTruck.alpha = 1;
    if ([carNode.name isEqualToString:@"carTruck"])
    {
        carNode.size = CGSizeMake(48, 170);
        carNode.alpha = 0.5;
        [[SharedDownloader sharedDownloader] setPlayerCarImage:@"5"];
    }
    else
    {
        carNode.size = CGSizeMake(48, 90);
        carNode.alpha = 0.5;
        if ([carNode.name isEqualToString:@"carRed"])
            [[SharedDownloader sharedDownloader] setPlayerCarImage:@"12"];
        if ([carNode.name isEqualToString:@"carTaxi"])
            [[SharedDownloader sharedDownloader] setPlayerCarImage:@"2"];
        if ([carNode.name isEqualToString:@"carPoliceA"])
            [[SharedDownloader sharedDownloader] setPlayerCarImage:@"0"];
        if ([carNode.name isEqualToString:@"carPoliceB"])
            [[SharedDownloader sharedDownloader] setPlayerCarImage:@"1"];
        if ([carNode.name isEqualToString:@"carPink"])
            [[SharedDownloader sharedDownloader] setPlayerCarImage:@"8"];
        if ([carNode.name isEqualToString:@"carAmbulance"])
            [[SharedDownloader sharedDownloader] setPlayerCarImage:@"6"];
    }
    NSLog(@"%@", [[SharedDownloader sharedDownloader] playerCarImage]);
}

-(SKSpriteNode *) carWithName:(NSString *) carName andImageName:(NSString *) image andPosition:(CGPoint) point andSize:(CGSize) size andAlpha:(float) alpha andZPosition:(float) zPositon andInteraction:(BOOL) isInteracting
{
    SKSpriteNode *node = [[SKSpriteNode alloc] initWithImageNamed:image];
    node.size = size;
    node.position = point;
    node.zPosition = zPositon;
    node.alpha = alpha;
    node.name = carName;
    node.userInteractionEnabled = isInteracting;
    [self addChild:node];
    
    return node;
}

-(SKLabelNode *) lableNodeAtPosition:(CGPoint) point andText:(NSString *) text andZPosition:(float) zPosition andLableName:(NSString *) lableName
{
    SKLabelNode* lable = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
    lable.text = text;
    lable.fontSize = 17.0;
    lable.fontColor = [SKColor blackColor];
    lable.position = point;
    lable.zPosition = zPosition;
    lable.name = lableName;
    [self addChild:lable];

    return lable;
}

-(id)initWithSize:(CGSize)size
{
    
    if (self = [super initWithSize:size])
    {
        self.bacGround = [SKSpriteNode spriteNodeWithImageNamed:@"garage.png"];
        self.bacGround.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.bacGround.xScale = 0.8;
        self.bacGround.alpha = 0.5;
        [self addChild:self.bacGround];
        
        // Way Out
        self.wayOut = [SKSpriteNode spriteNodeWithImageNamed:@"wayOut1.png"];
        self.wayOut.size = CGSizeMake(50, 50);
        self.wayOut.position = CGPointMake(self.frame.size.width/1.1,50);
        self.wayOut.name = @"wayOut";
        self.wayOut.zPosition = 120;
        [self addChild: self.wayOut];
        
//  Car Buttons..................................................................................................................................
        
        self.carRed = [self carWithName:@"carRed" andImageName:@"kola5b.png" andPosition:CGPointMake(90, 290) andSize:CGSizeMake(38, 80) andAlpha:1 andZPosition:10 andInteraction:NO];
        self.carTaxi = [self carWithName:@"carTaxi" andImageName:@"taxi.png" andPosition:CGPointMake(140, 290) andSize:CGSizeMake(38, 80)  andAlpha:1 andZPosition:10 andInteraction:YES];
        self.carPoliceA = [self carWithName:@"carPoliceA" andImageName:@"police1.png" andPosition:CGPointMake(190, 290) andSize:CGSizeMake(38, 80)  andAlpha:1 andZPosition:10 andInteraction:YES];
        self.carPoliceB = [self carWithName:@"carPoliceB" andImageName:@"police2.png" andPosition:CGPointMake(140, 200) andSize:CGSizeMake(38, 80)  andAlpha:1 andZPosition:10 andInteraction:YES];
        self.carPink = [self carWithName:@"carPink" andImageName:@"kola7b.png" andPosition:CGPointMake(90, 200) andSize:CGSizeMake(38, 80)  andAlpha:1 andZPosition:10 andInteraction:NO];
        self.carAmbulance = [self carWithName:@"carAmbulance" andImageName:@"lineika.png" andPosition:CGPointMake(190, 200) andSize:CGSizeMake(38, 80)  andAlpha:1 andZPosition:10 andInteraction:YES];
        self.carTruck = [self carWithName:@"carTruck" andImageName:@"truck4.png" andPosition:CGPointMake(240, 240) andSize:CGSizeMake(38, 160)  andAlpha:1 andZPosition:10 andInteraction:NO];

//  Locks........................................................................................................................................
        
        self.lockTaxi = [self carWithName:@"taxiLock" andImageName:@"lock1.png" andPosition:CGPointMake(140, 290) andSize:CGSizeMake(38, 50) andAlpha:0.5 andZPosition:11 andInteraction:NO];
        self.lockTaxi = [self carWithName:@"policeALock" andImageName:@"lock1.png" andPosition:CGPointMake(190, 290) andSize:CGSizeMake(38, 50) andAlpha:0.5 andZPosition:11 andInteraction:NO];
        self.lockTaxi = [self carWithName:@"policeBLock" andImageName:@"lock1.png" andPosition:CGPointMake(140, 200) andSize:CGSizeMake(38, 50) andAlpha:0.5 andZPosition:11 andInteraction:NO];
        self.lockTaxi = [self carWithName:@"ambulanceLock" andImageName:@"lock1.png" andPosition:CGPointMake(190, 200) andSize:CGSizeMake(38, 50) andAlpha:0.5 andZPosition:11 andInteraction:NO];
       // self.lockTaxi = [self carWithName:@"truckLock" andImageName:@"lock1.png" andPosition:CGPointMake(240, 240) andSize:CGSizeMake(38, 50) andAlpha:0.5 andZPosition:11 andInteraction:NO];
        self.lockTaxi = [self carWithName:@"life1Lock" andImageName:@"lock1.png" andPosition:CGPointMake(110, 70) andSize:CGSizeMake(38, 50) andAlpha:0.5 andZPosition:11 andInteraction:NO];
        self.lockTaxi = [self carWithName:@"life2Lock" andImageName:@"lock1.png" andPosition:CGPointMake(160, 70) andSize:CGSizeMake(38, 50) andAlpha:0.5 andZPosition:11 andInteraction:NO];
        self.lockTaxi = [self carWithName:@"life3Lock" andImageName:@"lock1.png" andPosition:CGPointMake(210, 70) andSize:CGSizeMake(38, 50) andAlpha:0.5 andZPosition:11 andInteraction:NO];

  
//  Life Buttons.................................................................................................................................
        
        self.lifeButton1 = [self carWithName:@"lifeButton1" andImageName:@"heart2.png" andPosition:CGPointMake(110, 70) andSize:CGSizeMake(38, 80)  andAlpha:1 andZPosition:10 andInteraction:YES];
        self.lifeButton1 = [self carWithName:@"lifeButton2" andImageName:@"heart3.png" andPosition:CGPointMake(160, 70) andSize:CGSizeMake(38, 80)  andAlpha:1 andZPosition:10 andInteraction:YES];
        self.lifeButton1 = [self carWithName:@"lifeButton3" andImageName:@"heart.png" andPosition:CGPointMake(210, 70) andSize:CGSizeMake(38, 80)  andAlpha:1 andZPosition:10 andInteraction:YES];
        
//  Lables.......................................................................................................................................
        
        self.nickName = [self lableNodeAtPosition:CGPointMake(50, 460) andText:@"Nickname:" andZPosition:10 andLableName:@"nickName"];
//        self.nickNameValue = [self lableNodeAtPosition:CGPointMake(150, 460) andText:[[SharedDownloader sharedDownloader] nickName] andZPosition:10 andLableName:@"nickNameValue"];
        self.moneyValue = [self lableNodeAtPosition:CGPointMake(100, 430) andText:[[SharedDownloader sharedDownloader] getMoney] andZPosition:10 andLableName:@"moneyValue"];
        self.mechanicLable = [self lableNodeAtPosition:CGPointMake(170, 430) andText:@"Hello  !" andZPosition:20 andLableName:@"mechanicLable"];
        self.mechanicLable2 = [self lableNodeAtPosition:CGPointMake(170, 410) andText:@"Buy one of our cars" andZPosition:20 andLableName:@"mechanicLable2"];
        self.mechanicLable3 = [self lableNodeAtPosition:CGPointMake(170, 385) andText:@"only for 10 000 coins" andZPosition:20 andLableName:@"mechanicLable3"];
        
        
        
//  Other Nodes..................................................................................................................................
        
        self.mechanic = [self carWithName:@"mechanic" andImageName:@"mechanic.png" andPosition:CGPointMake(30, 320) andSize:CGSizeMake(85, 160) andAlpha:1 andZPosition:15 andInteraction:NO];
        self.speechBubble = [self carWithName:@"speechBubble" andImageName:@"speechBubble.png" andPosition:CGPointMake(170, 390) andSize:CGSizeMake(240, 130) andAlpha:1 andZPosition:15 andInteraction:NO];
        self.moneyIcon = [self carWithName:@"moneyIcon" andImageName:@"dollar4.png" andPosition:CGPointMake(20, 440) andSize:CGSizeMake(30, 30) andAlpha:1 andZPosition:15 andInteraction:NO];
        
    }
    return self;
}


-(void)node:(SKSpriteNode *) node andNodeName:(NSString *) nodeName
{
    if([node.name isEqualToString:[NSString stringWithFormat:@"%@", nodeName]])
    {
        if([node.name isEqualToString:@"wayOut"])
        {
            SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
            SKScene * lavel = [[LavelManager alloc] initWithSize:self.size];
            [self.view presentScene:lavel transition: reveal];
        }
        
        if (([nodeName isEqualToString:@"taxiLock"]) || ([nodeName isEqualToString:@"policeALock"]) || ([nodeName isEqualToString:@"policeBLock"]) || ([nodeName isEqualToString:@"ambulanceLock"]) || ([nodeName isEqualToString:@"truckLock"]) || ([nodeName isEqualToString:@"taxiLock"]) || ([nodeName isEqualToString:@"life1Lock"]) || ([nodeName isEqualToString:@"life2Lock"]) || ([nodeName isEqualToString:@"life3Lock"]))
        {
            int temp = [[[SharedDownloader sharedDownloader] getMoney] intValue];
            if (temp < 10000)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NO Money !"
                                                                message:@"You don't have enough coins !"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil,nil];
                
                [alert show];
            }
            else
            {
                temp = temp - 10000;
                
                NSString *tempMoney = [NSString stringWithFormat:@"%d",temp];
                [[SharedDownloader sharedDownloader] setMoney:tempMoney];
                
                self.moneyValue.text = [NSString stringWithFormat:@"%d",temp];
                
                NSLog(@"%@", [NSString stringWithFormat:@"%d",temp]);
                
                if ([nodeName isEqualToString:@"taxiLock"])
                    self.carTaxi.userInteractionEnabled = NO;
                if ([nodeName isEqualToString:@"policeALock"])
                    self.carPoliceA.userInteractionEnabled = NO;
                if ([nodeName isEqualToString:@"policeBLock"])
                    self.carPoliceB.userInteractionEnabled = NO;
                if ([nodeName isEqualToString:@"ambulanceLock"])
                    self.carAmbulance.userInteractionEnabled = NO;
                if ([nodeName isEqualToString:@"truckLock"])
                    self.carTruck.userInteractionEnabled = NO;
                if ([nodeName isEqualToString:@"life1Lock"])
                    self.lifeButton1.userInteractionEnabled = NO;
                if ([nodeName isEqualToString:@"life2Lock"])
                    self.lifeButton2.userInteractionEnabled = NO;
                if ([nodeName isEqualToString:@"life3Lock"])
                    self.lifeButton3.userInteractionEnabled = NO;
                
                [node removeFromParent];
            }

        }
       else if (([nodeName isEqualToString:@"carRed"]) || ([nodeName isEqualToString:@"carTaxi"]) || ([nodeName isEqualToString:@"carPoliceA"]) || ([nodeName isEqualToString:@"carPoliceB"]) || ([nodeName isEqualToString:@"carPink"]) || ([nodeName isEqualToString:@"carAmbulance"]) || ([nodeName isEqualToString:@"carTruck"]))
        {
            if ([nodeName isEqualToString:@"carRed"])
                [self selectWithCarNode:self.carRed];
            if ([nodeName isEqualToString:@"carTaxi"])
                [self selectWithCarNode:self.carTaxi];
            if ([nodeName isEqualToString:@"carPoliceA"])
                [self selectWithCarNode:self.carPoliceA];
            if ([nodeName isEqualToString:@"carPoliceB"])
                [self selectWithCarNode:self.carPoliceB];
            if ([nodeName isEqualToString:@"carPink"])
                [self selectWithCarNode:self.carPink];
            if ([nodeName isEqualToString:@"carAmbulance"])
                [self selectWithCarNode:self.carAmbulance];
            if ([nodeName isEqualToString:@"carTruck"])
                [self selectWithCarNode:self.carTruck];
        }
        
      }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKSpriteNode *node = (SKSpriteNode*) [self nodeAtPoint:location];
            
            [self node:node andNodeName:@"taxiLock"];
            [self node:node andNodeName:@"policeALock"];
            [self node:node andNodeName:@"policeBLock"];
            [self node:node andNodeName:@"ambulanceLock"];
            [self node:node andNodeName:@"truckLock"];
            [self node:node andNodeName:@"life1Lock"];
            [self node:node andNodeName:@"life2Lock"];
            [self node:node andNodeName:@"life3Lock"];
    
            [self node:node andNodeName:@"carRed"];
            [self node:node andNodeName:@"carTaxi"];
            [self node:node andNodeName:@"carPoliceA"];
            [self node:node andNodeName:@"carPoliceB"];
            [self node:node andNodeName:@"carPink"];
            [self node:node andNodeName:@"carAmbulance"];
            [self node:node andNodeName:@"carTruck"];
            
            [self node:node andNodeName:@"lifeButton1"];
            [self node:node andNodeName:@"lifeButton2"];
            [self node:node andNodeName:@"lifeButton3"];
            [self node:node andNodeName:@"wayOut"];
    
            [self node:node andNodeName:@""];

}


@end
