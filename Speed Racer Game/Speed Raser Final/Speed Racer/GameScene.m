//
//  GameScene.m
//  Speed Racer
//
//  Created by User-10 on 6/21/15.
//  Copyright (c) 2015 User-10. All rights reserved.
//

#import "GameScene.h"
#import "Background.h"
#import "Explosion.h"
#import "Goods.h"
#import "Buttons.h"
#import "LavelManager.h"
#import "HighScore.h"
#import "SharedDownloader.h"
#import "UniceHole.h"
#import "HoleGenerator.h"
#import "Car.h"
#import "CarGenerator.h"

@import AVFoundation;

static const uint32_t playerCategory   =  0x1 << 0;
static const uint32_t wallCategory     =  0x1 << 1;
static const uint32_t dumyCategory     =  0x1 << 2;
static const uint32_t carCategory      =  0x1 << 3;
static const uint32_t holeCategory     =  0x1 << 4;
static const uint32_t goodsCategory     =  0x1 << 6;
static const uint32_t holyGrail     =  0x1 << 30;

@interface GameScene() <SKPhysicsContactDelegate>

@property (strong, nonatomic) Background *currentBackground;
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;
@property (strong,nonatomic) Car *player;
@property (strong,nonatomic) SKSpriteNode *dumy,*dumy1;
@property (strong, nonatomic) SKLabelNode *scoreLabel,*scoreLabel1,*livesLabel;
@property (strong,nonatomic) SKSpriteNode *carBound,*play,*pause,*wayOut;

@property (nonatomic) NSTimeInterval lastCarAddedTime,lastHoleAddedTime,lastGoodsAddedTime;
@property (nonatomic) NSTimeInterval lastUpdateTimeIntervalCar,lastUpdateTimeIntervalHole,lastUpdateTimeIntervalGoods;

@property  float score,scoreScore;
@property float ratio,carUpdateTime,holeUpdateTime,goodsUpdateTime,playerYMovement;
@property NSInteger lives,backgrSpeed,carCounter,carInScene,carDirection,intPlayerPosition;
@property BOOL isOffLine;

@end

@implementation GameScene
-(id)initWithSize:(CGSize)size andLavel:(NSInteger)level
{
     if (self = [super initWithSize:size])
     {
         // Background Sound
         NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"100870__xythe__loopGOOD1" withExtension:@"mp3"];
         self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:nil];
         self.backgroundMusicPlayer.numberOfLoops = -1;
         [self.backgroundMusicPlayer prepareToPlay];
         [self.backgroundMusicPlayer play];
         self.backgroundMusicPlayer.volume = 0.5;
         
         // Phisics of the World
         self.physicsWorld.gravity = CGVectorMake(0,0);
         self.physicsWorld.contactDelegate = self;
         
         // Initial level
         self.level = level;
         
         // Initial Lives
         if ([self isEndlesLives]) {
             self.lives = 1;
         }else{
             self.lives = 5;
         }
         
         // Initial Udate time
         self.carUpdateTime = 1.5;
         self.holeUpdateTime = 2;
         self.goodsUpdateTime = 5;
         self.backgrSpeed = 7;
         self.isOffLine = [[SharedDownloader sharedDownloader] getOflineStatus];
         
         // Initial car direction
         self.carDirection = 1;
         
         //Initial playerYMovement (dinamik change of y position during lavel play)
         self.playerYMovement = 3;
         
         // Background
         self.currentBackground = [Background generateNewBackground:[NSString stringWithFormat:@"%d",self.level]];
         float ratio = (self.frame.size.width/self.currentBackground.frame.size.width);
         self.ratio = ratio;
         self.currentBackground.zPosition = 0;
         self.currentBackground.xScale = ratio;
         self.currentBackground.position = CGPointMake(self.frame.size.width/2-self.currentBackground.size.width/2, 0);
         [self addChild:self.currentBackground];
         
         // Frame maching the road, not allowing cars and player to move on pavement
         CGSize sizeBoundFrame = CGSizeMake(300*ratio, self.frame.size.height+700);
         self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake((self.frame.size.width-300*ratio)/2,-250, sizeBoundFrame.width, sizeBoundFrame.height)];
         self.physicsBody.categoryBitMask = wallCategory;
         self.physicsBody.contactTestBitMask = carCategory;
         
         // Player
         NSString *playerCarImg = [[SharedDownloader sharedDownloader] playerCarImage];
         CarGenerator *carGeneratot = [[CarGenerator alloc]init];
         Car *playerCar = [carGeneratot carAtIndex:[playerCarImg integerValue]];
         self.player  = playerCar;
         self.player.size = CGSizeMake(45*ratio, self.player.sizeY*ratio);
         self.player.name =@"player";
         
         // Initial Player position;
         if (self.level == 1)
         {
            self.intPlayerPosition =5;
         }
          if (self.level == 2 || self.level == 3)
         {
             self.intPlayerPosition =120;
         }

         self.player.position = CGPointMake(self.frame.size.width/2, self.player.size.height/2+self.intPlayerPosition);
         [self addChild:self.player];
         self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
         self.player.physicsBody.dynamic = YES;
         self.player.physicsBody.allowsRotation = NO;
         self.player.zPosition = 100;
         self.player.physicsBody.affectedByGravity = NO;
         self.player.physicsBody.categoryBitMask = playerCategory;
         self.player.physicsBody.contactTestBitMask = carCategory | wallCategory | goodsCategory;
         self.player.physicsBody.collisionBitMask = wallCategory;
         
         // Hole
         [self addHoles];
         
         // Cars
         [self addCars];
         
