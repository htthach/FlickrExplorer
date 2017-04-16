//
//  FEBaseModel.m
//  Flickr Explorer
//
//  Created by Tinh Thach Hinh on 14/4/17.
//  Copyright © 2017 Hinh Tinh Thach. All rights reserved.
//

#import "FEBaseModel.h"
#import <objc/runtime.h>


static int const FE_PARSING_ERROR_CODE             = 100;
static NSString * const FE_PARSING_ERROR_DOMAIN    = @"com.flickrexplorer.ios.modelparser";


@implementation FEBaseModel
/**
 Initialize from a dictionary with automatic parsing
 
 @param dictionary the dictionary to initialized from
 @param error return pointer for error from parsing
 @return instance of this class
 */
-(instancetype) initWithDictionary:(NSDictionary*) dictionary error:(NSError**) error{
    self = [super init];
    if (self) {
        [self parseFromDictionary:dictionary error:error];
    }
    return self;
}
/**
 Initialze from a string. Default implementation in base class is to do nothing
 
 @param  string the string to init this object
 @return instance of this class
 */
-(instancetype) initWithString:(NSString*) string{
    return [super init];
}
#pragma mark - to be inherit

/**
 Return the key map between json key vs this object property name. By default we set property name same as json tag.
 Child class can override this if there is mismatch between object property name and json tag.

 @return the key map between json key vs this object property name
 */
-(NSMutableDictionary *)getKeyMap{
    //implement this if there is mismatch between object property name and json tag
    //return a dictionary with Object = property name, and Key = json tag
    
    //default behavior is to set same key (aka "myProperty" on object vs "myProperty" on json)
    NSDictionary *propertyDic = [self getPropertyDictionary];
    NSArray *allKey = [propertyDic allKeys];
    NSMutableDictionary *keyMap = [NSMutableDictionary dictionary];
    for (NSString *key in allKey) {
        NSString *mappedKey = [key copy];
        [keyMap setObject:key forKey:mappedKey];
    }
    return keyMap;
}

/**
 if there is a property of type array, return the class of that array's elements
 
 @param arrayName name of that property
 @return class of the array's elements
 */
-(Class) getClassForArrayName:(NSString*) arrayName{
    return [NSString class];
}
#pragma mark - generic parsing method


/**
 Get a property type from a property

 @param property the property to check
 @return the type of requested property
 */
static NSString *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    NSString *finalAttr=nil;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && strlen(attribute)>4) {
            NSString *attr = [[NSString alloc] initWithData:[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] encoding:NSUTF8StringEncoding];
            finalAttr = attr;
            break;
            return attr;
        }
    }
    if (finalAttr) {
        return finalAttr;
    }
    return @"";
}


/**
 Get a dictionary of properties of this object that map property name to property type

 @return dictionary of properties of this object that map property name to property type
 */
-(NSMutableDictionary*) getPropertyDictionary{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        
        const char *propName = property_getName(property);
        NSString *name = @(propName);
        NSString *type = getPropertyType(property);
        
        [dict setObject:type forKey:name];
    }
    free(properties);
    return dict;
}


/**
 Create an array of parsed object from an array of json object to be set to one of a property of this object

 @param data an array of json data
 @param name the name of the property to map to
 @param error return pointer for error from parsing
 @return an array of parsed object from an array of json object to be set to one of a property of this object
 */
-(NSMutableArray *)createArrayFromDataArray:(NSArray *)data withName:(NSString*) name  error:(NSError**) error{
    if (!([data isKindOfClass:[NSArray class]] || [data isKindOfClass:[NSMutableArray class]])) {
        *error = [FEBaseModel genericParsingError];
        return nil;
    }
    if ([data count] == 0) {
        //empty array
        return [NSMutableArray array];
    }
    if (!name || [name length] == 0) {
        *error = [FEBaseModel genericParsingError];
        return nil;
    }
    
    id firstObject = [data objectAtIndex:0];
    NSMutableArray *resultArray = [NSMutableArray array];
    if ([firstObject isKindOfClass:[NSString class]]) {
        for (NSString *item in data) {
            [resultArray addObject:item];
        }
    }
    else {
        
        Class objClass = [self getClassForArrayName:name];
        if ([objClass isSubclassOfClass:[FEBaseModel class]]) {
            for (NSDictionary *item in data) {
                id object = [[objClass alloc] init];
                [object parseFromDictionary:item error:error];
                [resultArray addObject:object];
            }
        }
        else{
            for (id item in data) {
                [resultArray addObject:item];
            }
        }
        
    }
    
    return [NSMutableArray arrayWithArray:resultArray];
}


