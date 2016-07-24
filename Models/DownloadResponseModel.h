//
//  DownloadResponseModel.h
//  VET
//
//  Created by renan veloso silva on 9/9/14.
//  Copyright (c) 2014 renanvs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadRequestModel.h"
@class DownloadService;
@class DownloadRequestModel;

@interface DownloadResponseModel : NSObject{
    NSNumber *identifier;
    NSString *identifierString;
    NSString *remoteUrl;
    NSString *localUrl;
}

-(id)initWithRequestModel:(DownloadRequestModel*)requestModel;

@property (nonatomic) NSString *identifierString;
@property (nonatomic) NSNumber *identifier;
@property (nonatomic) NSString *remoteUrl;
@property (nonatomic) NSString *localUrl;

@end
