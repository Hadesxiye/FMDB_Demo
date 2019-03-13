//
//  ViewController.m
//  FMDBDemo
//
//  Created by 王浩祯 on 2019/3/12.
//  Copyright © 2019 Hades. All rights reserved.
//

#import "ViewController.h"
#import <FMDB.h>

@interface ViewController ()
{
    FMDatabase* _fmdbObj;//FMDB对象
    NSString* _sqlitePath;//数据库的沙盒地址
    NSInteger _insertTimes;
}
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)createFMDB{
    
    //1.获取数据库文件更目录的沙盒地址
    _sqlitePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"沙盒地址 ：%@",_sqlitePath);
    
    //  根据数据库名字，设置数据库的完整路径
    NSString* dbName = [_sqlitePath stringByAppendingPathComponent:@"FMDBDemo.sqlite"];
    
    //2.根据路径创建数据库
    _fmdbObj = [FMDatabase databaseWithPath:dbName];
    //  打开数据库
    if ([_fmdbObj open]) {
        NSLog(@"数据库打开成功");
    }
    else{
        NSLog(@"数据库打开失败");
    }
    
}

- (void)createTable{
    //3.创建表
    BOOL result = [_fmdbObj executeUpdate:@"CREATE TABLE IF NOT EXISTS t_FMDB_Demo (id integer PRIMARY KEY AUTOINCREMENT, number text NOT NULL, string integer NOT NULL);"];
    if (result) {
        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建表失败");
    }
}

- (BOOL)insertValueOne{
    _insertTimes ++;
    NSString* string = [NSString stringWithFormat:@"插入了%ld次😏 方式1",_insertTimes];
    //插入操作
    //1.executeUpdate:不确定的参数用？来占位（后面参数必须是oc对象，；代表语句结束）
    BOOL insertResult = [_fmdbObj executeUpdate:@"INSERT INTO t_FMDB_Demo (number,string) VALUES (?,?)",@(_insertTimes),string];
    
    return insertResult;
}

- (BOOL)insertValueTwo{
    _insertTimes ++;
    NSString* string = [NSString stringWithFormat:@"插入了%ld次😏 方式2",_insertTimes];
    //2.executeUpdateWithForamat：不确定的参数用%@，%d等来占位 （参数为原始数据类型，执行语句不区分大小写）
    BOOL insertResult = [_fmdbObj executeUpdateWithFormat:@"insert into t_FMDB_Demo (number,string) values (%d,%@)",_insertTimes,string];
    return insertResult;
}

- (BOOL)insertValueThree{
    _insertTimes ++;
    NSString* string = [NSString stringWithFormat:@"插入了%ld次😏 方式3",_insertTimes];
    //3.参数是数组的使用方式
    BOOL insertResult = [_fmdbObj executeUpdate:@"INSERT INTO t_FMDB_Demo (number,string) VALUES  (?,?);" withArgumentsInArray:@[@(_insertTimes),string]];
    return insertResult;
}

- (BOOL)deleteValueWithID{
    //1.不确定的参数用？来占位 （后面参数必须是oc对象,需要将int包装成OC对象）
    BOOL result = [_fmdbObj executeUpdate:@"delete from t_FMDB_Demo where id = ?",@(_insertTimes)];
    return result;
}

- (BOOL)deleteValueWithNumber{
    //2.不确定的参数用%@，%d等来占位
    BOOL result = [_fmdbObj executeUpdateWithFormat:@"delete from t_FMDB_Demo where number = %d",_insertTimes];
    return result;
}

- (BOOL)updateValueWithNumber{
    BOOL result = [_fmdbObj executeUpdate:@"update t_FMDB_Demo set string = ? where number = ?",@"修改啦",@(_insertTimes)];
    return result;
}

