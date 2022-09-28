import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/map/views/widgets/nav_bar.dart';
import '../controllers/map_controller.dart';

class MapView extends GetView<MapGetxController> {
  const MapView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => FlutterMap(
              mapController: MapController(),
              options: MapOptions(
                center: controller.currentLocation.value,
                zoom: 16.0,

                //  interactiveFlags: interActiveFlags,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  maxZoom: 24,
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: controller.currentLocation.value,
                      builder: (context) => const Icon(Icons.navigation),
                    )
                  ],
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: controller.routePoints.value,
                      strokeWidth: 8,
                      color: AppColors.lineBlue,
                    )
                  ],
                )
              ],
            ),
          ),
          NavBar(),
        ],
      ),
    );
  }

//   List<Marker> getMarkers()async{

// }
}
