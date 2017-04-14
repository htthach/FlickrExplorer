//
//  FEBaseModel.h
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 14/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 A simplified base model to handle recursive parsing from dictionary
 */
@interface FEBaseModel : NSObject


/**
 Initialize from a dictionary with automatic parsing

 @param dictionary the dictionary to initialized from
 @param error return pointer for error from parsing
 @return instance of this class
 */
-(instancetype) initWithDictionary:(NSDictionary*) dictionary error:(NSError**) error;

#pragma mark - to be inherit

/**
 Return the key map between json key vs this object property name. By default we set property name same as json tag.
 Child class can override this if there is mismatch between object property name and json tag.
 
 @return the key map between json key vs this object property name
 */
-(NSMutableDictionary *)getKeyMap;

/**
 if there is a property of type array, return the class of that array's elements

 @param arrayName name of that property
 @return class of the array's elements
 */
-(Class) getClassForArrayName:(NSString*) arrayName;
@end
