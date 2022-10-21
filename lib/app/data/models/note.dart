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
  String? type;
  @HiveField(7)
  String? fileExtension;
  @HiveField(8)
  String? noteTitle;
  @HiveField(9)
  DateTime? date;

  Note({
    this.title,
    this.description,
    this.coordinate,
    this.path,
    this.author,
    this.duration,
    this.type,
    this.fileExtension,
    this.noteTitle,
    this.date,
  });

  Note.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    if (json['coordinate'] != null) {
      coordinate = Coordinate.fromJson(json['coordinate']);
    }
    path = json['path'];
    author = json['author'];
    duration = json['duration'];
    type = json['type'];
    fileExtension = json['fileExtension'];
    noteTitle = json['noteTitle'];
    if (json['date'] != null) {
      date = DateTime.fromMillisecondsSinceEpoch(
          json['date'].millisecondsSinceEpoch);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    if (coordinate != null) {
      data['coordinate'] = coordinate!.toJson();
    }
    data['noteTitle'] = noteTitle;
    data['author'] = author;
    data['duration'] = duration;
    data['type'] = type;
    data['fileExtension'] = fileExtension;
    data['date'] = date;
    return data;
  }
}
