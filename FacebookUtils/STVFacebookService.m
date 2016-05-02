//
//  STVFacebookService.h.m
//  AppEvento
//
//  Created by renanvs on 1/7/15.
//  Copyright (c) 2015 renanvs. All rights reserved.
//

#import "STVFacebookService.h"
#import "Utils.h"
#import "SocialPhotoTV-swift.h"

@interface STVFacebookService(){
    STVFacebookUser *faceUser;
}
@end

@implementation STVFacebookService

SynthensizeSingleTon(STVFacebookService)

-(instancetype)init{
    self = [super init];
    if (self) {
        albuns = [NSArray array];
    }
    
    return self;
}

+(NSArray*)getAlbuns{
    return [[self sharedInstance] getAlbuns];
}

-(NSArray*)getAlbuns{
    return albuns;
}

+(NSObject*)getUser{
    return [[STVFacebookService sharedInstance] getUser];
}

-(STVFacebookUser*)getUser{
    if (!faceUser) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"faceUser"];
        [self parseToUser:dic];
    }
    
    return faceUser;
}

+(void)postSimpleNotification:(NSString*)notificationName{
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
}

+(void)postSimpleNotification:(NSString*)notificationName WithObject:(id)obj{
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:obj];
}

-(void)setAlbumList:(NSArray*)l{
    albuns = l;
}

+(void)requestAlbuns{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields": @"albums{cover_photo,count,id,name}",}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        
        
        if (!result) {
            return;
        }
        
        NSArray *albunsList = [[result objectForKey:@"albums"] objectForKey:@"data"];
        NSMutableArray *list = [NSMutableArray array];
        for (NSDictionary *dic in albunsList) {
            if ([dic safeNumberForKey:@"count"].intValue == 0) {
                continue;
            }
            
            NSString *identifier = [dic safeStringForKey:@"id"];
            AlbumEntity *album = [AlbumEntity getByIndentifier:identifier];
            
            if (!album) {
                album = [AlbumEntity newEntity];
            }
            
            album.identifier = identifier;
            album.coverPhotoId = [[dic objectForKey:@"cover_photo"] safeStringForKey:@"id"];
            album.photoCount = [dic safeNumberForKey:@"count"];
            album.identifier = [dic safeStringForKey:@"id"];
            album.name = [dic safeStringForKey:@"name"];
            album.remoteCoverUrl = [NSString stringWithFormat:@"https://graph.facebook.com/v2.5/%@/picture?type=normal&access_token=%@",album.coverPhotoId,[FBSDKAccessToken currentAccessToken].tokenString];;
            [list addObject:album];
        }
        
        [[self sharedInstance] setAlbumList:list];
        
        [STVCoreData saveContext];
        [self postSimpleNotification:@"parsedAlbunsSuccess"];
        NSLog(@"dssada");
    }];
}

+(void)requestPhotoFromAlbumIdentifier:(NSString*)albumIdentifier{
    NSString *url = [NSString stringWithFormat:@"/%@/photos",albumIdentifier];
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:url
                                  parameters:@{ @"fields": @"name",@"limit": @"1000",}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        if (!result) {
            return;
        }
        
        NSArray *photosList = [result objectForKey:@"data"];
        NSMutableArray *list = [NSMutableArray array];
        for (NSDictionary *dic in photosList) {
            
            
            NSString *identifier = [dic safeStringForKey:@"id"];
            PhotoEntity *photo = [PhotoEntity getByIndentifier:identifier];
            
            if (!photo) {
                photo = [PhotoEntity newEntity];
            }
            
            photo.identifier = identifier;
            photo.name = [dic safeStringForKey:@"name"];
            
            BOOL value = [[NSUbiquitousKeyValueStore defaultStore] boolForKey:photo.identifier];
            if (value){
                photo.favorited = @YES;
            }else{
                photo.favorited = @NO;
            }
            
            
            photo.remotePhotoUrl = [NSString stringWithFormat:@"https://graph.facebook.com/v2.5/%@/picture?type=normal&access_token=%@",photo.identifier,[FBSDKAccessToken currentAccessToken].tokenString];
            photo.album = [AlbumEntity getByIndentifier:albumIdentifier];
            [list addObject:photo];
        }
        
        [[self sharedInstance] setAlbumList:list];
        
        [STVCoreData saveContext];
        [self postSimpleNotification:@"parsedAlbumPhotosSuccess" WithObject:list];
        
    }];
}

