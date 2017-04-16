//
//  FELoadingIndicatorView.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 16/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 Very simple loading indicator
 */
@interface FELoadingIndicatorView : UIActivityIndicatorView

/**
 Initialize and place it in the center of parent view

 @param parentView parent view to place this indicator in
 @return an instance of FELoadingIndicatorView
 */
-(id) initInside:(UIView*) parentView;

/**
 Initialize and place it inside parent view, covering the whole parent view
 
 @param parentView parent view to place this indicator in
 @return an instance of FELoadingIndicatorView
 */
-(id)initFullyInside:(UIView *)parentView;
@end
