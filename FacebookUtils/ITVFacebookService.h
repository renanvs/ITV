//
//  ITVFacebookService.h.h
//  AppEvento
//
//  Created by renanvs on 1/7/15.
//  Copyright (c) 2015 renanvs. All rights reserved.
//


#import <UIKit/UIKit.h>

#import <FBSDKTVOSKit/FBSDKTVOSKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

//#import "InstaTV-swift.h"

#define SHFacebookFailShare    @"SHFacebookFailShare"
#define SHFacebookSuccessShare @"SHFacebookSuccessShare"

@interface ITVFacebookService : NSObject<FBSDKSharingDelegate, FBSDKDeviceLoginButtonDelegate>{
    NSArray *permissionsRead;
    NSArray *permissionsShare;
    BOOL hasObservers;
}

+(id)sharedInstance;

@property (nonatomic) NSDictionary *userLoggedDic;

-(void)loginRead;

+(NSObject*)getUser;

-(void)loginShare;

+(BOOL)readyToShare;

-(void)shareImage:(UIImage*)image WithText:(NSString*)message;

-(void)logout;

-(void)shareLink:(NSString*)url WithText:(NSString*)text;

-(void)requestProfileInfo;

-(UIView*)generateLoginButton;

@end
