//
//  SharedDownloader.m
//  Speed Racer
//
//  Created by User-06 on 6/28/15.
//  Copyright (c) 2015 User-10. All rights reserved.
//

#import "SharedDownloader.h"
#import "AppDelegate.h"


@interface SharedDownloader ()

@property (nonatomic) NSMutableDictionary *responseDictionary;
@property (nonatomic) NSString *userId,*highscore,*maxlevel,*money,*nickname;
@property BOOL isOffLine;

@end

@implementation SharedDownloader

+sharedDownloader
{
    static SharedDownloader* instance = nil;
    static dispatch_once_t token;
    if (!instance)
    {
        dispatch_once (&token, ^{
       
        instance = [[super alloc] init];
            
        instance.playerCarImage = @"";
        instance.userId = @"";
        instance.maxlevel = @"";
        instance.money = @"";
        instance.nickname = @"";
        instance.highscore = @"";
        instance.isOffLine = NO;
        });
    }
    return instance;
    
}

+(instancetype)alloc
{
    return [SharedDownloader sharedDownloader];
}

-(id)copy
{
    return [SharedDownloader sharedDownloader];
}

-(id)mutableCopy
{
    return [SharedDownloader sharedDownloader];
}


-(void)conectionWithDictionary:(NSMutableDictionary *) tmp andForm:(NSString *) form
{
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    NSString *serverURLString = [NSString stringWithFormat:@"http://192.168.7.57:8080/SpeedRacer/%@",form];
    NSURL *serverURL = [NSURL URLWithString:serverURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serverURL];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:tmp options:NSJSONWritingPrettyPrinted error:nil];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    __weak SharedDownloader* weakSelf = self;
    
    NSURLSessionUploadTask* upload = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
 
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        weakSelf.userId =[result [@"id"] stringValue];
        weakSelf.money = [result [@"money"] stringValue];
        weakSelf.maxlevel = [result [@"maxlevel"] stringValue];
        weakSelf.nickname = result [@"nickname"];
        weakSelf.highscore = [result [@"highscore"] stringValue];
        
        NSLog(@"%@",  result );
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.statusRespond = [(NSHTTPURLResponse*) response statusCode];
            NSLog(@"%d",self.statusRespond);                                      
            
            if (weakSelf.statusRespond == 200) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"userOK200" object:nil];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"userNotOK401" object:nil];
            }
        });
        
        
    }];
    
    [upload resume];
}

-(void) sendingGetReqestForPath:(NSString*)path withParameters:(NSString* )parameters withCompletionHandler:(void (^) (NSDictionary* jsonObject))block {
    NSString* serverURl = @"http://192.168.7.57:8080/SpeedRacer/";
    NSString* fullServerURL = [[serverURl stringByAppendingString:path] stringByAppendingString:parameters];
    
    NSURL* url = [NSURL URLWithString:fullServerURL];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask* downloadData = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^ (NSData *data,NSURLResponse *response,NSError *error){
        NSDictionary* jsonDict  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            block (jsonDict);
        });
        
    }];
    [downloadData resume];
    
    
}
-( void ) sendingGetReqestWithCompletionHandler:( void (^) ( NSArray * jsonObject))block {
    NSString * serverURl = @"http://192.168.7.57:8080/SpeedRacer/highscoreManager" ;
    
    NSURL * url = [ NSURL URLWithString :serverURl];
    NSURLRequest * request = [ NSURLRequest requestWithURL :url];
    
    NSURLSessionDataTask * downloadData = [[ NSURLSession sharedSession ] dataTaskWithRequest :request completionHandler :^ ( NSData *data, NSURLResponse *response, NSError *error){
        NSArray * jsonAr  = [ NSJSONSerialization JSONObjectWithData :data options : NSJSONReadingMutableLeaves error : nil ];
        NSLog ( @"%@" , jsonAr);
        dispatch_async ( dispatch_get_main_queue (), ^{
            block (jsonAr);
        });
    }];
    [downloadData resume ];
}


-(NSString*) nickName
{
    return self.nickname;
}
-(NSString*) getId
{
    return self.userId;
}
-(void) setMoney:(NSString *)money
{
    _money = money;
}
-(NSString*) getMoney
{
    return self.money;
}
-(NSString*) getHighScore
{
    return self.highscore;
}
-(void) setHighscore:(NSString *)highscore
{
    _highscore = highscore;
}
-(void) setMaxlevel:(NSString *)maxlevel
{
    _maxlevel = maxlevel;
}
-(NSString*) getMaxLevel
{
    return self.maxlevel;
}
-(void) setOflineStatus:(BOOL) status
{
    self.isOffLine = status;
}
-(BOOL) getOflineStatus
{
    return self.isOffLine;
}

@end
