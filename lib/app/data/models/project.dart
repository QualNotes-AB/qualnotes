import 'package:hive_flutter/hive_flutter.dart';
import 'package:qualnote/app/data/models/coordinate.dart';
import 'package:qualnote/app/data/models/note.dart';

part 'project.g.dart';

@HiveType(typeId: 1)
class Project {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? description;
  @HiveField(3)
  int? totalTime;
  @HiveField(4)
  String? type;
  @HiveField(5)
  String? author;
  @HiveField(6)
  DateTime? date;
  @HiveField(7)
  double? distance;
  @HiveField(8)
  List<Note>? notes;
  @HiveField(9)
  List<Coordinate>? routePoints;
  @HiveField(10)
  List<String>? routeVideos;
  @HiveField(11)
  List<String>? routeAudios;

  Project({
    this.id,
    this.title,
    this.description,
    this.totalTime,
    this.type,
    this.author,
    this.date,
    this.distance,
    this.notes,
    this.routePoints,
    this.routeVideos,
    this.routeAudios,
  });

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    totalTime = json['totalTime'];
    type = json['type'];
    author = json['author'];
    date = json['date'];
    distance = json['distance'];

    if (json['notes'] != null) {
      notes = <Note>[];
      json['notes'].forEach((v) {
        notes?.add(Note.fromJson(v));
      });
    }
    if (json['routePoints'] != null) {
      routePoints = <Coordinate>[];
      json['routePoints'].forEach((v) {
        routePoints?.add(Coordinate.fromJson(v));
      });
    }
    if (json['routeVideos'] != null) {
      routeVideos = <String>[];
      json['routeVideos'].forEach((v) {
        routeVideos?.add(v.toString());
      });
    }
    if (json['routeAudios'] != null) {
      routeAudios = <String>[];
      json['routeAudios'].forEach((v) {
        routeAudios?.add(v.toString());
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['totalTime'] = totalTime;
    data['type'] = type;
    data['author'] = author;
    data['date'] = date;
    data['distance'] = distance;

    if (notes != null) {
      data['notes'] = notes?.map((v) => v.toJson()).toList();
    }
    if (routePoints != null) {
      data['routePoints'] = routePoints?.map((v) => v.toJson()).toList();
    }
    if (routeVideos != null) {
      data['routeVideos'] = routeVideos?.map((v) => v).toList();
    }
    if (routeAudios != null) {
      data['routeAudios'] = routeAudios?.map((v) => v).toList();
    }
    return data;
  }
}
