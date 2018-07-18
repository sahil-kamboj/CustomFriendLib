//
//  DBManager.m
//  InspectorDemo
//
//  Created by Raman on 9/1/10.
//  Copyright 2010 CS Soft Solutions Ltd. All rights reserved.
//
//
 #import "DBManager.h"
 
 #define INSPECTORDB @"GuldalDB"

@implementation DBManager
static DBManager*	myInstance;

+ (DBManager*) sharedDatabase 
{
	if (!myInstance) 
	{
		myInstance = [[DBManager alloc] init];
	}
	return myInstance;
}

#pragma mark -Create and save the database on documentsDirectory
- (void) openDatabaseConnection 
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:INSPECTORDB];
	// Open the database. The database was prepared outside the application.
	if (sqlite3_open([path UTF8String], &dataBaseConnection) == SQLITE_OK)
	{
		NSLog(@"Database Successfully Opened ;)");
	} 
	else 
	{
		NSLog(@"Error in opening database :(");
	}
}

 - (void) closeDatabaseConnection
{
	sqlite3_close(dataBaseConnection);
	NSLog(@"Database Successfully Closed :)");
}

 - (NSMutableArray*)  getAllDataforLevel:(NSString*)query
{
    NSLog(@"%@",query);
 	NSMutableArray* arr = [[NSMutableArray alloc] init];
 	
 
 	const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
 	sqlite3_stmt *statement = nil;
 	
 	if(sqlite3_prepare_v2(dataBaseConnection,sql, -1, &statement, NULL)!= SQLITE_OK){
 		NSAssert1(0,@"error preparing statement",sqlite3_errmsg(dataBaseConnection));
 	
    }
 	else
 	{
 		while (sqlite3_step(statement) == SQLITE_ROW)
 		{
 		[arr addObject:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,1)]];
 			
 		}
 	}
 	sqlite3_finalize(statement);

 	return arr;
 }
 
 

-(void)insert:(NSString *)query
{
    [self openDatabaseConnection];
	NSLog(@"saveNewTemplateData query=%@",query);
	const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
	sqlite3_stmt *statement = nil;
	
	if(sqlite3_prepare_v2(dataBaseConnection,sql , -1, &statement, NULL)!= SQLITE_OK)
	{
		NSAssert1(0,@"error preparing statement",sqlite3_errmsg(dataBaseConnection));
	}
	else
	{
		sqlite3_step(statement);
	}
	sqlite3_finalize(statement);
	[self closeDatabaseConnection];

}

-(void)updated:(NSString *)query
{
    [self openDatabaseConnection];
    
    NSLog(@"Query>%@",query);
//	NSString *query;
////	query = [NSString stringWithFormat:@"insert into tbfield(fieldbudget) values ('%@')",fieldbudget];
//    
//    query=[NSString stringWithFormat:@"update tbfield set fieldbudget=%i where fieldname=%@"];
	NSLog(@"saveNewTemplateData query=%@",query);
	const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
	sqlite3_stmt *statement = nil;
	
	if(sqlite3_prepare_v2(dataBaseConnection,sql , -1, &statement, NULL)!= SQLITE_OK)
	{
		NSAssert1(0,@"error preparing statement",sqlite3_errmsg(dataBaseConnection));
	}
	else
	{
		sqlite3_step(statement);
	}
	sqlite3_finalize(statement);
	[self closeDatabaseConnection];
    

}
//-(void)updateIndexes:(NSString*)tbleName Template:(NSString*)templateName newIndex:(int)_index
-(void)updateIndexes:(NSString*)query{
	[self openDatabaseConnection];
	//NSString *query;
//	query = [NSString stringWithFormat:@"update %@ set INDEXING = %d where NAME = \'%@\'",tbleName,_index,templateName];  
    
	NSLog(@"Query>%@",query);
    
/*    char *error = NULL;
    if (sqlite3_exec(dataBaseConnection, [query UTF8String], NULL, NULL, &error))
    {
        NSLog(@"%s",error);
 
    }
    else
    {
        NSLog(@"%s",error);
    }
 */  
    
	const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
	sqlite3_stmt *statement = nil;
	
	if(sqlite3_prepare_v2(dataBaseConnection,sql, -1, &statement, NULL)!= SQLITE_OK)
	{
		NSAssert1(0,@"error preparing statement",sqlite3_errmsg(dataBaseConnection));
	}
	else
	{
		int success = sqlite3_step(statement);
		NSLog(@"success=%i",success);
	}
	sqlite3_finalize(statement);
  
	[self closeDatabaseConnection];
	
}

