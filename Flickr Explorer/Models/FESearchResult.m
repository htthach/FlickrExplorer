//
//  FESearchResult.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 14/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FESearchResult.h"
#import "FEPhotoList.h"

@implementation FESearchResult
/**
 Start index of search result page. For Flickr, start index is 1
 
 @return Start index of search result page
 */
+(NSInteger) startingPageIndex{
    return 1;
}

/**
 Return number of photo in this result
 
 @return Return number of photo in this result
 */
-(NSInteger) numberOfPhotos{
    return [self.photos numberOfPhotos];
}

/**
 Get a photo at an index from the photos in this result
 
 @param index index of the requested photo
 @return a photo at an index from the photos in this result
 */
-(FEPhoto*) getPhotoAtIndex:(NSInteger) index{
    return [self.photos photoAtIndex:index];
}

/**
 Check if has more result after a result page
 
 @param pageIndex the page to check
 @return YES if has more result after this page
 */
-(BOOL) hasMorePageAfter:(NSInteger) pageIndex{
    return [self.photos.pages integerValue] > pageIndex;
}

/**
 Append other search result into this result by merging the photo list
 
 @param otherResult the other search result to append
 */
-(void) appendSearchResult:(FESearchResult*) otherResult{
    [self.photos appendPhotoList: otherResult.photos];
}
@end
