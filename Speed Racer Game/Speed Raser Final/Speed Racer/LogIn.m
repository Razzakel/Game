//
//  LogIn.m
//  Speed Racer
//
//  Created by User-10 on 7/2/15.
//  Copyright (c) 2015 User-10. All rights reserved.
//

#import "LogIn.h"


@import AVFoundation;

@interface LogIn()


@property (nonatomic) UITextField *userName,*passWord;
@property (nonatomic) SKSpriteNode *bacGround,*dumyButtonLogin,*dumyButtonRegister,*logo,*dummyButtonOffline;
@property (nonatomic) SKLabelNode *labelRegister,*labelLogin,*offLine,*dannyBoy;
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;
@property (nonatomic) float ratioX,ratioY;

@end

@implementation LogIn

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"39871__jus__plucked-thecureish2CUT" withExtension:@"mp3"];
        self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:nil];
        self.backgroundMusicPlayer.numberOfLoops = -1;
        [self.backgroundMusicPlayer prepareToPlay];
        [self.backgroundMusicPlayer play];
        self.backgroundMusicPlayer.volume = 0.5;
        
        self.ratioX = (self.frame.size.width/320);
        self.ratioY = (self.frame.size.height/480);
        
        self.bacGround = [SKSpriteNode spriteNodeWithImageNamed:@"road2.jpg"];
        self.bacGround.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.bacGround.xScale =0.8* self.ratioX;
        self.bacGround.yScale = self.ratioY;
        [self addChild:self.bacGround];
        
        self.dannyBoy = [self creatLabelFont:@"Chalkduster" text:@"by Danny boy" fontSize:8*self.ratioX posX:280*self.ratioX  posY:20*self.ratioY];
        self.dannyBoy.fontColor = [SKColor redColor];
        [self addChild:self.dannyBoy];
        
        self.labelLogin = [self creatLabelFont:@"Chalkduster" text:@"Login" fontSize:20.0*self.ratioX posX:90*self.ratioX  posY:70*self.ratioY];
        [self addChild:self.labelLogin];
        
        self.labelRegister = [self creatLabelFont:@"Chalkduster" text:@"Register" fontSize:20.0*self.ratioX posX:80*self.ratioX posY:190*self.ratioY];
        [self addChild:self.labelRegister];
        
        self.offLine = [self creatLabelFont:@"Chalkduster" text:@"Offline" fontSize:20.0*self.ratioX posX:80*self.ratioX posY:130*self.ratioY];
        self.offLine.fontColor = [SKColor redColor];
        [self addChild:self.offLine];
        
        self.logo = [SKSpriteNode spriteNodeWithImageNamed:@"Speed_Racer_logo.png"];
        self.logo.position = CGPointMake(200*self.ratioX, 400*self.ratioY);
        self.logo.zPosition = 101;
        self.logo.alpha = 0;
        [self addChild:self.logo];
        SKAction *skaleX = [SKAction scaleXTo:0.5 duration:2];
        SKAction *skaleY = [SKAction scaleYTo:0.5 duration:2];
        SKAction *fade = [SKAction fadeAlphaTo:1 duration:2];
        SKAction *together= [SKAction group:@[skaleX,skaleY,fade]];
        [self.logo runAction:together];
        
        
        self.dumyButtonLogin =[self creatButtonWithName:@"loginButton" posX:98*self.ratioX posY:80*self.ratioY zPos:100];
        self.dumyButtonLogin.xScale = self.ratioX;
        self.dumyButtonLogin.yScale = self.ratioY;
        [self addChild:self.dumyButtonLogin];
        
        self.dumyButtonRegister =[self creatButtonWithName:@"registerButton" posX:98*self.ratioX posY:195*self.ratioY zPos:100];
        self.dumyButtonRegister.xScale = self.ratioX;
        self.dumyButtonRegister.yScale = self.ratioY;
        [self addChild:self.dumyButtonRegister];
        
        self.dummyButtonOffline =[self creatButtonWithName:@"offLine" posX:98*self.ratioX posY:138*self.ratioY zPos:100];
        self.dummyButtonOffline.xScale = self.ratioX;
        self.dummyButtonOffline.yScale = self.ratioY;
        [self addChild:self.dummyButtonOffline];
        
    }
    return self;
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
-(SKLabelNode*)creatLabelFont:(NSString*)font text:(NSString*)text fontSize:(float)fontSize posX:(NSInteger)posX posY:(NSInteger)posY
{
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:font];
    label.text = text;
    label.fontSize = fontSize;
    label.fontColor = [SKColor blackColor];
    label.position = CGPointMake(posX, posY);
    return label;
}

-(UITextField*) setTextField:(NSInteger)initX initY:(NSInteger)initY holder:(NSString*)holder textSize:(float)size
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(initX, initY, 140, 30)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.textColor = [UIColor blackColor];
    textField.font = [UIFont systemFontOfSize:size];
    textField.placeholder = holder;
    textField.backgroundColor = [UIColor whiteColor];
    textField.autocorrectionType = UITextAutocorrectionTypeYes;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textField;
}
-(void) didMoveToView:(SKView *)view
{
    self.userName = [self setTextField:100*self.ratioX initY:140*self.ratioY holder:@"User name here" textSize:17.0];
    self.userName.delegate = self;
    [self.view addSubview:self.userName];
    
    self.passWord = [self setTextField:100*self.ratioX initY:180*self.ratioY holder:@"Password here" textSize:17.0];
    self.passWord.secureTextEntry = YES;
    self.passWord.delegate = self;
    [self.view addSubview:self.passWord];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        NSArray *nodes = [self nodesAtPoint:location];
        for (SKNode *node in nodes) {
            if([node.name isEqualToString:@"registerButton"])
            {
                
                [[SharedDownloader sharedDownloader] setPlayerCarImage:@"12"];
                [self.userName removeFromSuperview];
                [self.passWord removeFromSuperview];
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                SKScene * registration = [[RegisterScene alloc] initWithSize:self.size ];
                [self.view presentScene:registration transition: reveal];
                
            }
            if([node.name isEqualToString:@"loginButton"])
            {
                if(![self.passWord.text isEqualToString:@""] || ![self.userName.text isEqualToString:@""]){
                [[SharedDownloader sharedDownloader] setPlayerCarImage:@"12"];
                NSString * form = @"loginManager";
                NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                            self.userName.text, @"username",
                                            self.passWord.text, @"password",
                                            nil];
                
                [[SharedDownloader sharedDownloader] conectionWithDictionary:tmp andForm:form];
                
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNextScene) name:@"userOK200" object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWarnning) name:@"userNotOK401" object:nil];
                }
            }
            if([node.name isEqualToString:@"offLine"])
            {
                [[SharedDownloader sharedDownloader] setOflineStatus:YES];
                [[SharedDownloader sharedDownloader] setPlayerCarImage:@"12"];
                
                [self.userName removeFromSuperview];
                [self.passWord removeFromSuperview];
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                SKScene * lavel = [[LavelManager alloc] initWithSize:self.size];
                [self.view presentScene:lavel transition: reveal];
                
            }
        }
        
    }
}
-(void)showNextScene
{
    [self.userName removeFromSuperview];
    [self.passWord removeFromSuperview];
    
    SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
    SKScene * lavel = [[LavelManager alloc] initWithSize:self.size];
    [self.view presentScene:lavel transition: reveal];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void) showWarnning
{
    UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:@"ERROR?" message:@"Invalid user or password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    alertview.alertViewStyle = UIAlertViewStyleDefault;
    [alertview show];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

