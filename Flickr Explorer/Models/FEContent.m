//
//  FEContent.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 15/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FEContent.h"

@implementation FEContent
-(instancetype)initWithString:(NSString *)string{
    self = [super initWithString:string];
    if (self) {
        self.content = string;
    }
    return self;
}
/**
 Return the key map between json key vs this object property name. By default we set property name same as json tag.
 Child class can override this if there is mismatch between object property name and json tag.
 
 @return the key map between json key vs this object property name
 */
-(NSMutableDictionary *)getKeyMap{
    NSMutableDictionary *keyMap = [super getKeyMap];
    [keyMap setObject:@"content" forKey:@"_content"];
    return keyMap;
}

-(NSString *)description{
    return self.content;
}
@end
