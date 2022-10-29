import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sql.dart';

class DBhelper{

  static const dynamic dbName = "iust.db";
  static const dynamic table ='iust_fav';
  static const dynamic tableSeen ='iust_seen';
  static const dynamic tableEvents='iust_events';
  static const dynamic tableStory='Story';


  ///create connection for table 1 favroute/
  static Future<sql.Database> database() async {
    final sqlPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(sqlPath,dbName),onCreate: (db, version){
            db.execute('Create Table $table (id TEXT,title TEXT,url TEXT,date TEXT,new TEXT,link TEXT)');
            db.execute('Create Table $tableEvents (date TEXT,link TEXT,title Text)');
            db.execute('Create Table $tableStory (id)');
    },version: 3,onUpgrade: (db,int oldVersion, int newVersion){
            db.execute('Create Table $tableEvents (date TEXT,link TEXT,title Text)');
            db.execute('Create Table $tableStory (id)');
    });
  }
  
  static Future<int> insert(Map<String,dynamic> data) async {
    final con = await DBhelper.database();
    return await con.insert(table, data,conflictAlgorithm: ConflictAlgorithm.replace);
  }


  static Future<List<Map<String,dynamic>>> getData() async {
    final con = await DBhelper.database();
    return await con.query(table);
  }

  static Future<int> deleteData({required String id}) async {
    final con = await DBhelper.database();
    return await con.delete(table,where:'id=?',whereArgs:[id]);
  }

  static Future<dynamic> selectByid({required int id}) async {
    final con = await DBhelper.database();
    final data = await con.rawQuery('SELECT id FROM $table Where id=$id');
    return data.first.values.elementAt(0);
  }

 ///seen table///
  static Future<sql.Database> database2() async {
    final sqlPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(sqlPath,'iustdbsec'),onCreate: (db, version){
      return db.execute('Create Table $tableSeen (id TEXT)');
    },version: 1);
  }

  static Future<int> insertSeen(Map<String,dynamic> data) async {
    final con = await DBhelper.database2();
    return await con.insert(tableSeen,data,conflictAlgorithm: ConflictAlgorithm.replace);
  }
  
  static Future<dynamic> seen({required id}) async {
    final con = await DBhelper.database2();
    final data = await con.rawQuery('SELECT id FROM $tableSeen Where id=$id');
    return data.first.values.elementAt(0);
  }

  ///events//
  static Future<int> insertEvents(Map<String,dynamic> data) async {
    final con = await DBhelper.database();
    return await con.insert(tableEvents, data,conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String,dynamic>>> getEvents() async {
    final con = await DBhelper.database();
    return await con.rawQuery("Select * from $tableEvents");
  }

  static Future<int> deleteEvents() async {
    final con = await DBhelper.database();
    return await con.delete(tableEvents);
  }

  ///Story
  static Future<int> insertStory(Map<String,dynamic> data) async {
    final con = await DBhelper.database();
    return await con.insert(tableStory, data,conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<dynamic> storySlectByid({required String id}) async {
    final con = await DBhelper.database();
    final data = await con.rawQuery('SELECT id FROM $tableStory Where id="$id"');
    return data.first.values.elementAt(0);
  }

  static Future<int> deleteStory() async {
    final con = await DBhelper.database();
    return await con.delete(tableStory);
  }
}