//
//  FEJsonParser.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 14/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FEDataToObjectParser.h"

/**
 A JSON parser that parse a JSON string into an object
 */
@interface FEJsonParser : NSObject <FEDataToObjectParser>

@end
