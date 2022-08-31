import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qualnotes/pages/editor_screen.dart';
import 'geonote.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
  final geoNote1 = GeoNote(99, "photo", 1, 1, "text...");

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,

      ),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {

  final CameraDescription camera;
  // final GeoNote geoNote;
  // TakePictureScreen({Key? key, required this.camera, required this.geoNote,}) : super(key: key);
  const TakePictureScreen({
    super.key,
    required this.camera,
    //required this.geoNote,
  });

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();

  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            if (!mounted) return;
            Navigator.pop(context, image.path);

            // If the picture was taken, display it on a new screen.
           /* final imgPath = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
            */

          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}





// WILL BE USED TO VIEW THE PHOTONOTE.
// A widget that displays the picture taken by the user.
class EditPhotoGeoNote extends StatelessWidget {
  ///final String imagePath;
  final GeoNote geoNote; // the geonote to edit
  EditPhotoGeoNote({Key? key, required this.geoNote,}) : super(key: key);
  // old const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text(imagePath,maxLines: 6, textScaleFactor: .4, )),
      appBar: AppBar(title: Text( "Edit Photo Note" )),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      //body: Image.file(File(imagePath)),
      body:
          Column(children: <Widget>[
            Center(
              child: Container(
                child: Image.file(File(geoNote.imgPath), height: 350),
              ),
            ),
            Center(
              child: Container(
                child: geoNote.text.isNotEmpty ? Text(geoNote.text)  : const Text('Add Caption'),
              ),
            ),
            Row (children: <Widget>[
                Padding( padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Close the screen and return "Yep!" as the result.
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditorScreen(geoNote: geoNote)),);

                      // call Edit text with id of this note.

                    },
                    child: geoNote.text.isNotEmpty ? Text("Edit Caption")  : const Text('Add Caption'),
                  ),
                ),
                Padding( padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Close the screen and return "Yep!" as the result.
                      geoNote.deleteMe = true;
                      Navigator.pop(context, geoNote);

                    },
                    child: const Text('Delete'),
                  ),
                ),
                Padding( padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Close the screen and return "Yep!" as the result.
                      Navigator.pop(context);
                    },
                    child: const Text('Back'),
                  ),
                ),
                  Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Close the screen and return "Nope." as the result.
                            // go to map Navigator.pop(context, '');
                          },
                          child: const Text('Delete'),
                        ),
                      ),],),
          ],)
    );
  }
}