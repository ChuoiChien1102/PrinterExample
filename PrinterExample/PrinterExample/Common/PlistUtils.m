//
//  PlistUtils.m
//  SportStone
//
//  Created by  Andrew Huang on 15/1/9.
//  Copyright (c) 2015年  Andrew Huang. All rights reserved.
//

#import "PlistUtils.h"

@implementation PlistUtils

+(NSMutableArray *)readPlistArray:(NSString *)plistName checkDocDir:(BOOL)checkDocDir{
    
    if(checkDocDir){
        NSString * allPath = [plistName stringByAppendingString:@".plist"];
      if([PlistUtils isSandboxFileExists:allPath]){
          return [PlistUtils readFromSandboxFile:allPath];
       }
    }
    
    return [PlistUtils readPlistFile:plistName];
}

+(BOOL)isPlistFileExist:(NSString * )fileName{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    
    if(path==NULL)
        
        return NO;
    
    return YES;
}


+ (NSMutableArray *) readPlistFile: (NSString *)fileName{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:fileName ofType:@"plist"];
    return [[NSMutableArray  alloc] initWithContentsOfFile:plistPath];
}

+ (NSString*)getSandboxFilePath:(NSString*)fileName{
    //沙盒中的文件路径
    NSArray *storeFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucumentsDirectiory = [storeFilePath objectAtIndex:0];
    NSString *plistPath =[doucumentsDirectiory stringByAppendingPathComponent:fileName];       //根据需要更改文件名
    return plistPath;
}

//判断沙盒中名为plistname的文件是否存在
+(BOOL) isSandboxFileExists:(NSString*)fileName{
    
    NSString *plistPath =[ PlistUtils getSandboxFilePath:fileName ];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if( [fileManager fileExistsAtPath:plistPath]== NO ) {
        // NSLog(@"not exists");
        return NO;
    }else{
        return YES;
    }
    
}


+(BOOL) deleteSandboxFile:(NSString*)fileName{
    NSString *plistPath =[ PlistUtils getSandboxFilePath:fileName ];
    
    return [[NSFileManager defaultManager] removeItemAtPath:plistPath error:nil];
    
    
}


+(BOOL)isBundleFileExist:(NSString * )fileName{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@""];
    
    if(path==NULL)
        
        return NO;
    
    return YES;
}

+ (NSString *) writeToFile: (NSString*)fileName withData:(NSData *)data
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    [data writeToFile:finalPath atomically:YES];
    /* This would change the firmware version in the plist to 1.1.1 by initing the NSDictionary with the plist, then changing the value of the string in the key "ProductVersion" to what you specified */
    
    return finalPath;
}

+(NSData *)readFromFile:(NSString *)fileName{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:finalPath];
    
    if (fileExists) {
        NSData  *arr = [[NSData alloc] initWithContentsOfFile:finalPath];
        return arr;
    } else {
        return nil;
    }
}

+ (NSString *) writeToSandboxFile: (NSString*)fileName withData:(NSMutableArray *)data
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    [data writeToFile:finalPath atomically: YES];
    /* This would change the firmware version in the plist to 1.1.1 by initing the NSDictionary with the plist, then changing the value of the string in the key "ProductVersion" to what you specified */
    
    return finalPath;
}

+ (NSMutableArray *) readFromSandboxFile: (NSString *)fileName {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:finalPath];
    
    if (fileExists) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithContentsOfFile:finalPath];
        return arr;
    } else {
        return nil;
    }
}

+(void)saveIntConfig:(NSString *)name value:(NSInteger)value{
   
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
       NSInteger oldValue =  [userDefaults integerForKey:name];
    if(oldValue != value){
          [userDefaults setInteger:value forKey:name ];
             [userDefaults synchronize];
    }
}

+(void)saveObjectConfig:(NSString *)name value:(NSObject *)value{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:value forKey:name ];
    [userDefaults synchronize];
}


//用户自定义
+(void)saveUserObjectConfig:(NSString *)name value:(NSObject *)value{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:value];
    
    [self saveObjectConfig:name value:data];
}

+(void)saveBoolConfig:(NSString *)name value:(BOOL)value{
    NSInteger val = (value)?1:0;
    
    [ self saveIntConfig:name value:val];
    
}
+(BOOL )loadBoolConfig:(NSString *)name{
    NSInteger val = [self loadIntConfig:name];
    return (val == 1) ? YES:NO;
}


+(void)saveStringConfig:(NSString *)name value:(NSString*)value{
    //[PlistUtils saveObjectConfig:name value:value];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * oldVal = [defaults objectForKey:name];
    if((oldVal == nil ) || (![oldVal isEqualToString:value]))
    {
       [defaults setObject:value forKey:name];
       [defaults synchronize];
    }
}
+(NSString* )loadStringConfig:(NSString *)name{
   // return (NSString *)[PlistUtils loadUserObjectConfig:name];
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:name];
}

+(NSString* )loadStringConfig:(NSString *)name defaultValue:(NSString *)defaultValue{
    NSString * value = (NSString *)[PlistUtils loadStringConfig:name];
    if(value == nil)
        return defaultValue;
    else
        return value;
}

+(void)removeObjectConfig:(NSString *)name{
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [ userDefaults removeObjectForKey:name ];
    
}



//用户自定义数据列表

+(void)saveUserObjectArray:(NSString *)name array:(NSArray *)array{
    
    NSMutableArray * archiveArray = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSObject  * userObject in array) {
        NSData * objData = [NSKeyedArchiver archivedDataWithRootObject:userObject];
        [archiveArray addObject:objData];
    }
   
    //[self saveObjectConfig:name value:archiveArray];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:archiveArray forKey:name ];
    [userDefaults synchronize];

}


+(NSObject * )loadUserObjectConfig:(NSString *)name{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData  * data  = [userDefaults objectForKey:name ];
    
   return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}


+(NSMutableArray *)loadUserObjectArray:(NSString *)name {
    
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
     NSArray *  dataArray   = [userDefaults objectForKey:name ];
    
    if(dataArray == nil)
        return nil;
    
     NSMutableArray * objectArray = [NSMutableArray arrayWithCapacity:dataArray.count];
    
    for (NSData  * dataObject in dataArray) {
       
         NSObject * object = [NSKeyedUnarchiver unarchiveObjectWithData:dataObject];
        [objectArray addObject:object];
    }
    
    return objectArray;
    
}


+(NSInteger )loadIntConfig:(NSString *)name defaultValue:(NSInteger)defaultValue{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    if (![userDefaults objectIsForcedForKey:name])
//        return defaultValue;

    NSObject * value = [ userDefaults objectForKey:name];
    if(value == nil)
        return defaultValue;
    
    if([value isKindOfClass:[NSString class]]){
        NSString * strVal = (NSString *)value;
        return [strVal integerValue];
    }
    else if([value isKindOfClass:[NSNumber class]]){
        NSNumber * numVal = (NSString *)value;
        return [numVal integerValue];
    }
    else return defaultValue;
    
    
}


+(NSInteger )loadIntConfig:(NSString *)name {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger value  = [userDefaults integerForKey:name ];
    return value;
}

+(NSObject * )loadObjectConfig:(NSString *)name  defaultValue:(NSObject *)defaultValue{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSObject * value  = [userDefaults objectForKey:name ];
    if(value == nil)
        return defaultValue;
    return value;
}








@end
