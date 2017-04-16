//
//  FETagSelectionView.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 16/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FETagSelectionViewDelegate
-(void) tagSelectionViewDidSelectTag:(NSString*) tag;
-(void) tagSelectionViewDidClearTagSelection;
-(void) tagSelectionViewDidChooseSearchWithTag:(NSString*) tag;
-(void) tagSelectionViewNeedUpdateHeight:(CGFloat) height;
@end


/**
 Simple tag selection view
 */
@interface FETagSelectionView : UIView
@property (weak) id<FETagSelectionViewDelegate> delegate;

/**
 Reset content with new set of tags

 @param tags tag to set
 */
-(void) updateTags:(NSArray*) tags;


/**
 Recommended height for this view to fit content nicely

 @return Recommended height for this view to fit content nicely
 */
-(CGFloat) recommendedHeight;
@end
