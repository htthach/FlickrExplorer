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

//secrets
+(NSString*) flickrAPIKey;
+(NSString*) flickrAPISecret;

//config
+(NSString *) baseURLStringForFlickrAPI;
@end
