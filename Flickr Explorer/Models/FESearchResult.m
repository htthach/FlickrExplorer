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
 Check if has more result after a result page
 
 @param pageIndex the page to check
 @return YES if has more result after this page
 */
-(BOOL) hasMorePageAfter:(NSInteger) pageIndex{
    return [self.photos.pages integerValue] > pageIndex;
}

/**
 Create new result that contain only photos matching filter tags.
 
 @param tags tag to filter the result by
 @return a new result that contain only photos matching a filter tags.
 */
-(FESearchResult*) resultFilteredWithTags:(NSArray<NSString*>*) tags{
    FESearchResult *result = [FESearchResult new];
    result.photos = [self.photos photoListFilteredWithTags:tags];
    return result;
}
@end