#pragma mark - Local Database methods

+ (void) createEditableCopyOfDatabaseIfNeeded{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:INSPECTORDB];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success)
    {
        //NSLog(@"ALready exists");
        return;
    }
    //	// The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:INSPECTORDB];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
    NSLog(@"defaultDBPath =%@",defaultDBPath);
    if (!success)
    {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}



-(void)insertRecord: (NSString *)qry{
    
    NSLog(@" insert qry  =%@",qry);
    [self openDatabaseConnection];
    const char *sql = [qry cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(dataBaseConnection,sql, -1, &statement, NULL)!= SQLITE_OK){
        NSAssert1(0,@"error preparing statement",sqlite3_errmsg(dataBaseConnection));
    }
    else{
        sqlite3_step(statement);
    }
    sqlite3_finalize(statement);
    [self closeDatabaseConnection];
}




-(void)deleteRecord:(NSString *)query
{
   //NSLog(query);
    
    [self openDatabaseConnection];
    
    const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt *statement = nil;
    
    if(sqlite3_prepare_v2(dataBaseConnection,sql, -1, &statement, NULL)!= SQLITE_OK)
    {
        NSAssert1(0,@"error preparing statement",sqlite3_errmsg(dataBaseConnection));
    }
    else
    {
         int success = sqlite3_step(statement);
         NSLog(@"%d",success);
    }
    sqlite3_finalize(statement);
    [self closeDatabaseConnection];
    
    
}




-(NSMutableArray *)getPartsDB:(NSString *)_qry{
    NSLog(@"_qry =%@",_qry);
    @try
    {
        NSMutableArray *list  =[[NSMutableArray alloc]init];
        [self openDatabaseConnection];
        NSString *query;
        query =_qry;
        const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *statement = nil;
        if(sqlite3_prepare_v2(dataBaseConnection,sql, -1, &statement, NULL)!= SQLITE_OK)
        {
            NSAssert1(0,@"error preparing statement",sqlite3_errmsg(dataBaseConnection));
        }
        else
        {
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                //timeStamp,Id,PartID,Price,Quantity,WOEquipmentId
                //Description
                
                NSMutableDictionary *partDict = [[NSMutableDictionary alloc]init];
                [partDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,0)] forKey:@"WOID"];
                [partDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,1)] forKey:@"EqpID"];
                [partDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,2)] forKey:@"Name"];
                [partDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,3)] forKey:@"timeStamp"];
                [partDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,4)] forKey:@"Description"];
                [partDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,5)] forKey:@"Id"];
                [partDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,6)] forKey:@"PartID"];
                [partDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,7)] forKey:@"Price"];
                [partDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,8)] forKey:@"Quantity"];
                [partDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,9)] forKey:@"WOEquipmentId"];
                [list addObject:partDict];
            }
        }
        sqlite3_finalize(statement);
        [self closeDatabaseConnection];
        return list;
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"Error =%@",[NSString stringWithFormat:@"%@   %@",exception.description,NSStringFromSelector(_cmd)]);
        
        
    }
    @finally {
        
    }
}



-(NSMutableArray *)getLevel1Records:(NSString *)_qry{
    NSLog(@"_qry =%@",_qry);
    @try
    {
        NSMutableArray *list  =[[NSMutableArray alloc]init];
        [self openDatabaseConnection];
        NSString *query;
        query =_qry;
        const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *statement = nil;
        if(sqlite3_prepare_v2(dataBaseConnection,sql, -1, &statement, NULL)!= SQLITE_OK)
        {
            NSAssert1(0,@"error preparing statement",sqlite3_errmsg(dataBaseConnection));
        }
        else
        {
            while (sqlite3_step(statement) == SQLITE_ROW){
                NSMutableDictionary *clockDict = [[NSMutableDictionary alloc]init];
                [clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,0)] forKey:@"lvlCod"];
                [clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,1)] forKey:@"lvlPair1"];
                [clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,2)] forKey:@"lvlPair2"];
                [list addObject:clockDict];
            }
        }
        sqlite3_finalize(statement);
        [self closeDatabaseConnection];
        return list;
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"Error =%@",[NSString stringWithFormat:@"%@   %@",exception.description,NSStringFromSelector(_cmd)]);
        
        
    }
    @finally {
        
    }
}


