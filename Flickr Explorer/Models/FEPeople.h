//
//  FEPeople.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 16/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FEBaseModel.h"

@interface FEPeople : FEBaseModel
@property (nonatomic, copy) NSString *nsid;
@property (nonatomic, copy) NSString *username;


//override parent
-(instancetype)initWithString:(NSString *)string;
@end
