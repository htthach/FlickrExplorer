//
//  FEFlickrXMLParser.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 13/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FEDataToObjectParser.h"



/**
 Flickr XML format looks a bit different from normal xml in the way object properties are placed. 
 If want to use XML for flickr, implement this parser.
 For demo purpose, I'll leave this class empty and use the JSON parser.
 */
@interface FEFlickrXMLParser : NSObject <FEDataToObjectParser>

@end
