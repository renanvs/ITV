//
//  DonwloadRequestModel.h
//  VET
//
//  Created by renan veloso silva on 9/9/14.
//  Copyright (c) 2014 renanvs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DownloadService;
@class DownloadResponseModel;
@interface DownloadRequestModel : NSObject{
    NSNumber *identifier;
    NSString *remoteUrl;
    NSString *identifierString;
}

@property (nonatomic) NSString *identifierString;
@property (nonatomic) NSNumber *identifier;
@property (nonatomic) NSString *remoteUrl;

-(id)initWithIdentifier:(NSNumber*)_identidier AndRemoteUrl:(NSString*)_url;
-(id)initWithIdentifierString:(NSString*)_identidierStr AndRemoteUrl:(NSString*)_url;

@end
