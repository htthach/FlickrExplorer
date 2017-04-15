//
//  FEContent.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 15/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FEBaseModel.h"

@interface FEContent : FEBaseModel
@property (nonatomic, copy) NSString *content;

//override parent
-(instancetype)initWithString:(NSString *)string;
@end
