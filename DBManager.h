//
//  DBManager.h
//  InspectorDemo
//
//  Created by Raman on 9/1/10.
//  Copyright 2010 CS Soft Solutions Ltd. All rights reserved.
//
 
 #import <Foundation/Foundation.h>
 #import "sqlite3.h"
 
 @interface DBManager : NSObject 
{	 
    sqlite3 *dataBaseConnection;
}

+ (DBManager*) sharedDatabase;
+ (void) createEditableCopyOfDatabaseIfNeeded;

- (void) openDatabaseConnection; 
- (void) closeDatabaseConnection;
-(void)insertRecord: (NSString *)qry;
-(void)updated:(NSString *)query;
-(void)updateIndexes:(NSString*)updateString;
-(void)deleteRecord:(NSString *)query;

-(NSMutableArray *)getLevel1Records:(NSString *)_qry;
-(NSMutableArray *)getMemoryRecords:(NSString *)_qry;
-(NSMutableArray *)getLvlRecords:(NSString *)_qry;
-(NSMutableArray *)getListingRecords:(NSString *)_qry;
-(NSMutableArray *)getFrameRecords:(NSString *)_qry;

-(NSMutableArray *)getWinterRecords:(NSString *)_qry;
-(NSMutableArray *)getSummerRecords:(NSString *)_qry;
-(NSMutableArray *)getPlaygroundRecords:(NSString *)_qry;
-(NSMutableArray *)getIndoorRecords:(NSString *)_qry;
-(NSMutableArray *)getListeningRecords:(NSString *)_qry;

-(NSMutableArray *)getPartsDB:(NSString *)_qry;
-(NSMutableArray *)getFinalizeDescriptionDB:(NSString *)_qry;

@end
