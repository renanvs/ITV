//
//  DownloadService.h
//  VET
//
//  Created by renan veloso silva on 9/9/14.
//  Copyright (c) 2014 renanvs. All rights reserved.
//

/*
 Essa classe é responsavel por fazer o download das imagens do app
 e armazena-las no dispositivo.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "InternetService.h"
#import "DownloadRequestModel.h"
#import "DownloadResponseModel.h"

@class DownloadRequestModel;
@class DownloadResponseModel;
@interface DownloadService : NSObject{
    NSMutableArray *downloadingUrlList;
}

+(id)sharedInstance;

@property (nonatomic) NSMutableArray *downloadingUrlList;

+(void)downloadWithRequestModel:(DownloadRequestModel*)requestModel BlockSuccess:(void(^)(DownloadResponseModel *responseModel))successBlock;
+(void)downloadWithRequestModel:(DownloadRequestModel*)requestModel BlockSuccess:(void(^)(DownloadResponseModel *responseModel))successBlock BlockError:(void(^)())errorBlock;

+(void)deleteFileAtPath:(NSString*)path;

+(BOOL)existThisPathAbsolute:(NSString*)path;
+(BOOL)existThisFileBaseURI:(NSString*)uri;
+(NSString*)auxFullPath:(NSString*)lastPath;
+(NSString*)getFileNameWithUrl:(NSString*)url;
+(NSString*)auxFullPathCached:(NSString*)lastPath;
+(void)saveImageToCache:(UIImage*)image WithName:(NSString*)fileName;
+(NSString*)saveImageObject:(UIImage *)img;


+(NSString*)getPartialPathWithFileName:(NSString*)fileName;
+(NSString*)getFullPathWithUri:(NSString*)uri;

@end