+(void)requestPhotoById:(NSString*)identifier BlockSuccess:(void(^)(DownloadResponseModel *responseModel))successBlock BlockError:(void(^)())errorBlock{
    
    NSString *url = [NSString stringWithFormat:@"https://graph.facebook.com/v2.5/%@/picture?type=normal&access_token=%@",identifier,[FBSDKAccessToken currentAccessToken].tokenString];
    DownloadRequestModel *requestModel = [[DownloadRequestModel alloc] initWithIdentifierString:identifier AndRemoteUrl:url];
    [DownloadService downloadWithRequestModel:requestModel BlockSuccess:^(DownloadResponseModel *responseModel) {
        if (successBlock) {
            successBlock(responseModel);
        }
    } BlockError:^{
        if (errorBlock) {
            errorBlock();
        }
    }];
    
    
//    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"/498427366853640/picture" parameters:@{@"type":@"normal",}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//        
//        if (!result) {
//            return;
//        }
//        
//        NSString *url = [[result objectForKey:@"data"] objectForKey:@"url"];
//        DownloadRequestModel *requestModel = [[DownloadRequestModel alloc] initWithIdentifierString:identifier AndRemoteUrl:url];
//        [DownloadService downloadWithRequestModel:requestModel BlockSuccess:^(DownloadResponseModel *responseModel) {
//            if (successBlock) {
//                successBlock(responseModel);
//            }
//        } BlockError:^{
//            if (errorBlock) {
//                errorBlock();
//            }
//        }];
//        
//        
//        NSLog(@"dssada");
//    }];
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
    faceUser = [[STVFacebookUser alloc] init];
    
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
    
    [STVTracker trackEvent:@"Facebook" action:@"Info" label:dic.description];
    
}

-(void)deviceLoginButtonDidLogIn:(FBSDKDeviceLoginButton *)button {
    [STVFacebookService postSimpleNotification:@"deviceLoginButtonDidLogIn"];
    [[STVFacebookService sharedInstance] requestProfileInfo];
}

-(void)deviceLoginButtonDidFail:(FBSDKDeviceLoginButton *)button error:(NSError *)error{
    
}

-(void)deviceLoginButtonDidCancel:(FBSDKDeviceLoginButton *)button{
    
}

-(void)deviceLoginButtonDidLogOut:(FBSDKDeviceLoginButton *)button{
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] dismissViewControllerAnimated:false completion:^{
        [[[[UIApplication sharedApplication] delegate] window]setRootViewController:[STVUtils getControllerBaseOnFacebookStatus]];
    }];
    
    
    [STVFacebookService deleteAllFromEntity:@"AlbumEntity"];
    [STVFacebookService deleteAllFromEntity:@"PhotoEntity"];
    
    [STVTracker trackEvent:@"Facebook" action:@"Logout" label:nil];
}

+ (void) deleteAllFromEntity:(NSString *)entityName {
    NSManagedObjectContext *managedObjectContext = [[STVCoreData sharedInstance]managedObjectContext];
    NSFetchRequest * allRecords = [[NSFetchRequest alloc] init];
    [allRecords setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext]];
    [allRecords setIncludesPropertyValues:NO];
    NSError * error = nil;
    NSArray * result = [managedObjectContext executeFetchRequest:allRecords error:&error];
    for (NSManagedObject * profile in result) {
        [managedObjectContext deleteObject:profile];
    }
    NSError *saveError = nil;
    [managedObjectContext save:&saveError];
}

-(UIView*)generateLoginButton{
    FBSDKDeviceLoginButton *button = [[FBSDKDeviceLoginButton alloc] initWithFrame:CGRectZero];
    button.readPermissions = @[@"email",@"user_photos"];
    button.center = [[[[UIApplication sharedApplication] delegate] window] rootViewController].view.center;
    button.delegate = self;
    return button;
}

-(UIView*)generateLoginButtonWithCenterView:(UIView *)view{
    FBSDKDeviceLoginButton *button = [[FBSDKDeviceLoginButton alloc] initWithFrame:CGRectZero];
    button.readPermissions = @[@"email",@"user_photos"];
    [button centerWithSuperView:view];
    button.delegate = self;
    return button;
}

@end
