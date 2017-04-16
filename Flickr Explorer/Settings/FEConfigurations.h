//
//  FEConfigurations.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 14/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Basic configuration helper to read from configuration and secret files.
 */
@interface FEConfigurations : NSObject

#pragma mark - secrets

+(NSString*) flickrAPIKey;
+(NSString*) flickrAPISecret;

#pragma mark - configuration

+(NSString *) baseURLStringForFlickrAPI;


/**
 Return YES if want to enable image caching

 @return YES if want to enable image caching
 */
+(BOOL) toCacheImage;


/**
 Return YES if want to enable api response caching
 
 @return YES if want to enable api response caching
 */
+(BOOL) toCacheAPIResponse;
@end
