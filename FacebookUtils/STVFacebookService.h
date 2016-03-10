//
//  STVFacebookService.h.h
//  AppEvento
//
//  Created by renanvs on 1/7/15.
//  Copyright (c) 2015 renanvs. All rights reserved.
//


#import <UIKit/UIKit.h>

#import <FBSDKTVOSKit/FBSDKTVOSKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#import "DownloadRequestModel.h"
#import "DownloadResponseModel.h"
#import "DownloadService.h"

//#import "InstaTV-swift.h"

#define SHFacebookFailShare    @"SHFacebookFailShare"
#define SHFacebookSuccessShare @"SHFacebookSuccessShare"

@interface STVFacebookService : NSObject<FBSDKDeviceLoginButtonDelegate>{
    NSArray *albuns;
}

+(id)sharedInstance;

+(NSObject*)getUser;

+(void)requestAlbuns;

+(NSArray*)getAlbuns;

-(void)requestProfileInfo;

-(UIView*)generateLoginButton;

-(UIView*)generateLoginButtonWithCenterView:(UIView *)view;

+(void)requestPhotoById:(NSString*)identifier BlockSuccess:(void(^)(DownloadResponseModel *responseModel))successBlock BlockError:(void(^)())errorBlock;

+(void)requestPhotoFromAlbumIdentifier:(NSString*)albumIdentifier;

@end