//         self.carBound = [[SKSpriteNode alloc]initWithColor:[SKColor redColor] size:CGSizeMake(car.sizeX*ratio, car.sizeY*ratio)];
//         self.carBound .position  = CGPointMake(0,0);
//         self.carBound.zPosition =200;
//         self.carBound.alpha = 0.5;
//         [car addChild:self.carBound];
         
         // Dummy
         self.dumy = [[SKSpriteNode alloc]initWithColor:[SKColor redColor] size:CGSizeMake(120*ratio, 70*ratio)];
         self.dumy.position = CGPointMake(0, 0);
         self.dumy.alpha = 0;
         [self.player addChild: self.dumy];
         self.dumy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.dumy.size];
         self.dumy.physicsBody.categoryBitMask = dumyCategory;
         self.dumy.physicsBody.contactTestBitMask = carCategory | wallCategory;
         self.dumy.physicsBody.collisionBitMask = holyGrail;
         self.dumy.physicsBody.mass =0.000001;
         self.dumy.physicsBody.dynamic = YES;
         
         SKPhysicsJointFixed *joint = [SKPhysicsJointFixed jointWithBodyA:self.player.physicsBody bodyB:self.dumy.physicsBody anchor:CGPointMake(0, 0)];
         
         [self.physicsWorld addJoint:joint];
         
//         self.dumy1 = [[SKSpriteNode alloc]initWithColor:[SKColor blueColor] size:CGSizeMake(50*ratio, 70*ratio)];
//         self.dumy1.position = CGPointMake(0, 0);
//         [self.player addChild:self.dumy1];

