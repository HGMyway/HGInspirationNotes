//
//  HGSqlModelProtocol.h
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/28.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#ifndef HGSqlModelProtocol_h
#define HGSqlModelProtocol_h


//typedef NS_ENUM(NSUInteger, GYCacheLevel) {
//	GYCacheLevelNoCache,
//	GYCacheLevelDefault,
//	GYCacheLevelResident
//};

@protocol HGSqlModelProtocol <NSObject>

//@property (nonatomic, getter=isCacheHit, readonly) BOOL cacheHit;
//@property (nonatomic, getter=isFault, readonly) BOOL fault;
//@property (nonatomic, getter=isSaving, readonly) BOOL saving;
//@property (nonatomic, getter=isDeleted, readonly) BOOL deleted;

+ (NSString *)dbName;
+ (NSString *)tableName;
+ (NSString *)primaryKey;
+ (NSArray *)persistentProperties;
//
//+ (NSDictionary *)propertyTypes;
//+ (NSDictionary *)propertyClasses;
//+ (NSSet *)relationshipProperties;
//
//+ (GYCacheLevel)cacheLevel;
//
//+ (NSString *)fts;

@optional
//+ (NSArray *)indices;
+ (NSDictionary *)defaultValues;

//+ (NSString *)tokenize;

@end

//@protocol GYTransformableProtocol <NSObject>
//
//+ (NSData *)transformedValue:(id)value;
//+ (id)reverseTransformedValue:(NSData *)value;
//
//@end
//
//typedef NS_ENUM(NSUInteger, GYPropertyType) {
//	GYPropertyTypeUndefined,
//	GYPropertyTypeInteger,
//	GYPropertyTypeFloat,
//	GYPropertyTypeString,
//	GYPropertyTypeBoolean,
//	GYPropertyTypeDate,
//	GYPropertyTypeData,
//	GYPropertyTypeTransformable,
//	GYPropertyTypeRelationship
//};

#endif /* HGSqlModelProtocol_h */
