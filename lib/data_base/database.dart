import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:logger/logger.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;
  final logger = Logger();

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'users.db');
    return openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            password TEXT,
            user_type TEXT,
            location TEXT DEFAULT '',
            is_open INTEGER DEFAULT 0,
            exchange_rights INTEGER DEFAULT 0,
            donations INTEGER DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE vendor_items(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            vendor_username TEXT,
            item_name TEXT,
            price REAL,
            description TEXT DEFAULT '',
            image_path TEXT DEFAULT ''
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE users ADD COLUMN location TEXT DEFAULT ""');
          await db.execute('ALTER TABLE users ADD COLUMN is_open INTEGER DEFAULT 0');
          await db.execute('ALTER TABLE users ADD COLUMN exchange_rights INTEGER DEFAULT 0');
          await db.execute('ALTER TABLE users ADD COLUMN donations INTEGER DEFAULT 0');
        }
        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE vendor_items(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              vendor_username TEXT,
              item_name TEXT,
              price REAL,
              description TEXT DEFAULT '',
              image_path TEXT DEFAULT ''
            )
          ''');
        }
      },
    );
  }

  //to delete naaytelha fel main
  /*Future<void> deleteDatabaseFile() async {
    final dbPath = join(await getDatabasesPath(), 'users.db');
    await deleteDatabase(dbPath);
    logger.i("Database file deleted.");
  }*/



  //faza to fix lolkom yjiw fel vendor items
  Future<List<Map<String, dynamic>>> getAllVendors() async {
    final db = await database;
    return await db.query(
      'users',
      where: 'user_type = ?',
      whereArgs: ['vendor'],
    );
  }
  // **Get Vendor Settings**
  Future<Map<String, dynamic>?> getVendorSettings(String username) async {
    final db = await database;
    logger.i("DB Opened Successfully");

    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    logger.i("Query executed: Found \${result.length} results");

    if (result.isNotEmpty) {
      logger.i("User Data: \${result.first}");
      return result.first;
    }

    logger.w("No user found with username: $username");
    return null;
  }

  // **Update Vendor Settings**
  Future<void> updateVendorSettings(
      String username, String location, bool isOpenForBusiness, bool exchangeRights, bool donations) async {
    final db = await database;
    await db.update(
      'users',
      {
        'location': location,
        'is_open': isOpenForBusiness ? 1 : 0,
        'exchange_rights': exchangeRights ? 1 : 0,
        'donations': donations ? 1 : 0,
      },
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  // **Hash Password (No Salt)**
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // **Insert User**
  Future<bool> insertUser(String username, String password, String userType) async {
    final db = await database;
    String hashedPassword = _hashPassword(password);

    try {
      await db.insert(
        'users',
        {
          'username': username,
          'password': hashedPassword,
          'user_type': userType,
          'location': '',
          'is_open': 0,
          'exchange_rights': 0,
          'donations': 0,
        },
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      return true;
    } catch (e) {
      logger.e("Insert failed: $e");
      return false;
    }
  }

  // **Verify User Login**
  Future<String?> getUserType(String username, String password) async {
    final db = await database;

    String hashedPassword = _hashPassword(password);
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, hashedPassword],
    );

    if (result.isNotEmpty) {
      return result.first['user_type'];
    }
    return null;
  }

  // **Vendor Item Functions**
  Future<List<Map<String, dynamic>>> getVendorItems(String vendorUsername) async {
    final db = await database;
    final List<Map<String, dynamic>> items = await db.query(
      'vendor_items',
      where: 'vendor_username = ?',
      whereArgs: [vendorUsername],
    );
    List<Map<String, dynamic>> copy=items.map((item)=>Map<String,dynamic>.from(item)).toList();
    for(int i=0;i<copy.length;i++){
      if (copy[i]["image_path"]==null||copy[i]["image_path"]==""){
        final bytes=await rootBundle.load("./assets/no_image.jpg");
        final buffer=bytes.buffer;
        List<int> listBytes=buffer.asUint8List(bytes.offsetInBytes,bytes.lengthInBytes);
        copy[i]["image_path"]=base64Encode(listBytes);
      }
    }


    return copy;
  }

  Future<int> addVendorItem(String vendorUsername, String itemName, double price, String description, String imagePath) async {
    final db = await database;
    return await db.insert(
      'vendor_items',
      {
        'vendor_username': vendorUsername,
        'item_name': itemName,
        'price': price,
        'description': description,
        'image_path': imagePath,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteVendorItem(int id) async {
    final db = await database;
    await db.delete(
      'vendor_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllVendorItems() async {
    final db = await database;
    await db.delete('vendor_items');
  }

  // **Debug: Print All Users**
  void printUsers() async {
    List<Map<String, dynamic>> users = await getAllUsers();
    logger.i(users);
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }
}
