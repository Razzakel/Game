//
//  HighScore.m
//  Speed Racer
//
//  Created by User-10 on 7/3/15.
//  Copyright (c) 2015 User-10. All rights reserved.
//

#import "HighScore.h"
#import "LavelManager.h"
#import "SharedDownloader.h"
#import "GarageScene.h"

@import AVFoundation;

@interface HighScore ()

@property (nonatomic) SKSpriteNode *bacGround,*dumyButtonExit,*dumyButtonGarage,*dumyButtonOptions;
@property (nonatomic) SKLabelNode *labelRegister,*labelLogin,*labelOptions;
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;
@property (nonatomic) NSArray *firstTenPlayers;
@property BOOL isOffLine;
@property (nonatomic) float ratioX,ratioY;

@end

@implementation HighScore

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.isOffLine = [[SharedDownloader sharedDownloader] getOflineStatus];
        self.ratioX = (self.frame.size.width/320);
        self.ratioY = (self.frame.size.height/480);
        
        if (!self.isOffLine){
        [[ SharedDownloader sharedDownloader ] sendingGetReqestWithCompletionHandler :^( NSArray *jsonObject) {
            
            self.firstTenPlayers = jsonObject;
            
                   NSInteger spase = 0;
                   for (int i = 0; i < 10; i++) {
            
            NSString *tempNickNameText = [ NSString stringWithFormat : @"%d %@" ,i+1 ,[[ self . firstTenPlayers objectAtIndex :i] objectForKey : @"nickname" ]];
             NSString *tempScoreText = [ NSString stringWithFormat : @"%@",[[ self . firstTenPlayers objectAtIndex :i] objectForKey : @"highscore" ]];
                       
                        SKLabelNode *tempNickName = [self creatLabelFont:@"Chalkduster" text:tempNickNameText fontSize:14.0 posX:50 posY:(420 - spase)*self.ratioY andColor:[SKColor blackColor]];
                       tempNickName.horizontalAlignmentMode = 1;
                        [self addChild:tempNickName];
                        SKLabelNode *tempNickNameShadow = [self creatLabelFont:@"Chalkduster" text:tempNickNameText fontSize:14.0 posX:52 posY:(418 - spase)*self.ratioY andColor:[SKColor whiteColor]];
                       tempNickNameShadow.horizontalAlignmentMode = 1;
                        [self addChild:tempNickNameShadow];
                       
                        SKLabelNode *tempScore = [self creatLabelFont:@"Chalkduster" text:tempScoreText fontSize:14.0 posX:280 posY:(420 - spase)*self.ratioY andColor:[SKColor blackColor]];
                       tempScore.horizontalAlignmentMode = 2;
                        [self addChild:tempScore];
                       
                        SKLabelNode *tempScoreShadow = [self creatLabelFont:@"Chalkduster" text:tempScoreText fontSize:14.0 posX:282 posY:(418 - spase)*self.ratioY andColor:[SKColor whiteColor]];
                       tempScoreShadow.horizontalAlignmentMode = 2;
                        [self addChild:tempScoreShadow];
                        spase +=20;
                   }
            
            } ];
        }else{
            
            NSString *hightScore = [[SharedDownloader sharedDownloader] getHighScore];
            NSString *level = [[SharedDownloader sharedDownloader] getMaxLevel];
            
            SKLabelNode *tempHigtScoreShadow = [self creatLabelFont:@"Chalkduster" text:[NSString stringWithFormat:@"Level %@",level] fontSize:25 posX:182 posY:352*self.ratioY andColor:[SKColor whiteColor]];
            tempHigtScoreShadow.horizontalAlignmentMode = 0;
            [self addChild:tempHigtScoreShadow];
            
            SKLabelNode *tempHigtScore = [self creatLabelFont:@"Chalkduster" text:[NSString stringWithFormat:@"Level %@",level] fontSize:25 posX:180 posY:350*self.ratioY andColor:[SKColor blackColor]];
            tempHigtScore.horizontalAlignmentMode = 0;
            [self addChild:tempHigtScore];
            
            SKLabelNode *resultShadow = [self creatLabelFont:@"Chalkduster" text:hightScore fontSize:25 posX:182 posY:322*self.ratioY andColor:[SKColor whiteColor]];
            resultShadow.horizontalAlignmentMode = 0;
            [self addChild:resultShadow];
            
            SKLabelNode *result = [self creatLabelFont:@"Chalkduster" text:hightScore fontSize:25 posX:180 posY:320*self.ratioY andColor:[SKColor blackColor]];
            result.horizontalAlignmentMode = 0;
            [self addChild:result];
        }
        
        
        NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"39871__jus__plucked-thecureish2CUT" withExtension:@"mp3"];
        self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:nil];
        self.backgroundMusicPlayer.numberOfLoops = -1;
        [self.backgroundMusicPlayer prepareToPlay];
        [self.backgroundMusicPlayer play];
        self.backgroundMusicPlayer.volume = 0.5;
        
        self.bacGround = [SKSpriteNode spriteNodeWithImageNamed:@"road2.jpg"];
        self.bacGround.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.bacGround.xScale =0.8*self.ratioX;
        self.bacGround.yScale =self.ratioY;
        self.bacGround.alpha = 0.5;
        [self addChild:self.bacGround];
        
        self.labelLogin = [self creatLabelFont:@"Chalkduster" text:@"Top 10 players"fontSize:20.0 posX:150 posY:450*self.ratioY andColor:[SKColor blackColor]];
        [self addChild:self.labelLogin];
        
        
        
        SKLabelNode *exitShadow = [self creatLabelFont:@"Chalkduster" text:@"Exit" fontSize:30.0 posX:93 posY:72*self.ratioY andColor:[SKColor whiteColor]];
        [self addChild:exitShadow];
        SKLabelNode *exit = [self creatLabelFont:@"Chalkduster" text:@"Exit" fontSize:30.0 posX:92 posY:70*self.ratioY andColor:[SKColor blackColor]];
        [self addChild:exit];
        
        self.dumyButtonExit = [self creatButtonWithName:@"Exit" posX:98 posY:81*self.ratioY zPos:100];
        [self addChild:self.dumyButtonExit];
        
        SKLabelNode *garageShadow = [self creatLabelFont:@"Chalkduster" text:@"Garage" fontSize:25.0 posX:93 posY:132*self.ratioY andColor:[SKColor whiteColor]];
        [self addChild:garageShadow];
        SKLabelNode *garage = [self creatLabelFont:@"Chalkduster" text:@"Garage" fontSize:25.0 posX:92 posY:130*self.ratioY andColor:[SKColor blackColor]];
        [self addChild:garage];
        
        self.dumyButtonGarage = [self creatButtonWithName:@"Garage" posX:98 posY:138*self.ratioY zPos:100];
        [self addChild:self.dumyButtonGarage];
        
        SKLabelNode *optionsShadow = [self creatLabelFont:@"Chalkduster" text:@"Options" fontSize:25.0 posX:93 posY:192*self.ratioY andColor:[SKColor whiteColor]];
        [self addChild:optionsShadow];
        SKLabelNode *options = [self creatLabelFont:@"Chalkduster" text:@"Options" fontSize:25.0 posX:92 posY:190*self.ratioY andColor:[SKColor blackColor]];
        [self addChild:options];
        
        self.dumyButtonOptions = [self creatButtonWithName:@"Garage" posX:98 posY:195*self.ratioY zPos:100];
        [self addChild:self.dumyButtonOptions];
    }
    return self;
}

