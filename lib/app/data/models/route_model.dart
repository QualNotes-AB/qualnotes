import 'package:latlong2/latlong.dart';

class Route {
  String? title;
  List<LatLng>? coordinates;
  List<String>? tags;

  Route({this.title, this.coordinates, this.tags});

  Route.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['coordinates'] != null) {
      coordinates = <LatLng>[];
      json['coordinates'].forEach((v) {
        coordinates?.add(LatLng(v.latitude, v.longitude));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    if (coordinates != null) {
      data['coordinates'] =
          coordinates?.map((v) => LatLng(v.latitude, v.longitude)).toList();
    }
    data['tags'] = tags;
    return data;
  }
}
