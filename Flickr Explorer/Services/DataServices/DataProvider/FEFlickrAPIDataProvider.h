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

/**
 Simplified data and image provider to talk to Flickr API. For simplicity we implement both protocol in this class. Of course in real world we'll just split them up further.
 */
@interface FEFlickrAPIDataProvider : NSObject <FEDataProvider, FEImageProvider>

/**
 Convenient factory method to return a shared standard Flickr API data provider.
 
 @return an singleton instance of FEFlickrAPIDataProvider
 */
+(instancetype) sharedDefaultProvider;

@end
