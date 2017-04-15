//
//  FEPhotoDetailViewController.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 15/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FEPhoto;
@protocol FEDataProvider;
@protocol FEImageProvider;
@interface FEPhotoDetailViewController : UIViewController

/**
 Factory method to return an instance of this view controller utilizing the given data and image provider
 
 @param photo the photo to show in this view controller
 @param dataProvider data provider to talk to API
 @param imageProvider image provider to load image
 @return an instance of FESearchViewController
 */
+(instancetype) viewControllerWithPhoto:(FEPhoto*) photo dataProvider:(id<FEDataProvider>) dataProvider imageProvider:(id<FEImageProvider>) imageProvider;
@end
