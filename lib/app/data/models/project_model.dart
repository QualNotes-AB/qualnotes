import 'package:latlong2/latlong.dart';

class Project {
  String? id;
  String? title;
  String? description;
  int? totalTime;
  String? type;
  String? author;
  DateTime? date;
  double? distance;
  List<Note>? notes;
  List<LatLng>? routePoints;
  List<String>? routeVideos;
  List<String>? routeAudios;

  Project({
    required this.id,
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
      routePoints = <LatLng>[];
      json['routePoints'].forEach((v) {
        routePoints?.add(LatLng.fromJson(v));
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

class Note {
  String? title;
  String? description;
  LatLng? coordinate;
  String? path;
  String? author;
  int? duration;
  bool? hasConsent;
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
    coordinate = LatLng.fromJson(json['coordinate']);
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
    data['path'] = path;
    data['author'] = author;
    data['duration'] = duration;
    data['hasConsent'] = hasConsent;
    data['type'] = type;
    return data;
  }
}

enum NoteType { video, audio, photo, other }
