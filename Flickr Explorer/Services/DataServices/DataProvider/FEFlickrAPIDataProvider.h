//
//  FEFlickrAPIDataProvider.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 13/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FEDataProvider;
@protocol FEImageProvider;
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
 @param configuration the session configuration to use
 @param operationQueue the operation queue to run session tasks
 @param apiResponseCache the api response cache to use. Pass nil if don't want to enable auto API caching.
 @param imageCache the image cache to use. Pass nil if don't want to enable auto image caching.
 @return an instance of FEFlickrAPIDataProvider
 */
-(instancetype)initWithParser:(id<FEDataToObjectParser>) parser
                      baseURL:(NSURL *)url
         sessionConfiguration:(NSURLSessionConfiguration *)configuration
               operationQueue:(NSOperationQueue *) operationQueue
             apiResponseCache:(id<FEObjectCache>) apiResponseCache
                   imageCache:(id<FEObjectCache>) imageCache;
@end
