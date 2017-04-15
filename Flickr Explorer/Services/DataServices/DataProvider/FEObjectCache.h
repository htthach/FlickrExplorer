//
//  FEObjectCache.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 15/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FEObjectCache <NSObject>

/**
 Cache an object with a key
 
 @param object  object to cache
 @param size    estimated size of the object
 @param key     key to cache
 */
-(void) cacheObject:(id) object ofSize:(NSUInteger) size forKey:(NSString*) key;


/**
 Retrieve an object from cache if any
 
 @param key key to retrieve
 @return the cached object if any
 */
-(id) getObjectForKey:(NSString*) key;
@end
