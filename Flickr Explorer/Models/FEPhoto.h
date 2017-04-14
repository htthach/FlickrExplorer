//
//  FEPhoto.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 14/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FEBaseModel.h"
@interface FEPhoto : FEBaseModel
@property (nonatomic, copy) NSNumber  *photoId;
@property (nonatomic, copy) NSString  *owner;
@property (nonatomic, copy) NSString  *secret;
@property (nonatomic, copy) NSString  *server;
@property (nonatomic, copy) NSString  *farm;
@property (nonatomic, copy) NSString  *title;
@property (nonatomic, copy) NSNumber  *ispublic;
@property (nonatomic, copy) NSNumber  *isfriend;
@property (nonatomic, copy) NSNumber  *isfamily;
@end