-(NSMutableArray *)getMemoryRecords:(NSString *)_qry{
    NSLog(@"_qry =%@",_qry);
    @try
    {
        NSMutableArray *list  =[[NSMutableArray alloc]init];
        [self openDatabaseConnection];
        NSString *query;
        query =_qry;
        const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *statement = nil;
        if(sqlite3_prepare_v2(dataBaseConnection,sql, -1, &statement, NULL)!= SQLITE_OK)
        {
            NSAssert1(0,@"error preparing statement",sqlite3_errmsg(dataBaseConnection));
        }
        else
        {
            while (sqlite3_step(statement) == SQLITE_ROW){
                NSMutableDictionary *clockDict = [[NSMutableDictionary alloc]init];
                [clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,0)] forKey:@"lvlCod"];
                [clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,1)] forKey:@"Name"];
                [list addObject:clockDict];
            }
        }
        sqlite3_finalize(statement);
        [self closeDatabaseConnection];
        return list;
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"Error =%@",[NSString stringWithFormat:@"%@   %@",exception.description,NSStringFromSelector(_cmd)]);
        
        
    }
    @finally {
        
    }
}

-(NSMutableArray *)getListingRecords:(NSString *)_qry{
    NSLog(@"_qry =%@",_qry);
    @try
    {
        NSMutableArray *list  =[[NSMutableArray alloc]init];
        [self openDatabaseConnection];
        NSString *query;
        query =_qry;
        const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *statement = nil;
        if(sqlite3_prepare_v2(dataBaseConnection,sql, -1, &statement, NULL)!= SQLITE_OK)
        {
            NSAssert1(0,@"error preparing statement",sqlite3_errmsg(dataBaseConnection));
        }
        else
        {
            while (sqlite3_step(statement) == SQLITE_ROW){
                NSMutableDictionary *clockDict = [[NSMutableDictionary alloc]init];
                [clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,0)] forKey:@"lvlCod"];
                [clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,1)] forKey:@"Name"];
                [list addObject:clockDict];
            }
        }
        sqlite3_finalize(statement);
        [self closeDatabaseConnection];
        return list;
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"Error =%@",[NSString stringWithFormat:@"%@   %@",exception.description,NSStringFromSelector(_cmd)]);
        
        
    }
    @finally {
        
    }
}





//  Change
#pragma mark - Level Records

-(NSMutableArray *)getLvlRecords:(NSString *)_qry{
    NSLog(@"_qry =%@",_qry);
    @try
    {
        NSMutableArray *list  =[[NSMutableArray alloc]init];
        [self openDatabaseConnection];
        NSString *query;
        query =_qry;
        const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *statement = nil;
        if(sqlite3_prepare_v2(dataBaseConnection,sql, -1, &statement, NULL)!= SQLITE_OK)
        {
            NSAssert1(0,@"error preparing statement",sqlite3_errmsg(dataBaseConnection));
        }
        else
        {
            while (sqlite3_step(statement) == SQLITE_ROW){
                NSMutableDictionary *clockDict = [[NSMutableDictionary alloc]init];
                [clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,0)] forKey:@"comcod"];
                [clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,1)] forKey:@"Game"];
                [clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,2)] forKey:@"level"];
                [clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,3)] forKey:@"Played"];
                [list addObject:clockDict];
            }
        }
        sqlite3_finalize(statement);
        [self closeDatabaseConnection];
        return list;
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"Error =%@",[NSString stringWithFormat:@"%@   %@",exception.description,NSStringFromSelector(_cmd)]);
        
        
    }
    @finally {
        
    }
}



#pragma mark - Frame records

-(NSMutableArray *)getFrameRecords:(NSString *)_qry{
	NSLog(@"_qry =%@",_qry);
	@try
	{
		NSMutableArray *list  =[[NSMutableArray alloc]init];
		[self openDatabaseConnection];
		NSString *query;
		query =_qry;
		const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
		sqlite3_stmt *statement = nil;
		if(sqlite3_prepare_v2(dataBaseConnection,sql, -1, &statement, NULL)!= SQLITE_OK)
		{
			NSAssert1(0,@"error preparing statement",sqlite3_errmsg(dataBaseConnection));
		}
		else
		{
			while (sqlite3_step(statement) == SQLITE_ROW){
				NSMutableDictionary *clockDict = [[NSMutableDictionary alloc]init];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,0)] forKey:@"frameId"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,1)] forKey:@"frameName"];
				
				[list addObject:clockDict];
			}
		}
		sqlite3_finalize(statement);
		[self closeDatabaseConnection];
		return list;
		
	}
	@catch (NSException *exception) {
		
		NSLog(@"Error =%@",[NSString stringWithFormat:@"%@   %@",exception.description,NSStringFromSelector(_cmd)]);
		
		
	}
	@finally {
		
	}
}


#pragma mark - Winter Theme Frames

