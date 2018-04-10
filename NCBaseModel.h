//
//  NCBaseModel.h
//  Newchic
//
//  Created by wharlim on 17/2/17.
//  Copyright © 2017年 Newchic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, NCBaseModelSafeType) {
    NCBaseModelSafeTypeNone                  = 0,
    NCBaseModelSafeTypeNSString              = 1 << 0,
    NCBaseModelSafeTypeNSNumber              = 1 << 1,
    NCBaseModelSafeTypeNSArray               = 1 << 2,
    NCBaseModelSafeTypeNSDictionary          = 1 << 3,
    
    NCBaseModelSafeTypeNSMutableString       = 1 << 4,
    NCBaseModelSafeTypeNSMutableArray        = 1 << 5,
    NCBaseModelSafeTypeNSMutableDictionary   = 1 << 6,
    
    NCBaseModelSafeTypeString                = NCBaseModelSafeTypeNSString | NCBaseModelSafeTypeNSMutableString,      //包括 NSString 和 NSMutableString
    NCBaseModelSafeTypeArray                 = NCBaseModelSafeTypeNSArray | NCBaseModelSafeTypeNSMutableArray,      //包括 NSArray 和 NSMutableArray
    NCBaseModelSafeTypeDictionary            = NCBaseModelSafeTypeNSDictionary | NCBaseModelSafeTypeNSMutableDictionary,      //包括 NSDictionary 和 NSMutableDictionary
    
    
    NCBaseModelSafeTypeALL                   = 0x1FFFFFFF    //所有的类型
};


@interface NCBaseModel : NSObject<NSCopying,NSCoding,YYModel>

///用 YYModel，JSON 转 Model
+(instancetype)modelWithDictionary:(NSDictionary *)dic;

///用 YYModel，JSON 转 Model
+ (instancetype)modelWithJSON:(id)json;

-(NCBaseModelSafeType)safePropertyType;

-(id)modelToJSONObject;


@end
