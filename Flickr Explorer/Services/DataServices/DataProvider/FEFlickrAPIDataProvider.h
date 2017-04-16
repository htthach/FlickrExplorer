//
//  FEFlickrAPIDataProvider.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 13/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FEDataProvider.h"
#import "FEImageProvider.h"
@protocol FEDataToObjectParser;
@protocol FEObjectCache;

/**
 Simplified data and image provider to talk to Flickr API. For simplicity we implement both protocol in this class. Of course in real world we'll just split them up further.
 */
@interface FEFlickrAPIDataProvider : NSObject <FEDataProvider, FEImageProvider>

/**
 Convenient factory method to return a shared standard Flickr API data provider.
 
 @return an singleton instance of FEFlickrAPIDataProvider
 */
+(instancetype) sharedDefaultProvider;

/**
 Initialize FEFlickrAPIDataProvider with proper configuration
 
 @param parser the FEDataToObjectParser parser to use to parse api response NSData to Object
 @param url the base URL to use for all API request
 @param session the session to use for data task
 @param apiResponseCache the api response cache to use. Pass nil if don't want to enable auto API caching.
 @param imageCache the image cache to use. Pass nil if don't want to enable auto image caching.
 @return an instance of FEFlickrAPIDataProvider
 */
-(instancetype)initWithParser:(id<FEDataToObjectParser>) parser
                      baseURL:(NSURL *)url
                      session:(NSURLSession*) session
             apiResponseCache:(id<FEObjectCache>) apiResponseCache
                   imageCache:(id<FEObjectCache>) imageCache;
@end
