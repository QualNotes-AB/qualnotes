import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualnote/app/data/models/coordinate.dart';
import 'package:qualnote/app/data/models/note.dart';
import 'package:qualnote/app/data/services/local_db.dart';
import 'package:qualnote/app/modules/map/controllers/map_controller.dart';

final dateFormat = DateFormat('yyMMddhhmmss');

class AddMediaController extends GetxController {
  MapGetxController mapGetxController = Get.find<MapGetxController>();
  HiveDb localDB = Get.find<HiveDb>();

  Future<void> addNote({required Note newNote}) async {
    var location = await mapGetxController.getCurrentLocation();
    var note = Note(
      title: newNote.title ?? 'Note${dateFormat.format(DateTime.now())}',
      description: newNote.description,
      coordinate: Coordinate.fromLatLng(location),
      path: newNote.path!,
      author: FirebaseAuth.instance.currentUser!.displayName!,
      hasConsent: true,
      duration: newNote.duration,
      type: newNote.type!,
    );
    mapGetxController.notes.add(note);
    mapGetxController.triggerRebuild();
  }

  void updateNote(String title, String description, int duration) {
    mapGetxController.notes
        .firstWhere((note) => note.title == title)
        .description = description;
    mapGetxController.notes.firstWhere((note) => note.title == title).duration =
        duration;
  }
}
