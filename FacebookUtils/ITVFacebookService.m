//
//  ITVFacebookService.h.m
//  AppEvento
//
//  Created by renanvs on 1/7/15.
//  Copyright (c) 2015 renanvs. All rights reserved.
//

#import "ITVFacebookService.h"
#import "Utils.h"
#import "InstaTV-swift.h"

@interface ITVFacebookService(){
    ITVFacebookUser *faceUser;
}
@end

@implementation ITVFacebookService

SynthensizeSingleTon(ITVFacebookService)

-(instancetype)init{
    self = [super init];
    if (self) {
        permissionsRead = @[@"public_profile", @"email"];
        permissionsShare = @[@"publish_actions"];
    }
    
    return self;
}

+(NSObject*)getUser{
    return [[ITVFacebookService sharedInstance] getUser];
}

-(ITVFacebookUser*)getUser{
    if (!faceUser) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"faceUser"];
        [self parseToUser:dic];
    }
    
    return faceUser;
}

+(void)postSimpleNotification:(NSString*)notificationName{
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
}

-(void)requestProfileInfo{
    if ([FBSDKAccessToken currentAccessToken]) {
        
        
        [[[FBSDKGraphRequest alloc]
          initWithGraphPath:@"me?fields=id,name,email,bio,first_name,last_name,work" parameters:nil HTTPMethod:@"GET"] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id user, NSError *error) {
            NSString *identifier = [NSString stringWithFormat:@"/%@/?fields=picture.type(large)",user[@"id"]];
            
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:user];
            
            [[[FBSDKGraphRequest alloc] initWithGraphPath:identifier parameters:nil] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                
                [dic setObject:[result objectForKey:@"picture"] forKey:@"picture"];
                
                [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"faceUser"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedGetProfileInfo" object:faceUser];
            }];
            
        }];
    }
}

-(void)parseToUser:(NSDictionary*)dic{
    faceUser = [[ITVFacebookUser alloc] init];
    
    
    
    faceUser.about = [dic safeStringForKey:@"bio"];
    faceUser.email = [dic safeStringForKey:@"email"];
    faceUser.name = [dic safeStringForKey:@"name"];
    faceUser.gender = [dic safeStringForKey:@"gender"];
    faceUser.identifier = [dic safeStringForKey:@"id"];
    faceUser.link = [dic safeStringForKey:@"link"];
    
    NSArray *workList = [dic objectForKey:@"work"];
    if (workList) {
        NSDictionary *currentWork = [workList firstObject];
        
        NSDictionary *employer = [currentWork objectForKey:@"employer"];
        if (employer) {
            NSString *company = [employer safeStringForKey:@"name"];
            faceUser.company = company;
        }
        
        NSDictionary *position = [currentWork objectForKey:@"position"];
        if (position) {
            NSString *jobTitle = [position safeStringForKey:@"name"];
            faceUser.jobTitle = jobTitle;
        }
    }
    
    
    NSDictionary *picDic = [dic objectForKey:@"picture"];
    NSDictionary *dataDic = [picDic objectForKey:@"data"];
    NSString *url = [dataDic safeStringForKey:@"url"];
    faceUser.pictureURI = url;
    
}

+(BOOL)readyToShare{
    if (![FBSDKAccessToken currentAccessToken]) {
        return NO;
    }
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        return YES;
    }
    
    return NO;
}

+(UIImage *)compressImage:(UIImage *)image{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
}

-(void)shareImage:(UIImage*)image WithText:(NSString*)message{
    if (![FBSDKAccessToken currentAccessToken]) {
        [self loginShare];
    }else{
        if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
            
            image = [ITVFacebookService compressImage:image];
            
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
            [dictionary setObject:UIImagePNGRepresentation(image) forKey:@"picture"];
            [dictionary setObject:message forKey:@"message"];
            
            FBSDKGraphRequest *connection = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/photos" parameters:dictionary HTTPMethod:@"POST"];
            [connection startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    [ITVFacebookService postSimpleNotification:@"SuccessShare"];
                }else{
                    [ITVFacebookService postSimpleNotification:@"ErrorShare"];
                }
            }];
        }else{
            [self loginShare];
        }
    }
}

-(void)shareLink:(NSString*)url WithText:(NSString*)text{
    if (![FBSDKAccessToken currentAccessToken]) {
        [self loginShare];
    }else{
        if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
            
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
            [dictionary setObject:url forKey:@"link"];
            [dictionary setObject:text forKey:@"message"];
            
            FBSDKGraphRequest *connection = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/feed" parameters:dictionary HTTPMethod:@"POST"];
            [connection startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    [ITVFacebookService postSimpleNotification:@"SuccessShare"];
                }else{
                    [ITVFacebookService postSimpleNotification:@"ErrorShare"];
                }
            }];
        }else{
            [self loginShare];
        }
    }
}

#pragma mark - FBSDKSharingDelegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"completed share:%@", results);
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"sharing error:%@", error);
    NSString *message = error.userInfo[FBSDKErrorLocalizedDescriptionKey] ?:
    @"There was a problem sharing, please try again later.";
    NSString *title = error.userInfo[FBSDKErrorLocalizedTitleKey] ?: @"Oops!";
    
    //Todo: [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    NSLog(@"share cancelled");
}


-(void)deviceLoginButtonDidLogIn:(FBSDKDeviceLoginButton *)button {
    [[ITVFacebookService sharedInstance] requestProfileInfo];
}

-(void)deviceLoginButtonDidFail:(FBSDKDeviceLoginButton *)button error:(NSError *)error{
    
}

-(void)deviceLoginButtonDidCancel:(FBSDKDeviceLoginButton *)button{
    
}

-(void)deviceLoginButtonDidLogOut:(FBSDKDeviceLoginButton *)button{
    
}

-(UIView*)generateLoginButton{
    FBSDKDeviceLoginButton *button = [[FBSDKDeviceLoginButton alloc] initWithFrame:CGRectZero];
    button.readPermissions = @[@"email"];
    button.center = [[[[UIApplication sharedApplication] delegate] window] rootViewController].view.center;
    button.delegate = self;
    return button;
    
}

@end
