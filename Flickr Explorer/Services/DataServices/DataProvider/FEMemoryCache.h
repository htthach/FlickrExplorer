//
//  FEMemoryCache.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 15/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//
#import "FEObjectCache.h"
static NSUInteger const FE_SMALL_CACHE_SIZE     = 10 * 1024 * 1024; //10 MB
static NSUInteger const FE_MEDIUM_CACHE_SIZE    = 20 * 1024 * 1024; //20 MB
static NSUInteger const FE_LARGE_CACHE_SIZE     = 50 * 1024 * 1024; //50 MB

/**
 A simple in memory cache with NSCache and a naive cost function
 */
@interface FEMemoryCache : NSObject <FEObjectCache>

/**
 Init a new cache instance with custom size

 @param cacheSize target cache size
 @return new cache instance with custom size
 */
-(instancetype) initWithSize:(NSUInteger) cacheSize;

@end
