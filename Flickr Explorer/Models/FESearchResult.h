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
 Start index of search result page. For Flickr, start index is 1

 @return Start index of search result page
 */
+(NSInteger) startingPageIndex;

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


/**
 Check if has more result after a result page. We need this because externally we don't care what's the starting index

 @param pageIndex the page to check
 @return YES if has more result after this page
 */
-(BOOL) hasMorePageAfter:(NSInteger) pageIndex;


/**
 Append other search result into this result by merging the photo list

 @param otherResult the other search result to append
 */
-(void) appendSearchResult:(FESearchResult*) otherResult;
@end
