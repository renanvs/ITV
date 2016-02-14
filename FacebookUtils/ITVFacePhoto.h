//
//  ITVFacePhoto.h
//  InstaTV
//
//  Created by renan silva on 2/13/16.
//  Copyright © 2016 mwg. All rights reserved.
//

@class ITVFaceAlbum;

#import <Foundation/Foundation.h>

@interface ITVFacePhoto : NSObject

@property (nonatomic) NSString *photoId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *remoteCoverUrl;
@property (nonatomic) ITVFaceAlbum *albumModel;

@end
