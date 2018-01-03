//
//  HGSqlManagerBase.h
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/25.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#define hg_myway_db @"/hg_myway_db.sqlite"
@interface HGSqlManagerBase : NSObject

-(FMDatabase *) fmdb_instance;
-(BOOL) open;
-(BOOL) close;



-(BOOL) commit;

-(BOOL)beginTransaction;
-(BOOL)rollback;
-(BOOL)inTransaction;
-(BOOL)beginDeferredTransaction;

@end
