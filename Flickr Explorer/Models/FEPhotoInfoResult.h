//
//  FEPhotoInfoResult.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 15/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FEBaseModel.h"
@class FEPhoto;
@interface FEPhotoInfoResult : FEBaseModel
@property (nonatomic, strong) FEPhoto       *photo;
@property (nonatomic, copy)   NSString      *stat;
@end