- (BOOL)updateValueWithID{
    NSString *sql = [NSString stringWithFormat:@"update t_FMDB_Demo set number = ?, string = ? where id = ?"];
    BOOL result = [_fmdbObj executeUpdate:sql withArgumentsInArray:@[@(111), @"全部修改", @(_insertTimes)]];
    return result;
}

- (FMResultSet *)selectValueTotal{
    //查询整个表
    FMResultSet * resultSet = [_fmdbObj executeQuery:@"select * from t_FMDB_Demo"];
    return resultSet;
}

- (FMResultSet *)selectWithNumber{
    //根据条件查询
    FMResultSet * resultSet = [_fmdbObj executeQuery:@"select * from t_FMDB_Demo where id < ?", @(4)];
    return resultSet;
}

- (BOOL)deleteTable{
    //删除表
    BOOL result = [_fmdbObj executeUpdate:@"drop table if exists t_FMDB_Demo"];
    return result;
}



- (IBAction)btnOneClick:(id)sender {
    [self createFMDB];
}

- (IBAction)btnTwoClick:(id)sender {
    [self createTable];
}

- (IBAction)btnInsertOne:(id)sender {
    if ([self insertValueOne]) {
        NSLog(@"方式一插入数据成功");
    }
    else{
        NSLog(@"方式一插入数据失败");
    }
}

- (IBAction)btnInsertTwo:(id)sender {
    if ([self insertValueTwo]) {
        NSLog(@"方式二插入数据成功");
    }
    else{
        NSLog(@"方式二插入数据失败");
    }
}

- (IBAction)btnInsertThree:(id)sender {
    if ([self insertValueThree]) {
        NSLog(@"方式三插入数据成功");
    }
    else{
        NSLog(@"方式三插入数据失败");
    }
}

- (IBAction)btnDeleteOne:(id)sender {
    if ([self deleteValueWithID]) {
        _insertTimes--;
        NSLog(@"根据ID删除数据成功");
    }
    else{
        NSLog(@"根据ID删除数据失败");
    }
}

- (IBAction)btnDeleteTwo:(id)sender {
    if ([self deleteValueWithNumber]) {
        _insertTimes--;
        NSLog(@"根据Number删除数据成功");
    }
    else{
        NSLog(@"根据Number删除数据失败");
    }
}

- (IBAction)btnUpdateClick:(id)sender {
    if ([self updateValueWithNumber]) {
        NSLog(@"根据number 数据修改成功");
    }
    else{
        NSLog(@"根据number 数据修改失败");
    }
}

- (IBAction)btnUpdateClickTwo:(id)sender {
    if ([self updateValueWithID]) {
        NSLog(@"根据id 数据修改成功");
    }
    else{
        NSLog(@"根据id 数据修改失败");
    }
}

- (IBAction)btnSelectOne:(id)sender {
    FMResultSet* resultSet = [self selectValueTotal];
    while ([resultSet next]) {
        int idNum = [resultSet intForColumn:@"id"];
        NSString* number = [resultSet objectForColumn:@"number"];
        NSString* string = [resultSet objectForColumn:@"string"];
        [self addText:[NSString stringWithFormat:@"id: %d number %@ string %@",idNum,number,string]];
    }
}

- (IBAction)btnSelectTwo:(id)sender {
    FMResultSet* resultSet = [self selectWithNumber];
    while ([resultSet next]) {
        int idNum = [resultSet intForColumn:@"id"];
        NSString* number = [resultSet objectForColumn:@"number"];
        NSString* string = [resultSet objectForColumn:@"string"];
        [self addText:[NSString stringWithFormat:@"id: %d number %@ string %@",idNum,number,string]];
    }
}

- (void)addText:(NSString *)str{
    NSString* saveStr = _textView.text;
    _textView.text = [NSString stringWithFormat:@"%@\n%@",saveStr,str];
}

- (IBAction)btnDeleteClick:(id)sender {
    if ([self deleteTable]) {
        NSLog(@"删除表成功");
    }
    else{
        NSLog(@"删除表失败");
    }
}













- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


@end