/**
 Parse a json dictionary into properties recursively
 @param error return pointer for error from parsing
 @param data json dictionary to parse
 */
-(void) parseFromDictionary:(NSDictionary *)data  error:(NSError**) error{
    if (![data isKindOfClass:[NSDictionary class]]) {
        *error = [FEBaseModel genericParsingError];
        return;
    }
    NSArray *allKeys = [data allKeys];
    NSMutableDictionary *keyMap = [self getKeyMap];
    NSDictionary *propertyDic = [self getPropertyDictionary];
    
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    for (NSString *key in allKeys) {
        
        NSString *subtitutedKey = nil;
        if (keyMap) subtitutedKey = [keyMap valueForKey:key];
        if (!subtitutedKey) {
            subtitutedKey = key;
        }
        
        id value = [data objectForKey:key];
        NSString *typeStr = [propertyDic objectForKey:subtitutedKey];
        Class childClass = NSClassFromString(typeStr);
        
        //for simplicity only handle NSString, NSNumber, NSDictionary and NSArray
        
        
        if ([childClass isSubclassOfClass:[NSString class]]) {
            if ([self respondsToSelector:NSSelectorFromString(subtitutedKey)])  {
                if ([value isKindOfClass:[NSString class]]) {
                    [self setValue:value forKey:subtitutedKey];
                }
                else if ([value respondsToSelector:@selector(stringValue)]){
                    //if server pass something else, we try to convert to string
                    [self setValue:[value stringValue] forKeyPath:subtitutedKey];
                }
            }
            
        }
        else if ([childClass isSubclassOfClass:[NSNumber class]]){
            if ([self respondsToSelector:NSSelectorFromString(subtitutedKey)])  {
                if ([value isKindOfClass:[NSNumber class]]) {
                    [self setValue:value forKey:subtitutedKey];
                }
                else if ([value isKindOfClass:[NSString class]]){
                    //if server pass string, we try to convert to number
                    [self setValue:[formatter numberFromString:value] forKey:subtitutedKey];
                }
            }
            
        }
        else if ([value isKindOfClass:[NSArray class]]){
            
            if ([self respondsToSelector:NSSelectorFromString(subtitutedKey)])  {
                [self setValue:[self createArrayFromDataArray:value
                                                     withName:subtitutedKey
                                                        error:error]
                        forKey:subtitutedKey];
            }
            
        }
        else if ([value isKindOfClass:[NSDictionary class]]){
            if ([self respondsToSelector:NSSelectorFromString(subtitutedKey)])  {
                id childObject = [[childClass alloc] init];
                [childObject parseFromDictionary:value error:error];
                [self setValue:childObject
                        forKey:subtitutedKey];
                
            }
        }
        //extra weird case for flickr parsing because sometimes they return same attributes under different format
        else if ([childClass isSubclassOfClass:[FEBaseModel class]] && [value isKindOfClass:[NSString class]]){
            if ([self respondsToSelector:NSSelectorFromString(subtitutedKey)])  {
                id childObject = [[childClass alloc] initWithString:value];
                [self setValue:childObject
                        forKey:subtitutedKey];
            }
        }
    }
    
}

/**
 Construct an error object to describe the parsing error. For simplicity, at the moment just return a generic error
 
 @return an error object to describe the parsing error. For simplicity, at the moment just return a generic error
 */
+(NSError*) genericParsingError{
    NSError *error = [[NSError alloc] initWithDomain:FE_PARSING_ERROR_DOMAIN code:FE_PARSING_ERROR_CODE userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(@"Json and object structure mismatch", @"Data parsing error message") forKey:NSLocalizedDescriptionKey]];
    return error;
}

@end
