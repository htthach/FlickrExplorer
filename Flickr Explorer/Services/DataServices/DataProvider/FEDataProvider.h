//
//  FEDataProvider.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 15/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FESearchResult;

@protocol FEDataProvider <NSObject>
/**
 Search Flickr API for photos matching some free text
 
 @param text    the free text to search for
 @param success success callback block
 @param fail    failure callback block
 */
-(void) searchPhotoWithText:(NSString*) text
                    success:(void (^)(FESearchResult *searchResult)) success
                       fail:(void (^)(NSError *error)) fail;

@end
