import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';

class MapControls extends StatelessWidget {
  const MapControls({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final MapGetxController controller;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: !controller.isPreview.value,
            child: TextButton(
              onPressed: () => controller.recenter(),
              child: const Icon(
                Icons.my_location_rounded,
                color: Colors.black,
              ),
            ),
          ),
          kIsWeb
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () => controller.zoomIn(),
                      child: const Icon(
                        Icons.zoom_in_outlined,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () => controller.zoomOut(),
                      child: const Icon(
                        Icons.zoom_out_outlined,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
