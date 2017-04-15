//
//  FEMemoryCache.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 15/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FEMemoryCache.h"
@interface FEMemoryCache ()
@property (atomic, strong) NSCache *cache;
@end

@implementation FEMemoryCache

/**
 Init a new cache instance with custom size
 
 @param cacheSize target cache size
 @return new cache instance with custom size
 */
-(instancetype) initWithSize:(NSUInteger) cacheSize{
    self = [super init];
    if (self) {
        self.cache = [[NSCache alloc] init];
        self.cache.totalCostLimit = cacheSize;
    }
    return self;
}

#pragma mark - implementation of FEObjectCache
/**
 Cache an object with a key
 
 @param object  object to cache
 @param size    estimated size of the object
 @param key     key to cache
 */
-(void) cacheObject:(id) object ofSize:(NSUInteger) size forKey:(NSString*) key{
    if (object && key) {
        [self.cache setObject:object forKey:key cost:size];
    }
}


/**
 Retrieve an object from cache if any
 
 @param key key to retrieve
 @return the cached object if any
 */
-(id) getObjectForKey:(NSString*) key{
    if (key) {
        return [self.cache objectForKey:key];
    }
    return nil;
}
@end
