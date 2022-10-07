import 'package:latlong2/latlong.dart';

class Project {
  String? title;
  String? description;
  int? totalTime;
  String? type;
  String? author;
  DateTime? date;
  double? distance;
  List<CameraMedia>? photos;
  List<CameraMedia>? videos;
  List<AudioMedia>? audios;
  List<LatLng>? routePoints;
  List<String>? routeVideos;
  List<String>? routeAudios;

  Project({
    this.title,
    this.description,
    this.totalTime,
    this.type,
    this.author,
    this.date,
    this.distance,
    this.photos,
    this.videos,
    this.audios,
    this.routePoints,
    this.routeVideos,
    this.routeAudios,
  });

  Project.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    totalTime = json['totalTime'];
    type = json['type'];
    author = json['author'];
    date = json['date'];
    distance = json['distance'];
    if (json['photos'] != null) {
      photos = <CameraMedia>[];
      json['photos'].forEach((v) {
        photos?.add(CameraMedia.fromJson(v));
      });
    }
    if (json['videos'] != null) {
      videos = <CameraMedia>[];
      json['videos'].forEach((v) {
        videos?.add(CameraMedia.fromJson(v));
      });
    }
    if (json['audios'] != null) {
      audios = <AudioMedia>[];
      json['audios'].forEach((v) {
        audios?.add(AudioMedia.fromJson(v));
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
    if (photos != null) {
      data['photos'] = photos?.map((v) => v.toJson()).toList();
    }
    if (videos != null) {
      data['videos'] = videos?.map((v) => v.toJson()).toList();
    }
    if (audios != null) {
      data['audios'] = audios?.map((v) => v.toJson()).toList();
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

class CameraMedia {
  String? title;
  String? description;
  LatLng? coordinate;
  String? path;

  CameraMedia({this.title, this.description, this.coordinate, this.path});

  CameraMedia.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    coordinate = LatLng.fromJson(json['coordinate']);
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['coordinate'] = coordinate!.toJson();
    data['path'] = path;
    return data;
  }
}

class AudioMedia {
  String? title;
  String? description;
  LatLng? coordinate;
  String? path;
  String? author;
  int? duration;
  bool? hasConsent;

  AudioMedia(
      {this.title,
      this.description,
      this.coordinate,
      this.path,
      this.author,
      this.duration,
      this.hasConsent});

  AudioMedia.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    coordinate = LatLng.fromJson(json['coordinate']);
    path = json['path'];
    author = json['author'];
    duration = json['duration'];
    hasConsent = json['hasConsent'];
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
    return data;
  }
}

// class RoutePoint {
//   double? latitude;
//   double? longitute;

//   RoutePoint({this.latitude, this.longitute});

//   RoutePoint.fromJson(Map<String, dynamic> json) {
//     latitude = json['latitude'];
//     longitute = json['longitute'];
//   }

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['latitude'] = latitude;
//     data['longitute'] = longitute;
//     return data;
//   }
// }
