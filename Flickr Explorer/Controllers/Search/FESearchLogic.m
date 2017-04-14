//
//  FESearchLogic.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 13/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FESearchLogic.h"
#import "FEFlickrAPIDataProvider.h"
@implementation FESearchLogic


/**
 Start searching for photo given the input text from user
 
 @param text the input text to search photo
 */
-(void) searchPhotoPhotoWithText:(NSString*) text{
    [[FEFlickrAPIDataProvider defaultProvider] searchPhotoWithText:text success:^(FESearchResult *searchResult) {
        //
    } fail:^(NSError *error) {
        //
    }];
}


@end
