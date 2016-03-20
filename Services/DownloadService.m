//
//  DownloadService.m
//  VET
//
//  Created by renan veloso silva on 9/9/14.
//  Copyright (c) 2014 renanvs. All rights reserved.
//

#import "DownloadService.h"
#import "AFNetworking.h"
#import "Utils.h"
#import "SocialPhotoTV-swift.h"

@implementation DownloadService
@synthesize downloadingUrlList;

#define folderToSave  @"/download_content"

SynthensizeSingleTon(DownloadService)

#pragma mark - Native Methods

-(instancetype)init{
    if (self = [super init]) {
        downloadingUrlList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark - download handler

+(void)downloadWithRequestModel:(DownloadRequestModel*)requestModel BlockSuccess:(void(^)(DownloadResponseModel *responseModel))successBlock BlockError:(void(^)())errorBlock{
    DownloadService *downloadService = [DownloadService sharedInstance];
    
    if (![[InternetService sharedInstance] hasInternet]) {
        NSLog(@"Sem internet");
        
        if (errorBlock) {
            errorBlock();
        }
        return;
    }
    
    if ([NSString isStringEmpty:requestModel.remoteUrl]) {
        
        if (errorBlock) {
            errorBlock();
        }
        return;
    }
    
    if ([downloadService containsInList:requestModel.remoteUrl]) {
        
        return;
    }
    
    [downloadService.downloadingUrlList addObject:requestModel.remoteUrl];
    
    NSString *requestUrl = requestModel.remoteUrl;
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    
    
    NSString *fileName = requestModel.identifierString;
    NSString *fullPath = [DownloadService getPartialPathWithFileName:fileName];
    [DownloadService createDirectoryAtPath:folderToSave];
    NSString *pathStr = [NSString stringWithFormat:@"%@%@",[DownloadService getDocumentDirectory],fullPath];
    
    ////
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
        NSURL *urlPath = urls[0];
        urlPath = [urlPath URLByAppendingPathComponent:fullPath isDirectory:YES];
        
        return urlPath;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (!error) {
            if ([downloadService containsInList:requestModel.remoteUrl]) {
                [downloadService removeUrlFromList:requestModel.remoteUrl];
            }
            
            DownloadResponseModel *responseModel = [[DownloadResponseModel alloc] initWithRequestModel:requestModel];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    responseModel.localUrl = fullPath;
                    
                    [STVTracker trackEvent:@"Download" action:@"Success" label:responseModel.remoteUrl];
                    
                    if ([[NSFileManager defaultManager] fileExistsAtPath:pathStr]) {
                        successBlock(responseModel);
                        NSLog(@"Finish Downloading");
                    }
                });
            });
            
        }else{
            NSLog(@"download failed: %@",[response.URL absoluteString]);
            
            
            [STVTracker trackEvent:@"Download" action:@"Error" label:[response.URL absoluteString]];
            
            [self removeFileFromListAndDisk:requestModel];
            
            if (errorBlock) {
                errorBlock();
            }
        }
        
        
    }];
    [downloadTask resume];
    
    ////
    
    
//    AFHTTPSessionManager *requestOperation = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:requestUrl]];
//    requestOperation.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    //requestOperation.outputStream = [NSOutputStream outputStreamToFileAtPath:pathStr append:NO];
    
    NSLog(@"Start Downloading %@",requestModel.remoteUrl);
//    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//    
//    [requestOperation start];
}

+(void)removeFileFromListAndDisk:(DownloadRequestModel*)requestModel{
    DownloadService *downloadService = [DownloadService sharedInstance];
    
    if ([downloadService containsInList:requestModel.remoteUrl]) {
        [downloadService removeUrlFromList:requestModel.remoteUrl];
    }
    
    NSString *fullPath = [self getFullPathWithUri:requestModel.remoteUrl];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:fullPath error:nil];
    
}

+(void)downloadWithRequestModel:(DownloadRequestModel*)requestModel BlockSuccess:(void(^)(DownloadResponseModel *responseModel))successBlock{
    [self downloadWithRequestModel:requestModel BlockSuccess:successBlock BlockError:nil];
}

#pragma mark - Utilities

//removendo a url da lista de downloads
-(void)removeUrlFromList:(NSString*)url{
    NSUInteger index = 0;
    NSString *urlDesire;
    for (NSString *cUrl in downloadingUrlList) {
        if ([cUrl isEqualToString:url]) {
            index = [downloadingUrlList indexOfObject:cUrl];
            urlDesire = cUrl;
            break;
        }
    }
    
    if (![urlDesire isEmpty]) {
        [downloadingUrlList removeObjectAtIndex:index];
    }
}

//verifica se a url existe na lista de downloads
-(BOOL)containsInList:(NSString*)url{
    for (NSString *cUrl in downloadingUrlList) {
        if ([cUrl isEqualToString:url]) {
            return YES;
        }
    }
    return NO;
}

