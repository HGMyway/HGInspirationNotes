//
//  HGDBBaseModel+Sql.m
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/28.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import "HGDBBaseModel+Sql.h"
#import <YYModel.h>
@implementation HGDBBaseModel (Sql)

	//
+ (NSString *)createTableSql{
	NSArray *columnDefinitions = [self columnDefinitions];
	return [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@)",
			[self tableName],
			[columnDefinitions componentsJoinedByString:@","]];
}
//+ (NSArray *)columnDefinitions{
//	return  [self sortedProperties];
//}
+ (NSArray *)sortedProperties{
	NSMutableArray *propertyArray = [NSMutableArray new];
	unsigned int propertyCount = 0;
	objc_property_t *properties = class_copyPropertyList(self.class, &propertyCount);
	if (properties) {
		for (unsigned int i = 0; i < propertyCount; i++) {
			const char *name = property_getName(properties[i]);
			if (name) {
				[propertyArray addObject:[NSString stringWithUTF8String:name]];
			}
		}
	}
	NSString *primaryKey = [self primaryKey];
	if (primaryKey) {
		[propertyArray removeObject:primaryKey];
	}
	[propertyArray sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
		return [obj1 compare:obj2];
	}];
	if (primaryKey) {
		[propertyArray insertObject:primaryKey atIndex:0];
	}
	return propertyArray.count? [propertyArray copy] : nil;
}
+ (NSArray *)columnDefinitions {
	NSMutableArray *columnDefinitions = [[NSMutableArray alloc] init];
	for (NSString *property in [self sortedProperties]) {
		[columnDefinitions addObject:[self columnDefinitionForProperty:property]];
	}
	return columnDefinitions;
}
+ (NSString *)columnDefinitionForProperty:(NSString *)property{
	return nil;
}

@end
