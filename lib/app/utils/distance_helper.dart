import 'dart:developer';
import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

double calculateRouteDistance(List<LatLng> routePoints) {
  double distance = 0;
  for (int i = 0; i < routePoints.length - 1; i++) {
    var firstPoint = routePoints[i];
    var secondPoint = routePoints[i + 1];
    var pointToPoint = math.sqrt(
        math.pow((secondPoint.latitude - firstPoint.latitude), 2) +
            math.pow((secondPoint.longitude - firstPoint.longitude), 2));
    distance += pointToPoint;
  }
  log(distance.toString());
  return distance * 110.57;
}

String getDistanceAsString(double distance) {
  if (distance < 1) {
    return '${(distance * 1000).floor()} meters';
  }
  return '${distance.floor()} km ${(distance * 1000).floor()} meters';
}

String convertLocation(LatLng location) {
  return '${location.latitude.toPrecision(3)}, ${location.longitude.toPrecision(3)}';
}
