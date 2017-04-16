//
//  FELocationProvider.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 14/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@protocol FELocationProviderDelegate <NSObject>
/**
 Call back for successfully getting current location

 @param currentLocation the current location of the device
 */
-(void) locationProviderDidGetCurrentLocation:(CLLocation*) currentLocation;

/**
 Fail getting the current location.

 @param error the error from location fetching.
 */
-(void) locationProviderDidFailGettingLocation:(NSError*) error;

@end


/**
 A simplified location provider to get current location
 */
@interface FELocationProvider : NSObject
@property (weak) id<FELocationProviderDelegate> delegate;


/**
 Convenient factory method to create a FELocationProvider
 
 @param delegate the call back delegate
 @return an instance of FELocationProvider
 */
+(instancetype) locationProviderWithDelegate:(id<FELocationProviderDelegate>) delegate;

/**
 Start requesting current location
 */
-(void) requestCurrentLocation;
@end