-(NSMutableArray *)getWinterRecords:(NSString *)_qry{
	NSLog(@"_qry =%@",_qry);
	@try
	{
		NSMutableArray *list  =[[NSMutableArray alloc]init];
		[self openDatabaseConnection];
		NSString *query;
		query =_qry;
		const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
		sqlite3_stmt *statement = nil;
		if(sqlite3_prepare_v2(dataBaseConnection,sql, -1, &statement, NULL)!= SQLITE_OK)
		{
			NSAssert1(0,@"error preparing statement",sqlite3_errmsg(dataBaseConnection));
		}
		else
		{
			while (sqlite3_step(statement) == SQLITE_ROW){
				NSMutableDictionary *clockDict = [[NSMutableDictionary alloc]init];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,0)] forKey:@"winterId"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,1)] forKey:@"fileName"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,2)] forKey:@"level"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,3)] forKey:@"goodFrame1"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,4)] forKey:@"goodFrame2"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,5)] forKey:@"goodFrame3"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,6)] forKey:@"goodFrame4"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,7)] forKey:@"goodFrame5"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,8)] forKey:@"goodFrame6"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,9)] forKey:@"goodFrame7"];
                [clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,10)] forKey:@"goodFrame8"];
				
				[list addObject:clockDict];
			}
		}
		sqlite3_finalize(statement);
		[self closeDatabaseConnection];
		return list;
		
	}
	@catch (NSException *exception) {
		
		NSLog(@"Error =%@",[NSString stringWithFormat:@"%@   %@",exception.description,NSStringFromSelector(_cmd)]);
		
		
	}
	@finally {
		
	}
}


#pragma mark - Summer Theme Frames

-(NSMutableArray *)getSummerRecords:(NSString *)_qry{
	NSLog(@"_qry =%@",_qry);
	@try
	{
		NSMutableArray *list  =[[NSMutableArray alloc]init];
		[self openDatabaseConnection];
		NSString *query;
		query =_qry;
		const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
		sqlite3_stmt *statement = nil;
		if(sqlite3_prepare_v2(dataBaseConnection,sql, -1, &statement, NULL)!= SQLITE_OK)
		{
			NSAssert1(0,@"error preparing statement",sqlite3_errmsg(dataBaseConnection));
		}
		else
		{
			while (sqlite3_step(statement) == SQLITE_ROW){
				NSMutableDictionary *clockDict = [[NSMutableDictionary alloc]init];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,0)] forKey:@"summerId"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,1)] forKey:@"fileName"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,2)] forKey:@"level"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,3)] forKey:@"goodFrame1"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,4)] forKey:@"goodFrame2"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,5)] forKey:@"goodFrame3"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,6)] forKey:@"goodFrame4"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,7)] forKey:@"goodFrame5"];
				//[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,8)] forKey:@"goodFrame6"];
				//[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,9)] forKey:@"goodFrame7"];
				//[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,10)] forKey:@"goodFrame8"];
				//[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,11)] forKey:@"goodFrame9"];
				//[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,12)] forKey:@"goodFrame10"];
				//[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,13)] forKey:@"goodFrame11"];
				//[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,14)] forKey:@"goodFrame12"];
				//[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,15)] forKey:@"goodFrame13"];
				
				[list addObject:clockDict];
			}
		}
		sqlite3_finalize(statement);
		[self closeDatabaseConnection];
		return list;
		
	}
	@catch (NSException *exception) {
		
		NSLog(@"Error =%@",[NSString stringWithFormat:@"%@   %@",exception.description,NSStringFromSelector(_cmd)]);
		
		
	}
	@finally {
		
	}
}


#pragma mark - Playground Theme Frames

-(NSMutableArray *)getPlaygroundRecords:(NSString *)_qry{
	NSLog(@"_qry =%@",_qry);
	@try
	{
		NSMutableArray *list  =[[NSMutableArray alloc]init];
		[self openDatabaseConnection];
		NSString *query;
		query =_qry;
		const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
		sqlite3_stmt *statement = nil;
		if(sqlite3_prepare_v2(dataBaseConnection,sql, -1, &statement, NULL)!= SQLITE_OK)
		{
			NSAssert1(0,@"error preparing statement",sqlite3_errmsg(dataBaseConnection));
		}
		else{
			while (sqlite3_step(statement) == SQLITE_ROW){
				NSMutableDictionary *clockDict = [[NSMutableDictionary alloc]init];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,0)] forKey:@"playgroundId"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,1)] forKey:@"fileName"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,2)] forKey:@"level"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,3)] forKey:@"goodFrame1"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,4)] forKey:@"goodFrame2"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,5)] forKey:@"goodFrame3"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,6)] forKey:@"goodFrame4"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,7)] forKey:@"goodFrame5"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,8)] forKey:@"goodFrame6"];
                [clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,9)] forKey:@"goodFrame7"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,10)] forKey:@"goodFrame8"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,11)] forKey:@"goodFrame9"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,12)] forKey:@"goodFrame10"];
				
				[list addObject:clockDict];
			}
		}
		sqlite3_finalize(statement);
		[self closeDatabaseConnection];
		return list;
		
	}
	@catch (NSException *exception) {
		
		NSLog(@"Error =%@",[NSString stringWithFormat:@"%@   %@",exception.description,NSStringFromSelector(_cmd)]);
		
		
	}
	@finally {
		
	}
}



