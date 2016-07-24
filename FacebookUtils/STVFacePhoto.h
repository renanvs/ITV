//
//  STVFacePhoto.h
//  InstaTV
//
//  Created by renan silva on 2/13/16.
//  Copyright © 2016 mwg. All rights reserved.
//

@class STVFaceAlbum;

#import <Foundation/Foundation.h>

@interface STVFacePhoto : NSObject

@property (nonatomic) NSString *photoId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *remoteCoverUrl;
@property (nonatomic) STVFaceAlbum *albumModel;

@end
