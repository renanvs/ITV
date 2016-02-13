//
//  DonwloadRequestModel.m
//  VET
//
//  Created by renan veloso silva on 9/9/14.
//  Copyright (c) 2014 renanvs. All rights reserved.
//

#import "DownloadRequestModel.h"

@implementation DownloadRequestModel
@synthesize identifier, remoteUrl, identifierString;

-(id)initWithIdentifier:(NSNumber*)_identifier AndRemoteUrl:(NSString*)_url{
    self = [super init];
    
    if (self) {
        identifier = _identifier;
        remoteUrl = _url;
    }
    
    return self;
}

-(id)initWithIdentifierString:(NSString*)_identidierStr AndRemoteUrl:(NSString*)_url{
    self = [super init];
    
    if (self) {
        identifierString = _identidierStr;
        remoteUrl = _url;
    }
    
    return self;
}

@end
