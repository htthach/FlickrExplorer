//
//  FEPhoto.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 14/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FEBaseModel.h"
#import "FEContent.h"
typedef NS_ENUM(NSInteger, FEPhotoSize) {
    FEPhotoSizeThumb,
    FEPhotoSizeSmall,
    FEPhotoSizeMedium,
    FEPhotoSizeLarge,
    FEPhotoSizeOriginal,
};

@interface FEPhoto : FEBaseModel
@property (nonatomic, copy) NSString  *photoId;
@property (nonatomic, copy) NSString  *owner;
@property (nonatomic, copy) NSString  *secret;
@property (nonatomic, copy) NSString  *server;
@property (nonatomic, copy) NSString  *farm;
@property (nonatomic, strong) FEContent  *title;
@property (nonatomic, copy) NSNumber  *isPublic;
@property (nonatomic, copy) NSNumber  *isFriend;
@property (nonatomic, copy) NSNumber  *isFamily;
@property (nonatomic, copy) NSString  *tags;
@property (nonatomic, strong) FEContent *photoDescription;


/**
 Check if two photos are the same. Currently we only consider photo id

 @param otherPhoto the photo to compare this to
 @return YES if both have same ID.
 */
-(BOOL) isSamePhotoAs:(FEPhoto*) otherPhoto;


/**
 Check if this photo match some of the tags. Empty tags match with all photos

 @param tags tags to check
 @return YES if this photo contains any of those tags
 */
-(BOOL) containsTags:(NSArray<NSString*>*) tags;

/**
 Separate tags properties into an array of tags

 @return an array of tags
 */
-(NSArray<NSString*>*) tagArray;
@end
