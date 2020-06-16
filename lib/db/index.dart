
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
      }
    );

  }
}
  
 