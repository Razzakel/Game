//
//  SharedDownloader.h
//  Speed Racer
//
//  Created by User-06 on 6/28/15.
//  Copyright (c) 2015 User-10. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedDownloader : NSObject


@property NSInteger statusRespond;
@property (nonatomic) NSString * playerCarImage;


+sharedDownloader;

-(void)conectionWithDictionary:(NSMutableDictionary *) tmp andForm:(NSString *) form ;
-( void ) sendingGetReqestWithCompletionHandler:( void (^) ( NSArray * jsonObject))block;

-(NSString*) nickName;
-(NSString*) getId;



-(void) setOflineStatus:(BOOL) status;

-(BOOL) getOflineStatus;

-(void) setHighscore:(NSString *)highscore;
-(NSString*) getHighScore;

-(void) setMaxlevel:(NSString *)maxlevel;
-(NSString*) getMaxLevel;

-(void) setMoney:(NSString *) money;
-(NSString*) getMoney;

//-(void) setPlayerCarImage:(NSString *) imageName;
//-(NSString *) playerCarImage;

@end
