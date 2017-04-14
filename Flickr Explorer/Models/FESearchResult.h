//
//  FESearchResult.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 14/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FEBaseModel.h"
@class FEPhotoList;

@interface FESearchResult : FEBaseModel
@property (nonatomic, strong) FEPhotoList   *photos;
@property (nonatomic, copy)   NSString      *stat;
@end
