//
//  ViewController.m
//  练习FMDB
//
//  Created by TXHT on 16/8/5.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#define TableName @"QiHaoInFo"
#define title @"title"
#define detaile @"detaile"
#define numberID @"numberID"
#define type_biao @"type_biao"
#define ID @"ID"


#import "ViewController.h"
#import "fmdb/FMDB.h"
@interface ViewController ()

{
    NSString *database_path;
    FMDatabase *db;
}

@property (weak, nonatomic) IBOutlet UITextField *TF;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doccuments = [paths firstObject];
    database_path = [doccuments stringByAppendingPathComponent:@"haohao.sqlite"];
    db = [FMDatabase databaseWithPath:database_path];
    NSLog(@"%@",database_path);

}


//FMDB存数据
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //创建表
    if ([db open]) {
        NSString *sqlitCreatTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT,'%@' TEXT, '%@' TEXT, '%@' TEXT,'%@' TEXT)",ID,TableName,title,detaile,numberID,type_biao];
        BOOL res = [db executeUpdate:sqlitCreatTable];
        if (!res) {
            NSLog(@"出错");
        }else{
            NSLog(@"创建数据库成功");
        }
        [db close];
    }
    
    //添加数据
    if ([db open]) {
        NSString *insterSqlite2 = [NSString stringWithFormat:@"INSERT INTO '%@'('%@','%@','%@','%@') VALUES ('%@','%@','%@','%@')",TableName,title,detaile,numberID,type_biao,@"天下汇通444标",@"天下汇通444标天下汇通444标",@"122399888",@"流转"];
        
        BOOL res2 = [db executeUpdate:insterSqlite2];
        if (!res2) {
            NSLog(@"失败");
        }else{
            NSLog(@"成功插入");
        }
    }

    //取数据
    if ([db open]) {
        NSString *sqliteStr = [NSString stringWithFormat:@"SELECT * FROM %@",TableName];
        FMResultSet *rs = [db executeQuery:sqliteStr];
        while ([rs next]) {
            NSString *titlename = [rs stringForColumn:title];
            NSString *detailename = [rs stringForColumn:detaile];
            NSString *numberId = [rs stringForColumn:numberID];
            NSString *type = [rs stringForColumn:type_biao];

            NSLog(@"titlename=%@ detailename=%@  numberId=%@ type= %@" ,titlename,detailename,numberId,type);
        }
        [db close];
    }

}


- (IBAction)FMDBSaveDic:(id)sender {
    
    
    //1.创建表
    if ([db open]) {
        
        NSString *sqlitStr1 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%s'('%@' INTEGER PRIMARY KEY AUTOINCREMENT,'%@' TEXT)","dicInfor",@"DIs",@"myDic"];
        BOOL res = [db executeUpdate:sqlitStr1];
        if (!res) {
            NSLog(@"创建错误");
        }else{
            NSLog(@"创建表成功");
        }
    }
    
    NSDictionary *per = @{@"name":@"qihao",@"age":@"123"};
    NSError *err = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:per options:NSJSONWritingPrettyPrinted error:&err];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    //2.插入数据
    if ([db open]) {
    NSString *insterSqlite2 = [NSString stringWithFormat:@"INSERT INTO '%@'('%@') VALUES ('%@')",@"dicInfor",@"myDic",jsonStr];
        BOOL res2 = [db executeUpdate:insterSqlite2];
        if (!res2) {
            NSLog(@"插入错误");
        }else{
            NSLog(@"插入成功");
        }
    }
    
    
    //3.查询
    if ([db open]) {
        NSString *sqlit3 = [NSString stringWithFormat:@"SELECT * FROM %@",@"dicInfor"];
        FMResultSet *rs = [db executeQuery:sqlit3];
        while ([rs next]) {
            NSString *dic = [rs stringForColumn:@"myDic"];

            NSData *resData = [[NSData alloc] initWithData:[dic dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
            
            NSLog(@"查询=%@",resultDic);
        }
    }
}












@end
