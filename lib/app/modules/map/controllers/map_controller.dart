import 'dart:async';
import 'dart:developer';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:qualnote/app/data/models/photo_note.dart';

class MapGetxController extends GetxController {
  MapController mapController = MapController();
  Location location = Location();
  late StreamSubscription locationStream;
  Rx<LatLng> currentLocation = LatLng(0, 0).obs;
  RxBool isMapping = false.obs;
  RxList<LatLng> routePoints = <LatLng>[].obs;
  RxList<String> textTags = <String>[].obs;
  RxList<PhotoNote> photoNotes = <PhotoNote>[].obs;
  RxList<PhotoNote> videoNotes = <PhotoNote>[].obs;

  Future<LatLng> getCurrentLocation() async {
    Location _location = Location();
    _location.changeSettings(
        accuracy: LocationAccuracy.high, distanceFilter: 10);
    if (await location.hasPermission() == PermissionStatus.granted) {
      LocationData location = await _location.getLocation();
      log('Got location');
      return LatLng(location.latitude ?? 0, location.longitude ?? 0);
    }
    return LatLng(0, 0);
  }

  void startMapping() {
    routePoints.clear();
    isMapping.value = true;
  }

  void stopMapping() {
    isMapping.value = false;
  }

  void resumeMapping() {
    isMapping.value = true;
  }

  void init() {
    locationStream = location.onLocationChanged.asBroadcastStream().listen(
      (LocationData data) {
        var location = LatLng(data.latitude ?? 0, data.longitude ?? 0);
        currentLocation.value = location;

        if (isMapping.value) {
          routePoints.add(location);
          log(location.toString());
        }
      },
    );
  }

  @override
  void onInit() {
    //  currentLocation.value = await getCurrentLocation();
    log('init');
    init();
    super.onInit();
  }

  @override
  void dispose() {
    locationStream.cancel();
    Get.delete<MapGetxController>();
    super.dispose();
  }
}
