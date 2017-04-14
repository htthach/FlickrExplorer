//
//  FEPhotoList.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 14/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FEBaseModel.h"
@interface FEPhotoList : FEBaseModel
@property (nonatomic, strong) NSArray *photo;
@property (nonatomic, copy) NSNumber  *page;
@property (nonatomic, copy) NSNumber  *pages;
@property (nonatomic, copy) NSNumber  *perpage;
@property (nonatomic, copy) NSNumber  *total;


@end
