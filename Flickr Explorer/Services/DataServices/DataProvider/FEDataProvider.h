//
//  FEDataProvider.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 15/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FESearchResult;
@class FEPhoto;
@class FEPhotoInfoResult;
@protocol FEDataProvider <NSObject>
/**
 Search Flickr API for photos matching some free text or tags. At least text or tags must present. Text takes precedent
 
 @param text    the free text to search for
 @param tags    the tags to search for. We'll use tags if text is nil or empty
 @param page    the result page to fetch
 @param success success callback block
 @param fail    failure callback block
 */
-(void) searchPhotoWithText:(NSString*) text
                       tags:(NSArray<NSString*>*)tags
                       page:(NSUInteger) page
                    success:(void (^)(FESearchResult *searchResult)) success
                       fail:(void (^)(NSError *error)) fail;

/**
 Search Flickr API for photos nearby a location
 
 @param latitude    the latitude to search for
 @param longitude    the longitude to search for
 @param page    the result page to fetch
 @param success success callback block
 @param fail    failure callback block
 */
-(void) searchPhotoWithLatitude:(double) latitude
                       longitude:(double) longitude
                       page:(NSUInteger) page
                    success:(void (^)(FESearchResult *searchResult)) success
                       fail:(void (^)(NSError *error)) fail;

/**
 Load more info about a particular photo

 @param photo   photo to load info of
 @param success success callback block
 @param fail    fail callback block
 */
-(void) loadInfoForPhoto:(FEPhoto*) photo
                 success:(void (^)(FEPhotoInfoResult *infoResult)) success
                    fail:(void (^)(NSError *error)) fail;
@end
