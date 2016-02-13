//
//  DownloadResponseModel.m
//  VET
//
//  Created by renan veloso silva on 9/9/14.
//  Copyright (c) 2014 renanvs. All rights reserved.
//

#import "DownloadResponseModel.h"

@implementation DownloadResponseModel
@synthesize identifier, remoteUrl, localUrl, identifierString;

-(id)initWithRequestModel:(DownloadRequestModel*)requestModel{
    self = [super init];
    
    if (self) {
        identifier = requestModel.identifier;
        identifierString = requestModel.identifierString;
        remoteUrl = requestModel.remoteUrl;
    }
    
    return self;
}

@end
