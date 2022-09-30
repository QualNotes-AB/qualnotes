import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/map/controllers/add_media_controller.dart';
import 'package:qualnote/app/modules/map/controllers/camera_controller.dart';
import 'package:qualnote/app/modules/map/views/widgets/nav_bar.dart';
import '../controllers/map_controller.dart';

class MapView extends GetView<MapGetxController> {
  const MapView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Get.find<AddMediaController>();
    Get.find<CameraGetxController>();
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => FlutterMap(
              mapController: MapController(),
              options: MapOptions(
                center: controller.currentLocation.value,
                zoom: 16.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.qualnotes.qualnote',
                  maxZoom: 24,
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: controller.routePoints.value,
                      strokeWidth: 8,
                      color: AppColors.lineBlue,
                    )
                  ],
                ),
                MarkerLayer(
                  rotate: true,
                  markers: [
                    Marker(
                      point: controller.currentLocation.value,
                      builder: (context) => const Icon(Icons.navigation),
                    ),
                    ...markers,
                  ],
                ),
              ],
            ),
          ),
          NavBar(),
        ],
      ),
    );
  }

  List<Marker> get markers {
    List<Marker> markers = [];
    markers.addAll(controller.photoNotes
        .map(
          (element) => Marker(
            point: element.cooridnate!,
            height: 200,
            width: 80,
            builder: (context) {
              return Transform.translate(
                offset: const Offset(0, -80),
                child: Column(
                  children: [
                    Image.file(
                      File(element.path!),
                      height: 150,
                    ),
                    const Text(
                      '📷',
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              );
            },
          ),
        )
        .toList());
    markers.addAll(controller.videoNotes
        .map(
          (element) => Marker(
            point: element.cooridnate!,
            builder: (context) {
              return Column(
                children: const [Icon(Icons.videocam)],
              );
            },
          ),
        )
        .toList());
    return markers;
  }
}