#pragma mark - Indoor Theme Frames

-(NSMutableArray *)getIndoorRecords:(NSString *)_qry{
	NSLog(@"_qry =%@",_qry);
	@try
	{
		NSMutableArray *list  =[[NSMutableArray alloc]init];
		[self openDatabaseConnection];
		NSString *query;
		query =_qry;
		const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
		sqlite3_stmt *statement = nil;
		if(sqlite3_prepare_v2(dataBaseConnection,sql, -1, &statement, NULL)!= SQLITE_OK){
			NSAssert1(0,@"error preparing statement",sqlite3_errmsg(dataBaseConnection));
		}
		else{
			while (sqlite3_step(statement) == SQLITE_ROW){
				NSMutableDictionary *clockDict = [[NSMutableDictionary alloc]init];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,0)] forKey:@"indoorId"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,1)] forKey:@"fileName"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,2)] forKey:@"goodFrame"];
				
				[list addObject:clockDict];
			}
		}
		sqlite3_finalize(statement);
		[self closeDatabaseConnection];
		return list;
		
	}
	@catch (NSException *exception) {
		NSLog(@"Error =%@",[NSString stringWithFormat:@"%@   %@",exception.description,NSStringFromSelector(_cmd)]);
		
	}
	@finally {
		
	}
}




#pragma mark - Listening Frames

-(NSMutableArray *)getListeningRecords:(NSString *)_qry{
	NSLog(@"_qry =%@",_qry);
	@try
	{
		NSMutableArray *list  =[[NSMutableArray alloc]init];
		[self openDatabaseConnection];
		NSString *query;
		query =_qry;
		const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
		sqlite3_stmt *statement = nil;
		if(sqlite3_prepare_v2(dataBaseConnection,sql, -1, &statement, NULL)!= SQLITE_OK)
		{
			NSAssert1(0,@"error preparing statement",sqlite3_errmsg(dataBaseConnection));
		}
		else
		{
			while (sqlite3_step(statement) == SQLITE_ROW){
				NSMutableDictionary *clockDict = [[NSMutableDictionary alloc]init];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,0)] forKey:@"lvlcod"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,1)] forKey:@"lvl"];
				[clockDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,2)] forKey:@"isPlayed"];
				[list addObject:clockDict];
			}
		}
		sqlite3_finalize(statement);
		[self closeDatabaseConnection];
		return list;

	}
	@catch (NSException *exception) {
		NSLog(@"Error =%@",[NSString stringWithFormat:@"%@   %@",exception.description,NSStringFromSelector(_cmd)]);
	}
	@finally {
		
	}
}



-(NSMutableArray *)getFinalizeDescriptionDB:(NSString *)_qry{
    NSLog(@"_qry =%@",_qry);
    @try
    {
        NSMutableArray *list  =[[NSMutableArray alloc]init];
        [self openDatabaseConnection];
        NSString *query;
        query =_qry;
        const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *statement = nil;
        if(sqlite3_prepare_v2(dataBaseConnection,sql, -1, &statement, NULL)!= SQLITE_OK)
        {
            NSAssert1(0,@"error preparing statement",sqlite3_errmsg(dataBaseConnection));
        }
        else
        {
            while (sqlite3_step(statement) == SQLITE_ROW){
                NSMutableDictionary *WoDict = [[NSMutableDictionary alloc]init];
                [WoDict setValue:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement,0)] forKey:@"WO_DSC"];
                [list addObject:WoDict];
            }
        }
        sqlite3_finalize(statement);
        [self closeDatabaseConnection];
        return list;
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"Error =%@",[NSString stringWithFormat:@"%@   %@",exception.description,NSStringFromSelector(_cmd)]);
        
        
    }
    @finally {
        
    }
}



@end