#pragma mark Lbl
         
         self.scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
         __weak GameScene* weakSelf = self;
         
         if (self.ratio < 0.8) {
             self.scoreLabel.fontSize = 14;
         }else{
             self.scoreLabel.fontSize = 18;
         }
         self.scoreLabel.color = [SKColor whiteColor];
         self.scoreLabel.colorBlendFactor = 1;
         self.scoreLabel.position = CGPointMake(self.frame.size.width/5, self.frame.size.height - 20);
         self.scoreLabel.zPosition = 110;
         [self addChild:self.scoreLabel];
         
         SKAction *tempAction = [SKAction runBlock:^{
             weakSelf.scoreLabel.text = [NSString
                                     stringWithFormat:@"Score: %.2f", weakSelf.scoreScore];
         }];
         SKAction *waitAction = [SKAction waitForDuration:0.2];
         [self.scoreLabel runAction:[SKAction
                                     repeatActionForever:[SKAction sequence:@[tempAction, waitAction]]]];
         
         if([self isEndlesLives]){
             
             // Way Out
             self.wayOut = [SKSpriteNode spriteNodeWithImageNamed:@"wayOut1.png"];
             self.wayOut.size = CGSizeMake(50, 50);
             self.wayOut.position = CGPointMake(self.frame.size.width/1.1, self.frame.size.height - 50);
             self.wayOut.name = @"wayOut";
             self.wayOut.zPosition = 120;
             [self addChild: self.wayOut];
             
         }
             
         // Label
         self.livesLabel = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
         if (self.ratio < 0.8) {
             self.livesLabel.fontSize = 14;
         }else{
             self.livesLabel.fontSize = 18;
         }
         self.livesLabel.color = [SKColor whiteColor];
         self.livesLabel.colorBlendFactor = 1;
         self.livesLabel.position = CGPointMake(self.frame.size.width/1.2, self.frame.size.height - 20);
         self.livesLabel.zPosition = 110;
         [self addChild:self.livesLabel];
         SKAction *tempActionLives = [SKAction runBlock:^{
             weakSelf.livesLabel.text = [NSString
                                     stringWithFormat:@"Lives: %d", weakSelf.lives];
         }];
         SKAction *waitActionLives = [SKAction waitForDuration:0.2];
         [self.livesLabel runAction:[SKAction
                                     repeatActionForever:[SKAction sequence:@[tempActionLives, waitActionLives]]]];
         
         
     }
    return self;
}
-(BOOL)isEndlesLives
{
    if (self.level == 3) {
        return NO;
    }else{
        return YES;
    }
}
-(void) addCars
{
    CarGenerator *carGeneratot = [[CarGenerator alloc]init];
    Car *car = [carGeneratot generateCar];
    NSArray *temp = @[@100,@175,@245,@320];
    car.startPosition = [temp[arc4random_uniform(4)] integerValue];
    car.speedY = arc4random_uniform(4)+2;
    car.name = @"car";
    car.position = CGPointMake(car.startPosition*self.ratio ,self.frame.size.height+car.size.height/2);
    car.size = CGSizeMake(car.sizeX*self.ratio , car.sizeY*self.ratio );
    [self addChild:car];
    car.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:car.size];
    car.physicsBody.categoryBitMask = carCategory;
    car.physicsBody.contactTestBitMask = playerCategory | dumyCategory | holeCategory | carCategory;
    car.physicsBody.collisionBitMask = carCategory | wallCategory;
    car.physicsBody.dynamic = YES;
    car.physicsBody.restitution = 1;
    car.physicsBody.allowsRotation = NO;
    car.zPosition= 20;
    //[car addChild:self.carBound];
}
-(void) addHoles
{
    HoleGenerator *holeGenerator = [[HoleGenerator alloc]init];
    UniceHole  *hole = [holeGenerator generateHole];
    //Hole *hole = [Hole generateNewHole];
    NSInteger holeRandomeXPos = arc4random_uniform(200*self.ratio)+80;
    hole.position = CGPointMake(holeRandomeXPos, self.frame.size.height);
    hole.size = CGSizeMake(hole.sizeX*self.ratio, hole.sizeY*self.ratio);
    hole.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(hole.sizeX*self.ratio, hole.sizeY*self.ratio)];
    hole.physicsBody.categoryBitMask = holeCategory;
    hole.physicsBody.contactTestBitMask = playerCategory | carCategory ;
    hole.physicsBody.collisionBitMask = holeCategory ;
    hole.physicsBody.dynamic = YES;
    hole.name = @"hole";
    hole.zPosition = 1;
    [self addChild:hole];
}
-(void) addGoods
{
    Goods *good = [Goods generateNewGoods];
    NSInteger goodRandomeXPos = arc4random_uniform(300*self.ratio)+60;
    good.position = CGPointMake(goodRandomeXPos, self.frame.size.height+good.size.height+ 200);
    good.size = CGSizeMake(good.sizeX*self.ratio, good.sizeY*self.ratio);
    good.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(good.sizeX*self.ratio, good.sizeY*self.ratio)];
    good.physicsBody.categoryBitMask = goodsCategory;
    good.physicsBody.contactTestBitMask = playerCategory ;
    good.physicsBody.collisionBitMask = goodsCategory | holeCategory ;
    good.physicsBody.dynamic = YES;
    good.zPosition = 2;
    [self.currentBackground addChild:good];
    
}

