import 'package:hive_flutter/hive_flutter.dart';
import 'package:qualnote/app/data/models/coordinate.dart';

part 'note.g.dart';

@HiveType(typeId: 2)
class Note {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? description;
  @HiveField(2)
  Coordinate? coordinate;
  @HiveField(3)
  String? path;
  @HiveField(4)
  String? author;
  @HiveField(5)
  int? duration;
  @HiveField(6)
  bool? hasConsent;
  @HiveField(7)
  String? type;

  Note({
    this.title,
    this.description,
    this.coordinate,
    this.path,
    this.author,
    this.duration,
    this.hasConsent,
    this.type,
  });

  Note.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    coordinate = Coordinate.fromJson(json['coordinate']);
    path = json['path'];
    author = json['author'];
    duration = json['duration'];
    hasConsent = json['hasConsent'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['coordinate'] = coordinate!.toJson();
    //data['path'] = path;
    data['author'] = author;
    data['duration'] = duration;
    data['hasConsent'] = hasConsent;
    data['type'] = type;
    return data;
  }
}
