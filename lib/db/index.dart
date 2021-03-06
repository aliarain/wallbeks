
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wallbeks/models/image_model.dart';

class ImgDB{
  static const  dbName = 'wallbeks.db';
  static const  tableRecent = 'recents';
  static const  tableFavorites = 'favorites';
  static const  tableDownloads = 'downloads';
  static const  createdAtDesc = 'dateTime(createdAt) DESC';
  static const  nameASC= 'name ASC';


  Database _db;
  static ImgDB _instance;

  ImgDB._internal();

  factory ImgDB.getInstance() => _instance ??= ImgDB._internal();
  Future<Database> get db async => _db ??= await open(); 

  Future<Database> open() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, dbName);
    return await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE $tableRecent(
          id TEXT PRIMARY KEY UNIQUE NOT NULL,
          name TEXT NOT NULL,
          imageUrl TEXT NOT NULL,
          thumbnailUrl TEXT NOT NULL,
          categoryId TEXT NOT NULL,
          uploadedTime TEXT NOT NULL,
          viewTime TEXT NOT NULL,
        )''');
        await db.execute('''CREATE TABLE $tableDownloads(
          id TEXT PRIMARY KEY UNIQUE NOT NULL,
          name TEXT NOT NULL,
          imageUrl TEXT NOT NULL,
          createdAt TEXT NOT NULL,
        )''');
        await db.execute('''CREATE TABLE $tableFavorites(
            id TEXT PRIMARY KEY UNIQUE NOT NULL,
            name TEXT NOT NULL,
            imageUrl TEXT NOT NULL,
            thumbnailUrl TEXT NOT NULL,
            categoryId TEXT NOT NULL,
            uploadedTime TEXT NOT NULL,
            createdAt TEXT NOT NULL
          )''');  
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        print('[DEBUG] onUpgrade from $oldVersion to $newVersion');

        if(oldVersion == 1){
          await db.execute('''CREATE TABLE $tableDownloads(
          id TEXT PRIMARY KEY UNIQUE NOT NULL,
          name TEXT NOT NULL,
          imageUrl TEXT NOT NULL,
          createdAt TEXT NOT NULL,
          )''');
        }
      },
    );

  }
  Future<Null> close() async {
    final client = await db;
    await client.close();
  }

  Future<int> insertRecentImage(ImageModel image) async {
    final values = (image..viewTime = DateTime.now()).toJson();
    final dbClient = await db;
    return await dbClient.insert(
    tableRecent,
    values,
    conflictAlgorithm: ConflictAlgorithm.replace 
    );
  }
   Future<int> deleteRecentImageById(String id) async {
    final dbClient = await db;
    return await dbClient.delete(
      tableRecent,
      where: 'id = ?',
      whereArgs: [id]
    );
  }
   Future<int> updateRecentImage(ImageModel image) async {
    final dbClient = await db;
    return await dbClient.update(
    tableRecent,
    image.toJson(),
    where: 'id = ?',
    whereArgs: [image.id],
    conflictAlgorithm: ConflictAlgorithm.replace 
    );
  }
   Future<int> deleteAllRecentImage(String id) async {
    final dbClient = await db;
    return await dbClient.delete(
      tableRecent,
      where: '1'
    );
  }
  
  Future<int> getAllRecentImages({int limit}) async {
    final dbClient = await db;
    final maps = await (
      limit != null ? dbClient.query(
        tableRecent,
        orderBy: 'dateTime(viewTime) DESC',
        limit: limit
      ) : 
      dbClient.query(
        tableRecent,
        orderBy: 'dateTime(viewTime) DESC'
      )
    );

    return maps
        .map((json) => ImageModel.fromJson(id: json['id'], json: json))
        .toList();
  }

  Future<ImageModel> getRecentImageById(String id) async {
    final dbClient = await db;
    final maps = await dbClient.query(
      tableRecent,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return maps.isNotEmpty
        ? ImageModel.fromJson(id: maps.first['id'], json: maps.first)
        : null;
  }

  

  
  

}
  
 