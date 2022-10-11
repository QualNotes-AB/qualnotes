import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong2/latlong.dart';

part 'coordinate.g.dart';

@HiveType(typeId: 3)
class Coordinate {
  @HiveField(0)
  double? latitude;
  @HiveField(1)
  double? longitude;

  Coordinate({
    this.latitude,
    this.longitude,
  });

  Coordinate.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Coordinate.fromLatLng(LatLng location) {
    latitude = location.latitude;
    longitude = location.longitude;
  }

  LatLng toLatLng() {
    return LatLng(latitude!, longitude!);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
