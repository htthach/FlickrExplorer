//
//  FEPeople.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 16/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FEPeople.h"

@implementation FEPeople

//override parent
-(instancetype)initWithString:(NSString *)string{
    self = [super initWithString:string];
    if (self) {
        self.nsid = string;
    }
    return self;
}
@end
