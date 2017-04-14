//
//  FEConfigurations.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 14/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FEConfigurations.h"
//secrets
#define FE_SECRET_FILE_NAME @"Secrets"
#define FE_SECRET_FILE_EXTENSION @"plist"

#define FE_SECRET_KEY_FLICKR_API_KEY @"FlickrAPIKey"
#define FE_SECRET_KEY_FLICKR_API_SECRET @"FlickrAPISecret"

//configurations
#define FE_CONFIGURATION_FILE_NAME @"Configurations"
#define FE_CONFIGURATION_FILE_EXTENSION @"plist"

#define FE_CONFIGURATION_KEY_FLICK_BASE_URL @"FlickrBaseUrl"

@implementation FEConfigurations

#pragma mark - file io
+(NSDictionary*) configDictionary{
    static NSDictionary *configDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //read the config file once
        configDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]
                                                                       pathForResource:FE_CONFIGURATION_FILE_NAME
                                                                       ofType:FE_CONFIGURATION_FILE_EXTENSION]];
    });
    return configDictionary;
}

+(NSDictionary*) secretDictionary{
    static NSDictionary *secretDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //read the secret file once
        secretDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]
                                                                       pathForResource:FE_SECRET_FILE_NAME
                                                                       ofType:FE_SECRET_FILE_EXTENSION]];
    });
    return secretDictionary;
}

#pragma mark - secrets
+(NSString*) flickrAPIKey{
    NSString* result = [[FEConfigurations secretDictionary] objectForKey:FE_SECRET_KEY_FLICKR_API_KEY];
    NSAssert(result, @"Missing Flickr API Key configuration");
    return result;
}
+(NSString*) flickrAPISecret{
    NSString* result = [[FEConfigurations secretDictionary] objectForKey:FE_SECRET_KEY_FLICKR_API_SECRET];
    NSAssert(result, @"Missing Flickr API Secret configuration");
    return result;
}

#pragma mark - configurations
+(NSString *) baseURLStringForFlickrAPI {
    NSString* result = [[FEConfigurations configDictionary] objectForKey:FE_CONFIGURATION_KEY_FLICK_BASE_URL];
    NSAssert(result, @"Missing Flickr API Base URL configuration");
    return result;
}
@end
