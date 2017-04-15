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
@end
