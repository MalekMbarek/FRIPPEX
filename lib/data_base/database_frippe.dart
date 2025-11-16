import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/frippe.dart';
//import 'dart:developer'; // Pour une meilleure gestion des logs

class DatabaseFrippe {
  static final DatabaseFrippe instance = DatabaseFrippe._init();
  static Database? _database;

  DatabaseFrippe._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('frippes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE frippes (
        id $idType,
        name $textType,
        region $textType
      )
    ''');

    await _insertFixedData(db);
  }

  Future<void> _insertFixedData(Database db) async {
    const frippesData = [
      {'name': 'Marché Manouba', 'region': 'La Manouba'},
      {'name': 'Marché Vendredi Manouba', 'region': 'La Manouba'},









      {'name': 'Marché ennour', 'region': "Tunis"},
      {'name': 'Marché ennour', 'region': "Tunis"},
      {'name': 'Marché test', 'region': "tunis governate"},



      {'name': 'Marché ennour', 'region': "tunis"},
      {'name': 'Marché el 3asafir', 'region': "tunis"},

      {'name': 'Marché Cité Tahrir', "region": "Bardo"},
      {'name': 'Marché Cité Ibn Khaldoun', 'region': 'Bardo'},

      {'name': 'Marché Ariana', 'region': 'ariana governorate'},
      {'name': 'Marché de Sidi Salah', 'region': 'ariana governorate'},
      {'name': 'Frip Kilo Ariana', 'region': "ariana governorate"},
      {'name': 'Marché municipal de Menzah 8', 'region': "ariana governorate"},
      {'name': 'Friperie de luxe Ariana', 'region': "ariana governorate"},
      {'name': 'Marché hebdomadaire de La Soukra', 'region': "ariana governorate"},

      {'name': 'Marché Ariana', 'region': "gouvernorat de l'ariana"},
      {'name': 'Marché de Sidi Salah', 'region': "gouvernorat de l'ariana"},
      {'name': 'Frip Kilo Ariana', 'region': "gouvernorat de l'ariana"},
      {'name': 'Marché municipal de Menzah 8', 'region': "gouvernorat de l'ariana"},
      {'name': 'Friperie de luxe Ariana', 'region': "gouvernorat de l'ariana"},
      {'name': 'Marché hebdomadaire de La Soukra', 'region': "gouvernorat de l'ariana"},


      {'name': 'Marché Ariana', 'region': "ariana governate"},
      {'name': 'Marché de Sidi Salah', 'region': "ariana governate"},
      {'name': 'Marché municipal de Menzah 8', 'region': "ariana governate"},
      {'name': 'Frip Kilo Ariana', 'region': "gouvernorat de l'Ariana"},
      {'name': 'Friperie de luxe Ariana', 'region': "ariana governate"},
      {'name': 'Marché hebdomadaire de La Soukra', 'region': "ariana governate"},

    ];
// nhotouha fi db
    for (var frippe in frippesData) {
      await db.insert(
        'frippes',
        {
          'name': frippe['name'],
          'region': frippe['region']!.trim().toLowerCase(), // region va etre non null ,miniscule et sans extra spaces
        },
        conflictAlgorithm: ConflictAlgorithm.replace, // cas de conflit ??
      );
    }
  }

  Future<List<Frippe>> getFrippesByRegion(String region) async {
    final db = await instance.database;

    String cleanedRegion = region.trim().toLowerCase(); // Uniformiser la casse
    debugPrint("🔍 Recherche des frippes pour la région: '$cleanedRegion'");

    final result = await db.query(
      'frippes',
      where: 'LOWER(region) = ?',
      whereArgs: [cleanedRegion],
    );

    return result.map((json) => Frippe.fromMap(json)).toList();
  }

  Future<List<Frippe>> getAllFrippes() async {
    final db = await instance.database;
    final result = await db.query('frippes');
    return result.map((json) => Frippe.fromMap(json)).toList();
  }
}
