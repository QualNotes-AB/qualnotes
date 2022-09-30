import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qualnote/app/data/models/photo_note.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';

class AddMediaController extends GetxController {
  MapGetxController mapGetxController = Get.find<MapGetxController>();
  late List<CameraDescription> cameras;

  Future<void> addPhoto() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    var photoLocation = await mapGetxController.getCurrentLocation();
    if (image != null) {
      var note = PhotoNote(cooridnate: photoLocation, path: image.path);
      mapGetxController.photoNotes.add(note);
    }
  }

  Future<void> addVideo(String videoPath) async {
    var photoLocation = await mapGetxController.getCurrentLocation();
    var note = PhotoNote(cooridnate: photoLocation, path: videoPath);
    mapGetxController.videoNotes.add(note);
  }

  @override
  void onInit() async {
    cameras = await availableCameras();
    super.onInit();
  }
}
