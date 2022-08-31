import 'dart:async';
import 'dart:core';
import 'package:flutter/foundation.dart';

import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'geonote.dart';


Future<void> main() async {

  const String table_name = "t_notes";
  Database db =  await getGeoNotesDB();

  debugPrint("db is open = $db.isOpen");

  GeoNote g1 = GeoNote(33333, "2",1,2,"hola");
  db.insert(table_name, g1.toMap3("tuta1"));

  GeoNote g2 = GeoNote(31333, "2",1,2,"hola");
  db.insert(table_name, g2.toMap3("tuta2"));
  var xx = await getMyDistinctRoutes();
  debugPrint(xx.toString());
}


void insertNote(GeoNote x) async {
  final db = await getGeoNotesDB();

  await db.insert(
    't_notes',
    x.toMap3("route1"),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

void insertBatchOfNotes(List<GeoNote> geoNotesList, String myRouteTitle) async {

  // prompt name of the route to be saved.
  final db = await getGeoNotesDB();
  Batch batch =  db.batch();

  for (GeoNote gnote in geoNotesList) {
    batch.insert('t_notes', gnote.toMap3(myRouteTitle),  conflictAlgorithm: ConflictAlgorithm.replace);
  }

  batch.commit();

}

void populateDb(Database database, int version) async {
  await database.execute("CREATE TABLE t_notes ("
      "id INTEGER PRIMARY KEY,"
      "note_index INTEGER,"
      "route_title TEXT,"
      "note_type TEXT,"
      "lat REAL,"
      "lon REAL,"
      "text TEXT,"
      "img_path TEXT"
      ")");
}

Future<Database> getGeoNotesDB() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();

  //   GeoNote(this.id, this.index, this.type,  this.lat, this.lon, this.text, );


  createDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'my_maps15.db');
    debugPrint("db is at  = $dbPath");


    var database = await openDatabase(
        dbPath, version: 1, onCreate: populateDb  );
    return database;
  }

  Database mydb = await createDatabase();

  return mydb;
}

Future<List<GeoNote>> getAllNotesFor(String routeTitle) async {

  String databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, 'my_maps15.db');
  final db = await openDatabase(dbPath);

  var maps = await db.query("t_notes",
      columns: ["note_index", "route_title", "note_type","lat","lon","text","img_path"],
      where: '"route_title" = ?',
      whereArgs: [routeTitle]);

  return List.generate(maps.length, (i) {
    return GeoNote.fromMap3(maps[i]);
  });
}

Future<List<String>> getMyDistinctRoutes() async {
  debugPrint("ori0 ");

  String databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, 'my_maps15.db');
  var db = await openDatabase(dbPath);
  var my_maps = [];
  
  // make a copy
  try {
    debugPrint("ori0A ");

    my_maps = List.from(await db.query('t_notes',
      columns: ["route_title"],
      distinct: true,));
  }
  catch (error) {
    debugPrint("ori1 ");
    debugPrint(error.toString());
    // reset db
    db.close();
    db = await openDatabase(dbPath);
    try {
      my_maps = List.from(await db.query('t_notes',
        columns: ["route_title"],
        distinct: true,));
    }
    catch (error) {
      debugPrint("ori2 ");
      debugPrint(error.toString());
      db.close();
      db = await openDatabase(dbPath);
      db.delete('t_notes');
      populateDb(db, 1);

      my_maps = List.from(await db.query('t_notes',
        columns: ["route_title"],
        distinct: true,));

    }
  }
  // not sure why the db  returns an null! wierd
  my_maps.removeWhere((e) => e == null || e['route_title'] == null);

  List<String> myRoutes = List.generate(my_maps.length, (i) {
    debugPrint(my_maps[i]['route_title']);
    if (my_maps[i]['route_title'] == null) {
      return "empty";
    }else {
      return my_maps[i]['route_title'];}
  });

  debugPrint(myRoutes.toString());

  // return the most recent on top
  return myRoutes.reversed.toList();
}

