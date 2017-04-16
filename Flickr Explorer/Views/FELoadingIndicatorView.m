//
//  FELoadingIndicatorView.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 16/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FELoadingIndicatorView.h"
#import "FEUITheme.h"
@implementation FELoadingIndicatorView

/**
 Initialize and place it in the center of parent view
 
 @param parentView parent view to place this indicator in
 @return an instance of FELoadingIndicatorView
 */
-(id)initInside:(UIView *)parentView{
    CGFloat width = 60;
    CGRect centerFrame = CGRectMake((int)((parentView.frame.size.width - width)/2), (int)((parentView.frame.size.height - width)/2), width, width);
    
    self = [super initWithFrame:centerFrame];
    if (self) {
        self.backgroundColor = [[FEUITheme primaryColorDark] colorWithAlphaComponent:0.5];
        self.layer.cornerRadius = 6;
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin
                                | UIViewAutoresizingFlexibleBottomMargin
                                | UIViewAutoresizingFlexibleRightMargin
                                | UIViewAutoresizingFlexibleLeftMargin;
        [parentView addSubview:self];
        [parentView bringSubviewToFront:self];
    }
    return self;
}

/**
 Initialize and place it inside parent view, covering the whole parent view
 
 @param parentView parent view to place this indicator in
 @return an instance of FELoadingIndicatorView
 */
-(id)initFullyInside:(UIView *)parentView{
    CGRect fullFrame = CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height);
    
    self = [super initWithFrame:fullFrame];
    if (self) {
        self.backgroundColor = [[FEUITheme primaryColorDark] colorWithAlphaComponent:0.5];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth
                                | UIViewAutoresizingFlexibleHeight;
        [parentView addSubview:self];
        [parentView bringSubviewToFront:self];
    }
    return self;
}
@end
