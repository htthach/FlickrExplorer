//
//  FESearchResult.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 14/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FEBaseModel.h"
@class FEPhotoList;
@class FEPhoto;
@interface FESearchResult : FEBaseModel
@property (nonatomic, strong) FEPhotoList   *photos;
@property (nonatomic, copy)   NSString      *stat;


/**
 Return number of photo in this result

 @return Return number of photo in this result
 */
-(NSInteger) numberOfPhotos;

/**
 Get a photo at an index from the photos in this result

 @param index index of the requested photo
 @return a photo at an index from the photos in this result
 */
-(FEPhoto*) getPhotoAtIndex:(NSInteger) index;
@end
