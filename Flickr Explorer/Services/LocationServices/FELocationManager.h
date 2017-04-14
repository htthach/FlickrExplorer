//
//  FELocationManager.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 14/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@protocol FELocationManagerDelegate <NSObject>


/**
 Call back for successfully getting current location

 @param currentLocation the current location of the device
 */
-(void) locationManagerDidGetCurrentLocation:(CLLocation*) currentLocation;


/**
 Fail getting the current location.

 @param error the error from location fetching.
 */
-(void) locationManagerDidFailGettingLocation:(NSError*) error;

@end

@interface FELocationManager : NSObject


/**
 Start requesting current location
 */
-(void) requestCurrentLocation;
@end

