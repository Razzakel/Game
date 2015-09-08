//
//  RegisterScene.m
//  Speed Racer
//
//  Created by User-23 on 2.07.15.
//  Copyright (c) 2015 г. User-10. All rights reserved.
//

#import "RegisterScene.h"
#import "SharedDownloader.h"
#import "LavelManager.h"

@interface RegisterScene ()

@property (nonatomic) UITextField *userName,*passWord,*repeatPassword,*nickName,*email;
@property (nonatomic) SKSpriteNode *bacGround,*dumyButtonRegister;
@property (nonatomic) float ratioX,ratioY;

@end

@implementation RegisterScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.ratioX = (self.frame.size.width/320);
        self.ratioY = (self.frame.size.height/480);
        
        self.bacGround = [SKSpriteNode spriteNodeWithImageNamed:@"register.png"];
        self.bacGround.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.bacGround.xScale = 0.8;
        [self addChild:self.bacGround];
        
        
        self.dumyButtonRegister = [[SKSpriteNode alloc]initWithImageNamed:@"registerButton.png"];
        self.dumyButtonRegister.size = CGSizeMake(120, 38);
        self.dumyButtonRegister.position = CGPointMake(165,150*self.ratioY);
        self.dumyButtonRegister.zPosition = 100;
        self.dumyButtonRegister.alpha = 1;
        self.dumyButtonRegister.name = @"registerButton";
        [self addChild:self.dumyButtonRegister];
        
        SKLabelNode *labelLogin = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelLogin.text = @"Register";
        labelLogin.fontSize = 20;
        labelLogin.fontColor = [SKColor blackColor];
        labelLogin.position = CGPointMake(170, 145*self.ratioY);
        labelLogin.zPosition = 110;
        [self addChild:labelLogin];


        
    }
    return self;
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
    self.userName = [self setTextField:95 initY:40 holder:@"Username" textSize:17];
    self.userName.delegate = self;
    [self.view addSubview:self.userName];
    
    self.passWord = [self setTextField:95 initY:80 holder:@"Password" textSize:17];
    self.passWord.secureTextEntry = YES;
    self.passWord.delegate = self;
    [self.view addSubview:self.passWord];
    
    self.repeatPassword = [self setTextField:95 initY:120 holder:@"Repeat Password" textSize:17];
    self.repeatPassword.secureTextEntry = YES;
    self.repeatPassword.delegate = self;
    [self.view addSubview:self.repeatPassword];
    
    self.nickName = [self setTextField:95 initY:160 holder:@"Nickname" textSize:17];
    self.nickName.delegate = self;
    [self.view addSubview:self.nickName];
    
    self.email = [self setTextField:95 initY:200 holder:@"e-mail" textSize:17];
    self.email.delegate = self;
    [self.view addSubview:self.email];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        NSArray *nodes = [self nodesAtPoint:location];
        for (SKNode *node in nodes)
        {
            if([node.name isEqualToString:@"registerButton"])
            {
                
                if (![self.passWord.text isEqualToString:self.repeatPassword.text])
                {
                    UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:@"ERROR?" message:@"Password not maching !" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    alertview.alertViewStyle = UIAlertViewStyleDefault;
                    [alertview show];
                }
                else if (![self NSStringIsValidEmail:self.email.text])
                {
                    UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:@"ERROR?" message:@"e-mail invalid" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    alertview.alertViewStyle = UIAlertViewStyleDefault;
                    [alertview show];
                    
                }
                else
                {
                    NSString * form = @"registerManager";
                    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                self.userName.text, @"username",
                                                self.passWord.text, @"password",
                                                self.nickName.text, @"nickname",
                                                self.email.text, @"email",
                                                nil];
                    
                    [[SharedDownloader sharedDownloader] conectionWithDictionary:tmp andForm:form];
                    
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNextScene) name:@"userOK200" object:nil];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWarnning) name:@"userNotOK401" object:nil];
                    
                    
                }

                
            }
            
                
            
        }
    }
}
-(void)showNextScene
{
    [self.userName removeFromSuperview];
    [self.passWord removeFromSuperview];
    [self.repeatPassword removeFromSuperview];
    [self.nickName removeFromSuperview];
    [self.email removeFromSuperview];
    
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