#pragma  mark Updates

- (void)updateGoods:(CFTimeInterval)timeSinceLast {
    
    self.lastGoodsAddedTime += timeSinceLast;
    if (self.lastGoodsAddedTime > self.goodsUpdateTime) {
        self.lastGoodsAddedTime = 0;
        [self addGoods];
    }
}
- (void)updateHoles:(CFTimeInterval)timeSinceLast {
    
    self.lastHoleAddedTime += timeSinceLast;
    if (self.lastHoleAddedTime > self.holeUpdateTime) {
        self.lastHoleAddedTime = 0;
        [self addHoles];
        self.player.position = CGPointMake(self.player.position.x, self.player.position.y+self.playerYMovement);
    }
}
- (void)updateCars:(CFTimeInterval)timeSinceLast {
    
    self.lastCarAddedTime += timeSinceLast;
    if (self.lastCarAddedTime > self.carUpdateTime) {
        self.lastCarAddedTime = 0;
        [self addCars];
        self.carCounter++;
    }
}

#pragma mark Explosion

-(void) explosion:(Explosion*) explosion
{
    explosion.zPosition = explosion.stakZPosition;
    explosion.size = CGSizeMake(explosion.sizeX,explosion.sizeY);
    [self addChild:explosion];
    SKAction * removeAction = [SKAction removeFromParent];
    SKAction *anime = [SKAction animateWithTextures:explosion.explosionFrames
                                       timePerFrame:0.1f
                                             resize:NO
                                            restore:YES];
    [explosion runAction:[SKAction sequence:@[anime, removeAction]]];
}
-(void) addLabelWhitText:(float) text andContactPoint:(CGPoint) contactPoint andColor:(SKColor*) color
{
    SKLabelNode *temp = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
    temp.fontSize = 8;
    temp.color = color;
    temp.colorBlendFactor = 1;
    temp.position = contactPoint;
    temp.zPosition = 111;
    temp.text = [NSString
                             stringWithFormat:@"+%.2f", text];
    [self addChild:temp];
    SKAction *scale = [SKAction scaleBy:2.5 duration:2];
    SKAction *removeLbl = [SKAction removeFromParent];
    [temp runAction:[SKAction sequence:@[scale,removeLbl]]];
}

#pragma mark notification

-(void)showNextScene
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
    SKScene * lavel = [[HighScore alloc] initWithSize:self.size];
    [self.view presentScene:lavel transition: reveal];
    
}

-(void) showWarnning
{
    
    UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:@"ERROR?" message:@"Score not saved successfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    alertview.alertViewStyle = UIAlertViewStyleDefault;
    [alertview show];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:1];
    SKScene * gameOverScene = [[HighScore alloc] initWithSize:self.size];
    [self.view presentScene:gameOverScene transition: reveal];
    
}
#pragma mark contacts

- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    if ((firstBody.categoryBitMask & dumyCategory) != 0 &&
        (secondBody.categoryBitMask & carCategory) != 0) {
        
        if (self.player.position.x > secondBody.node.position.x) {
             self.score = 100/((self.player.position.x - secondBody.node.position.x)-(45*self.ratio));
            if(self.score >0){
            self.scoreScore +=self.score;
            }
        }else{
            self.score = 100/((secondBody.node.position.x - self.player.position.x)-(45*self.ratio));
            if(self.score >0){
            self.scoreScore +=self.score;
            }
        }
        CGPoint contactPoint = contact.contactPoint;
        if(self.score >0){
            [self addLabelWhitText:self.score andContactPoint:contactPoint andColor:[SKColor whiteColor]];
        }
    }
    if ((firstBody.categoryBitMask & playerCategory) != 0 &&
        (secondBody.categoryBitMask & carCategory) != 0) {
        
        Explosion *tempExpl = [Explosion generateNewExplosion:@"expl11.png"];
        tempExpl.position = firstBody.node.position;
        [self explosion:tempExpl];
        
        [secondBody.node removeFromParent];
        
        if ([self isEndlesLives]) {
            self.lives++;
        }
        else{
            self.lives--;
        if (self.lives <= 0)
            {
                
                if (self.isOffLine) {
                    
                    [[SharedDownloader sharedDownloader] setHighscore:[NSString stringWithFormat:@"%0.0f",self.scoreScore*100]];
                    [[SharedDownloader sharedDownloader] setMaxlevel:[NSString stringWithFormat:@"%d",self.level]];
                    
                    [self.backgroundMusicPlayer stop];
                    SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:1];
                    SKScene * gameOverScene = [[HighScore alloc] initWithSize:self.size];
                    [self.view presentScene:gameOverScene transition: reveal];
                    
                }else{
                    
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWarnning) name:@"userNotOK401" object:nil];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNextScene) name:@"userOK200" object:nil];
                    
                    NSString * form = @"levelManager";
                    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                [NSNumber numberWithInteger:[[[SharedDownloader sharedDownloader] getId] integerValue]], @"id",
                                                [NSNumber numberWithInteger:self.level],@"level",[NSNumber numberWithFloat:self.scoreScore],@"score",nil];
                    
                    [[SharedDownloader sharedDownloader] conectionWithDictionary:tmp andForm:form];
                
                    [self.backgroundMusicPlayer stop];

                }
            }
        }
    }
    if ((firstBody.categoryBitMask & playerCategory) != 0 &&
        (secondBody.categoryBitMask & wallCategory) != 0) {
        
        self.player.physicsBody.velocity = CGVectorMake(0,0);
    }
    if ((firstBody.categoryBitMask & carCategory) != 0 &&
        (secondBody.categoryBitMask & carCategory) != 0) {
        
        if(self.level == 1){
        CGVector impulse = CGVectorMake(0.5,-5);
        [secondBody.node.physicsBody applyImpulse:impulse];
        CGVector impulse1 = CGVectorMake(-0.5,+5);
        [firstBody.node.physicsBody applyImpulse:impulse1];
        }
        if(self.level == 2){
            CGVector impulse = CGVectorMake(0.5,-3);
            [secondBody.node.physicsBody applyImpulse:impulse];
            CGVector impulse1 = CGVectorMake(-0.5,+3);
            [firstBody.node.physicsBody applyImpulse:impulse1];
        }
        
    }
    if ((firstBody.categoryBitMask & playerCategory) != 0 &&
        (secondBody.categoryBitMask & goodsCategory) != 0) {
        
        self.scoreScore+=100;
        [secondBody.node removeFromParent];
        CGPoint contactPoint = contact.contactPoint;
        [self addLabelWhitText:100.00 andContactPoint:contactPoint andColor:[SKColor blueColor]];
    }
    
    if ((firstBody.categoryBitMask & playerCategory) != 0 &&
        (secondBody.categoryBitMask & holeCategory) != 0) {
        
        Explosion *tempExpl = [Explosion generateNewExplosion:@"explos11.png"];
        tempExpl.position = firstBody.node.position;
        [self explosion:tempExpl];
        
        SKAction *leftRotation = [SKAction rotateByAngle:-M_PI/10 duration:0.2];
        SKAction *rightRotation = [SKAction rotateByAngle:M_PI/5 duration:0.4];
        [firstBody.node runAction:[SKAction sequence:@[leftRotation,rightRotation,leftRotation]]];
    }
    if ((firstBody.categoryBitMask & carCategory) != 0 &&
        (secondBody.categoryBitMask & holeCategory) != 0) {
        
        Explosion *tempExpl = [Explosion generateNewExplosion:@"explos11.png"];
        tempExpl.position = firstBody.node.position;
        [self explosion:tempExpl];
        
        NSInteger tempImpuls = arc4random_uniform(2);
        if (tempImpuls == 0) {
            tempImpuls = -1;
        }
        CGVector impulse1 = CGVectorMake(tempImpuls,0);
        [firstBody.node.physicsBody applyImpulse:impulse1];
        
        if(self.level == 2 || self.level == 3 ){
        SKAction *leftRotation = [SKAction rotateByAngle:(-M_PI*tempImpuls)/12 duration:0.2];
        SKAction *rightRotation = [SKAction rotateByAngle:(M_PI*tempImpuls)/6 duration:0.4];
        [firstBody.node runAction:[SKAction sequence:@[leftRotation,rightRotation,leftRotation]]];
        }
    }
}

