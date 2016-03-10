//
//  STVFaceAlbum.h
//  InstaTV
//
//  Created by renan silva on 2/12/16.
//  Copyright © 2016 mwg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STVFaceAlbum : NSObject

@property (nonatomic) NSString *coverPhotoId;
@property (nonatomic) NSNumber *photoCount;
@property (nonatomic) NSString *albumId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *partialCoverPath;
@property (nonatomic) NSString *remoteCoverUrl;

@end