-(SKLabelNode*)creatLabelFont:(NSString*)font text:(NSString*)text fontSize:(float)fontSize posX:(NSInteger)posX posY:(NSInteger)posY andColor:(SKColor*)color
{
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:font];
    label.text = text;
    label.fontSize = fontSize;
    label.fontColor = color;
    label.position = CGPointMake(posX, posY);
    return label;
}
-(SKSpriteNode*) creatButtonWithName:(NSString*)name posX:(NSInteger)posX posY:(NSInteger)posY zPos:(NSInteger)zPos
{
    SKSpriteNode *button = [[SKSpriteNode alloc]initWithColor:[SKColor redColor] size:CGSizeMake(130, 48)];
    button.position = CGPointMake(posX, posY);
    button.zPosition = zPos;
    button.alpha =0;
    button.name = name;
    return button;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        NSArray *nodes = [self nodesAtPoint:location];
        for (SKNode *node in nodes) {
            if([node.name isEqualToString:@"Exit"])
            {
                
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                SKScene * lavel = [[LavelManager alloc] initWithSize:self.size];
                [self.view presentScene:lavel transition: reveal];
                
            }
            if([node.name isEqualToString:@"Garage"])
            {
                
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                SKScene * lavel = [[GarageScene alloc] initWithSize:self.size];
                [self.view presentScene:lavel transition: reveal];
                
            }
        }
        
    }
}

@end
