//
//  FESearchViewController.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 12/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FEDataProvider;
@protocol FEImageProvider;
@interface FESearchViewController : UIViewController
/**
 Factory method to return an instance of this view controller utilizing the given data and image provider

 @param dataProvider data provider to talk to API
 @param imageProvider image provider to load image
 @return an instance of FESearchViewController
 */
+(instancetype) viewControllerWithDataProvider:(id<FEDataProvider>) dataProvider imageProvider:(id<FEImageProvider>) imageProvider;
@end
