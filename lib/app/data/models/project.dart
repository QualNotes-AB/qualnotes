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
  @HiveField(12)
  List<String>? consents;
  @HiveField(13)
  int? routeVideosLength;
  @HiveField(14)
  int? routeAudiosLength;
  @HiveField(15)
  int? consentsLength;
  @HiveField(16)
  List<String>? collaborators;
  @HiveField(17)
  List<Note>? reflectionNotes;
  @HiveField(18)
  String? authorId;
  @HiveField(19)
  bool? isUploaded;

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
    this.consents,
    this.routeVideosLength,
    this.routeAudiosLength,
    this.consentsLength,
    this.collaborators,
    this.reflectionNotes,
    this.authorId,
    this.isUploaded = false,
  });

  Project.fromJson(Map<String, dynamic> json, String docId) {
    id = docId;
    authorId = json['authorId'];
    title = json['title'];
    description = json['description'];
    totalTime = json['totalTime'];
    type = json['type'];
    author = json['author'];
    date = DateTime.fromMillisecondsSinceEpoch(
        json['date'].millisecondsSinceEpoch);
    distance = json['distance'];
    routeVideosLength = json['routeVideosLength'];
    routeAudiosLength = json['routeAudiosLength'];
    consentsLength = json['consentsLength'];
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
    if (json['collaborators'] != null) {
      collaborators = <String>[];
      json['collaborators'].forEach((v) {
        collaborators?.add(v.toString());
      });
    }
    if (json['reflectionNotes'] != null) {
      reflectionNotes = <Note>[];
      json['reflectionNotes'].forEach((v) {
        reflectionNotes?.add(Note.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['authorId'] = authorId;
    data['title'] = title;
    data['description'] = description;
    data['totalTime'] = totalTime;
    data['type'] = type;
    data['author'] = author;
    data['date'] = date;
    data['distance'] = distance;
    data['routeVideosLength'] = routeVideosLength;
    data['routeAudiosLength'] = routeAudiosLength;
    data['consentsLength'] = consentsLength;

    if (notes != null) {
      data['notes'] = notes?.map((v) => v.toJson()).toList();
    }
    if (routePoints != null) {
      data['routePoints'] = routePoints?.map((v) => v.toJson()).toList();
    }
    if (collaborators != null) {
      data['collaborators'] = collaborators?.map((v) => v).toList();
    }
    if (reflectionNotes != null) {
      data['reflectionNotes'] =
          reflectionNotes?.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  operator ==(other) => other is Project && other.id == id;

  @override
  int get hashCode => Object.hash(Project, id);
}
