//
//  FEPhotoCollectionViewCell.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 13/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FEPhotoCollectionViewCell.h"
#import "FEImageProvider.h"
#import "FEHelper.h"

@interface FEPhotoCollectionViewCell ()
@property (nonatomic, strong) FEPhoto *photoToShow;
@end
@implementation FEPhotoCollectionViewCell

/**
 *  Convenient method to return the nib of this cell class in main bundle
 *
 *  @return the nib of FEPhotoCollectionViewCell
 */
+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([FEPhotoCollectionViewCell class]) bundle:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


/**
 Show a photo in this cell using the given info
 
 @param photo           the photo to show
 @param imageProvider   the image provider to download photo image
 */
-(void) showPhoto:(FEPhoto*) photo usingImageProvider:(id<FEImageProvider>) imageProvider{
    self.photoToShow = photo;
    [imageProvider downloadImageForPhoto:photo
                                    size:FEPhotoSizeThumb
                                 success:^(UIImage *image) {
                                     //only update if we're still supposed to show the same downloaded photo
                                     if ([self.photoToShow isSamePhotoAs:photo]){
                                        [self.imageView setImage:image];
                                     }
                                 }
                                    fail:^(NSError *error) {
                                        //only update if we're still supposed to show the same downloaded photo
                                        if ([self.photoToShow isSamePhotoAs:photo]){
                                            [self.imageView setImage:[FEHelper imagePlaceholder]];
                                        }
                                    }];
}
@end
