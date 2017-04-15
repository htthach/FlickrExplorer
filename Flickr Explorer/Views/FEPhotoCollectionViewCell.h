//
//  FEPhotoCollectionViewCell.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 13/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FEPhoto;
@protocol FEImageProvider;

@interface FEPhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

/**
 *  Convenient method to return the nib of this cell class in main bundle
 *
 *  @return the nib of FEPhotoCollectionViewCell
 */
+ (UINib *)nib;


/**
 Show a photo in this cell using the given info

 @param photo           the photo to show
 @param imageProvider   the image provider to download photo image
 */
-(void) showPhoto:(FEPhoto*) photo usingImageProvider:(id<FEImageProvider>) imageProvider;
@end
