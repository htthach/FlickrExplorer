//
//  FELocationProvider.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 14/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FELocationProvider.h"

static int const FE_LOCATION_ERROR_CODE             = 100;
static NSString * const FE_LOCATION_ERROR_DOMAIN    = @"com.flickrexplorer.ios.location";

@interface FELocationProvider () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@end
@implementation FELocationProvider


/**
 Convenient factory method to create a FELocationProvider
 
 @param delegate the call back delegate
 @return an instance of FELocationProvider
 */
+(instancetype) locationProviderWithDelegate:(id<FELocationProviderDelegate>) delegate{
    FELocationProvider *provider = [[FELocationProvider alloc] init];
    provider.delegate = delegate;
    return provider;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.delegate = self;
    }
    return self;
}

/**
 Start requesting current location
 */
-(void) requestCurrentLocation{
    if ([FELocationProvider isPermissionRestricted]) {
        [self.delegate locationProviderDidFailGettingLocation:[NSError errorWithDomain:FE_LOCATION_ERROR_DOMAIN
                                                                                 code:FE_LOCATION_ERROR_CODE
                                                                             userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(@"Location service is not allowed.", @"No location service error description")
                                                                                                                  forKey:NSLocalizedDescriptionKey]]];
        return;
    }
    
    if ([FELocationProvider isPermissionNotDetermined]) {
        [self.locationManager requestWhenInUseAuthorization];
        return;
    }
    
    if ([FELocationProvider isPermissionDenied]) {
        [self informDelegateOnPermissionDenied];
        return;
    }
    
    //everything is ok, can request now
    [self.locationManager startUpdatingLocation];
}

-(void) informDelegateOnPermissionDenied{
    [self.delegate locationProviderDidFailGettingLocation:[NSError errorWithDomain:FE_LOCATION_ERROR_DOMAIN
                                                                             code:FE_LOCATION_ERROR_CODE
                                                                         userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(@"Location service is denied. Please allow location service access.", @"Denied location service error description")
                                                                                                              forKey:NSLocalizedDescriptionKey]]];
}
#pragma mark - helper methods

+(BOOL)isPermissionNotDetermined {
    return ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined);
}

+(BOOL)isPermissionDenied {
    return ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied);
}

+(BOOL)isPermissionRestricted {
    return ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted);
}

+(BOOL)isLocationServicesEnabled {
    return [CLLocationManager locationServicesEnabled];
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {

    //get most recent update
    CLLocation *location = locations.lastObject;
    
    [self.delegate locationProviderDidGetCurrentLocation:location];
    
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {

    if (error.code == kCLErrorLocationUnknown) {
        //we ignore the error and wait for retry
        return;
    }
    
    [self.delegate locationProviderDidFailGettingLocation:error];
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusNotDetermined) {
        //user not yet make choice
    }
    else if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        //user did grant permission
    }
    else {
        //for all thing else, we consider user did deny
        [self informDelegateOnPermissionDenied];
    }
}
@end