+(void)saveImageToCache:(UIImage*)image WithName:(NSString*)fileName{
    [self createDirectoryAtPath:@"/cache"];
    NSString *pathStr = [NSString stringWithFormat:@"%@/cache/%@",[DownloadService getDocumentDirectory],fileName];
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:pathStr atomically:YES];
}

//cria o nome do arquivo com base na url e no tipo
+(NSString*)getFileNameWithUrl:(NSString*)url{
    NSDate *date = [NSDate date];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyyMMdd_hh:mm:ss:sss";
    
    NSString *fileName = [NSString stringWithFormat:@"%@",url.lastPathComponent];
    NSString *fileExtension = [fileName pathExtension];
    if ([NSString isStringEmpty:fileExtension] || fileExtension.length > 5) {
        //fileName = [fileName stringByReplacingOccurrencesOfString:fileExtension withString:@""];
        fileExtension = @"";
    }
    
    fileName = [formater stringFromDate:date];
    
    if ([NSString isStringEmpty:fileExtension]){
        return [NSString stringWithFormat:@"%@",fileName];
    }
    
    return [NSString stringWithFormat:@"%@.%@",fileName,fileExtension];
}

//pega parte do caminho pelo nome do arquivo e pelo tipo
+(NSString*)getPartialPathWithFileName:(NSString*)fileName{
    return [NSString stringWithFormat:@"%@/%@",folderToSave, fileName];
}

//verifica se existe o path (que é parte do caminho) no diretorio documents
+(BOOL)existThisFile:(NSString*)path{
    if ([NSString isStringEmpty:path]) {
        return NO;
    }
    NSString *fullPath = [DownloadService auxFullPath:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL value = [fileManager fileExistsAtPath:fullPath];
    return value;
}

+(BOOL)existThisFileBaseURI:(NSString*)uri{
    if ([NSString isStringEmpty:uri]) {
        return NO;
    }
    
    NSString *fullPath = [self getFullPathWithUri:uri];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL value = [fileManager fileExistsAtPath:fullPath];
    NSLog(@"%@",fullPath);
    return value;
}

//Pega o caminho atual do Documents no dispositivo
+(NSString*)getDocumentDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths lastObject];
    //NSLog(@"direc: %@", documentDirectory);
    return documentDirectory;
}

//retorna o caminho completo com base em parte do caminho
+(NSString*)auxFullPath:(NSString*)lastPath{
    NSString *first = [DownloadService getDocumentDirectory];
    return [NSString stringWithFormat:@"%@%@/%@",first,folderToSave ,lastPath];
}

//retorna o caminho completo com base em parte do caminho
+(NSString*)auxFullPathCached:(NSString*)lastPath{
    NSString *first = [DownloadService getDocumentDirectory];
    lastPath = [lastPath stringByReplacingOccurrencesOfString:folderToSave withString:@""];
    lastPath = [lastPath stringByReplacingOccurrencesOfString:@"lkrcached_/" withString:@"lkrcached_"];
    return [NSString stringWithFormat:@"%@/cache/%@",first,lastPath];
}

//cria diretorio no caminho solicitado na pasta Documents do device
+(NSString*)createDirectoryAtPath:(NSString*)path{
     NSString *pathStr = [NSString stringWithFormat:@"%@%@",[DownloadService getDocumentDirectory],path];
    [[NSFileManager defaultManager] createDirectoryAtPath:pathStr withIntermediateDirectories:YES attributes:nil error:nil];
    return pathStr;
}

#pragma mark - others

//Apagar o arquivo baseado na parte do nome do arquivo
+(void)deleteFileAtPath:(NSString*)path{
    NSString *fullPath = [DownloadService auxFullPath:path];
    [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
}

+(NSString*)saveImageObject:(UIImage *)img{
    if (!img){
        return nil;
    }
    
    NSData *data = UIImagePNGRepresentation(img);

    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyy-MM-dd-HH-mm-ss-SSS";
    NSString *timeStr = [formatter stringFromDate:date];
    NSString* imageName = [self getFileNameWithUrl:timeStr];
    imageName = [NSString stringWithFormat:@"%@png",imageName];
    NSString* imagePath = [self getPartialPathWithFileName:imageName];
    
    [DownloadService createDirectoryAtPath:folderToSave];
    NSString *pathStr = [NSString stringWithFormat:@"%@%@",[DownloadService getDocumentDirectory],imagePath];
    [data writeToFile:pathStr atomically:YES];
    
    return imagePath;
}

+(NSString*)getFullPathWithUri:(NSString*)uri{
    NSString *fileName = [DownloadService getFileNameWithUrl:uri];
    NSString *fullPath = [DownloadService getPartialPathWithFileName:fileName];
    NSString *pathStr = [NSString stringWithFormat:@"%@%@",[DownloadService getDocumentDirectory],fullPath];
    return pathStr;
}

@end