#pragma mark touches

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if (location.x > self.frame.size.width/2)
        {
                CGVector impulse = CGVectorMake(20,0);
                [self.player.physicsBody applyImpulse:impulse];
        }
        if(location.x < self.frame.size.width/2)
        {
            CGVector impulse = CGVectorMake(-20,0);
            [self.player.physicsBody applyImpulse:impulse];
        }
         NSArray *nodes = [self nodesAtPoint:location];
        for (SKNode *node in nodes) {
            if([node.name isEqualToString:@"wayOut"])
            {
                if (self.isOffLine) {
                    
                    [[SharedDownloader sharedDownloader] setHighscore:[NSString stringWithFormat:@"%0.0f",(self.scoreScore*100)/self.lives]];
                    [[SharedDownloader sharedDownloader] setMaxlevel:[NSString stringWithFormat:@"%d",self.level]];
                    
                    self.player.physicsBody.velocity = CGVectorMake(0,0);
                    [self.backgroundMusicPlayer stop];
                    
                    SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:1];
                    SKScene * gameOverScene = [[HighScore alloc] initWithSize:self.size];
                    [self.view presentScene:gameOverScene transition: reveal];
                    
                }else{
                    
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWarnning) name:@"userNotOK401" object:nil];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNextScene) name:@"userOK200" object:nil];
                    
                    NSString * form = @"levelManager";                 
                    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                [NSNumber numberWithInteger:[[[SharedDownloader sharedDownloader] getId] integerValue]], @"id",
                                                [NSNumber numberWithInteger:self.level],@"level",[NSNumber numberWithFloat:self.scoreScore],@"score",nil];

                    [[SharedDownloader sharedDownloader] conectionWithDictionary:tmp andForm:form];
                    
                self.player.physicsBody.velocity = CGVectorMake(0,0);
                [self.backgroundMusicPlayer stop];
                    
                }
                
            }
            if([node.name isEqualToString:@"player"])
            {
            self.backgrSpeed = 4;
                self.player.physicsBody.velocity = CGVectorMake(0,0);
            }
            if([node.name isEqualToString:@"player"] && touch.tapCount >= 2)
            {
               self.scene.view.paused = !self.scene.view.paused ;
                            if (self.scene.view.paused) {
                                [self.backgroundMusicPlayer pause];
                                self.wayOut.userInteractionEnabled = YES;
                            }else{
                                [self.backgroundMusicPlayer play];
                                self.wayOut.userInteractionEnabled = NO;
                            }
            }
        }
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if (location.x > self.frame.size.width/2)
        {
            self.player.physicsBody.velocity = CGVectorMake(0,0);
        }
        if(location.x < self.frame.size.width/2)
        {
            self.player.physicsBody.velocity = CGVectorMake(0,0);
        }
        self.backgrSpeed = 7;
    }
}
-(void)update:(CFTimeInterval)currentTime {
    
    [self enumerateChildNodesWithName:@"background"
                           usingBlock:^(SKNode *node, BOOL *stop) {
                               node.position = CGPointMake(node.position.x, node.position.y -  self.backgrSpeed);
                               if (node.position.y < - (node.frame.size.height)) {
                                   [node removeFromParent];
                               }
                           }];
    [self enumerateChildNodesWithName:@"hole"
                           usingBlock:^(SKNode *node, BOOL *stop) {
                               UniceHole *car = (UniceHole*)node;
                               car.position = CGPointMake(car.position.x, car.position.y - self.backgrSpeed);
                               if (node.position.y < - (node.frame.size.height)) {
                                   [node removeFromParent];
                               }
                           }];
    
    CFTimeInterval timeSinceLastCar = currentTime - self.lastUpdateTimeIntervalCar;
    self.lastUpdateTimeIntervalCar = currentTime;
    if (timeSinceLastCar > 1) {
        timeSinceLastCar = 1.0 / 30.0;
        self.lastUpdateTimeIntervalCar = currentTime;
    }
    
    if (self.level == 2) {
        if (self.carCounter < 6) {
            [self updateCars:timeSinceLastCar];
        }
    }
    if (self.level == 1) {
        [self updateCars:timeSinceLastCar];
    }
    if (self.level == 3) {
        [self updateCars:timeSinceLastCar];
    }

    
    CFTimeInterval timeSinceLastHole = currentTime - self.lastUpdateTimeIntervalHole;
    self.lastUpdateTimeIntervalHole = currentTime;
    if (timeSinceLastHole > 1) {
        timeSinceLastHole = 1.0 / 30.0;
        self.lastUpdateTimeIntervalHole = currentTime;
    }
    [self updateHoles:timeSinceLastHole];
    
    CFTimeInterval timeSinceLastGoods = currentTime - self.lastUpdateTimeIntervalGoods;
    self.lastUpdateTimeIntervalGoods = currentTime;
    if (timeSinceLastHole > 1) {
        timeSinceLastHole = 1.0 / 30.0;
        self.lastUpdateTimeIntervalHole = currentTime;
    }
    [self updateGoods:timeSinceLastGoods];
    
    if (self.level == 1 || self.level == 3 ) {
        [self enumerateChildNodesWithName:@"car"
                               usingBlock:^(SKNode *node, BOOL *stop) {
                                   Car *car = (Car*)node;
                                   car.position = CGPointMake(car.position.x, car.position.y - (car.speedY*car.carDirection));
                                   if (node.position.y < - (node.frame.size.height)) {
                                       [node removeFromParent];
                                   }
                               }];
    }
    
    if(self.level == 2){
    self.carInScene = 0;
    [self enumerateChildNodesWithName:@"car"
                           usingBlock:^(SKNode *node, BOOL *stop) {
                               Car *car = (Car*)node;
                               car.position = CGPointMake(car.position.x, car.position.y - (car.speedY*car.carDirection));
                               self.carInScene++;
                               if (node.position.y < - (node.frame.size.height)) {
                                   car.carDirection = -1;
                                   car.speedY = 1;
                               }
                               if (node.position.y > (self.frame.size.height+node.frame.size.height)) {
                                   car.carDirection = 1;
                                   car.speedY = arc4random_uniform(4)+2;
                               }
                           }];
         self.carCounter = self.carInScene;
    }
   
    if (self.currentBackground.position.y < 0) {
        Background *temp = [Background generateNewBackground:[NSString stringWithFormat:@"%d",self.level]];
        temp.xScale = (self.frame.size.width/temp.frame.size.width);
        temp.position = CGPointMake(self.frame.size.width/2-temp.size.width/2,self.currentBackground.position.y
                                    + self.currentBackground.frame.size.height);
        [self addChild:temp];
        self.currentBackground = temp;
    }

}

@end
