//
//  FEPhotoCollectionViewCell.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 13/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FEPhotoCollectionViewCell.h"

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

@end
