//
//  FEPhotoList.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 14/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FEBaseModel.h"
@class FEPhoto;
@interface FEPhotoList : FEBaseModel
@property (nonatomic, strong) NSArray<FEPhoto *> *photos;
@property (nonatomic, copy) NSNumber  *page;
@property (nonatomic, copy) NSNumber  *pages;
@property (nonatomic, copy) NSNumber  *perPage;
@property (nonatomic, copy) NSNumber  *total;

/**
 Return number of photo in this result
 
 @return Return number of photo in this result
 */
-(NSInteger) numberOfPhotos;

/**
 Get a photo at an index from this list
 
 @param index index of the requested photo
 @return a photo at an index from this list
 */
-(FEPhoto*) photoAtIndex:(NSInteger) index;

/**
 Append other photo list into this list. And update with the new list page info
 
 @param otherPhotos the other photo list to append
 */
-(void) appendPhotoList:(FEPhotoList*) otherPhotos;


/**
 Get most popular tags in the photo list

 @param count max count of the return list
 @return most popular tags in the photo list
 */
-(NSArray<NSString*>*) mostPopularTag:(NSUInteger) count;

/**
 Create new photo list that contain only photos matching filter tags.
 
 @param tags tags to filter the photo list by
 @return a new photo list that contain only photos matching filter tags.
 */
-(FEPhotoList*) photoListFilteredWithTags:(NSArray<NSString*>*) tags;
@end
