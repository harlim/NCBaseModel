//
//  NCBaseModel.m
//  Newchic
//
//  Created by wharlim on 17/2/17.
//  Copyright © 2017年 Newchic. All rights reserved.
//

#import "NCBaseModel.h"

@implementation NCBaseModel

+(instancetype)modelWithDictionary:(NSDictionary *)dic{
    return [self yy_modelWithDictionary:dic];
}

+ (instancetype)modelWithJSON:(id)json {
    return [self yy_modelWithJSON:json];
}

-(void)initializeDataAfterModel{
    
}


-(NCBaseModelSafeType)safePropertyType{
    return NCBaseModelSafeTypeNone;
}

-(id)modelToJSONObject{
    return [self yy_modelToJSONObject];
}

#pragma mark -

-(NSString *)getPropertyType:(objc_property_t)property {
    NSString *propertyType = @"";
    unsigned int attrCount;
    objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);
    for (unsigned int i = 0; i < attrCount; i++) {
        if (attrs[i].name[0] == 'T') {
            if (attrs[i].value) {
                NSString *typeEncoding = [NSString stringWithUTF8String:attrs[i].value];
                
                if (typeEncoding.length > 0) {
                    NSScanner *scanner = [NSScanner scannerWithString:typeEncoding];
                    if (![scanner scanString:@"@\"" intoString:NULL]) continue;
                    
                    NSString *clsName = nil;
                    if ([scanner scanUpToCharactersFromSet: [NSCharacterSet characterSetWithCharactersInString:@"\"<"] intoString:&clsName]) {
                        if (clsName.length) propertyType = clsName;
                        break;
                    }
                }
            }
        }
    }
    return propertyType;
}



/**
 * 给对象的属性设置默认值
 */
-(void)setSafeValue{
    NCBaseModelSafeType safePropertyTypeAll = [self safePropertyType];
    if (safePropertyTypeAll == NCBaseModelSafeTypeNone) {
        return;
    }
    NSMutableDictionary *safeTypeDic = [NSMutableDictionary dictionary];
    if (safePropertyTypeAll & NCBaseModelSafeTypeNSString) {
        [safeTypeDic setObject:@"" forKey:NSStringFromClass([NSString class])];
    }
    if (safePropertyTypeAll & NCBaseModelSafeTypeNSNumber) {
        [safeTypeDic setObject:@(0) forKey:NSStringFromClass([NSNumber class])];
    }
    if (safePropertyTypeAll & NCBaseModelSafeTypeNSArray) {
        [safeTypeDic setObject:@[] forKey:NSStringFromClass([NSArray class])];
    }
    if (safePropertyTypeAll & NCBaseModelSafeTypeNSDictionary) {
        [safeTypeDic setObject:@{} forKey:NSStringFromClass([NSDictionary class])];
    }
    
    if (safePropertyTypeAll & NCBaseModelSafeTypeNSMutableString) {
        [safeTypeDic setObject:[@"" mutableCopy] forKey:NSStringFromClass([NSMutableString class])];
    }
    if (safePropertyTypeAll & NCBaseModelSafeTypeNSMutableArray) {
        [safeTypeDic setObject:[@[] mutableCopy] forKey:NSStringFromClass([NSMutableArray class])];
    }
    if (safePropertyTypeAll & NCBaseModelSafeTypeNSMutableDictionary) {
        [safeTypeDic setObject:[@{} mutableCopy] forKey:NSStringFromClass([NSMutableDictionary class])];
    }
    
        unsigned int outCount, i;
        // 包含所有Property的数组
        objc_property_t *properties = class_copyPropertyList([self class], &outCount);
        // 遍历每个Property
        for (i = 0; i < outCount; i++) {
            // 取出对应Property
            objc_property_t property = properties[i];
            
            // 获取Property对应的变量名
            NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
            // 获取Property的类型名
            NSString *propertyTypeName = [self getPropertyType:property];
            // 获取Property的值
            id propertyValue = [self valueForKey:propertyName];
            // 值为空，才设置默认值
            if (!propertyValue) {
                NSString *safeTypeKey =propertyTypeName;
                id safeTypeValue = safeTypeDic[safeTypeKey];
                if (safeTypeValue) {
                    [self setValue:safeTypeValue forKey:propertyName];
                }
            }
        }
        free(properties);
}

#pragma mark - YYModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    [self setSafeValue];
    [self initializeDataAfterModel];
    return YES;
}

#pragma mark - 序列化

- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (instancetype)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }
- (NSString *)description { return [self yy_modelDescription]; }




@end
