
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:sqflite/sqflite.dart';
import '../widgets/drawer.dart';
import 'audio_recorder.dart';
import 'package:camera/camera.dart';
import 'camera_utils.dart';
import 'editor_screen.dart';
import 'geonote.dart';
import 'db_utils.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'map_list.dart';

import 'package:firebase_auth/firebase_auth.dart';
// import '../test_login_page.dart';

import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'dart:convert';

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  debugPrint("hola inside 1" );
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  debugPrint("hola inside 2");
  debugPrint ( googleUser?.email.toString());


  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  debugPrint("hola inside 3");

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );
  debugPrint("hola inside 4 " + googleAuth!.accessToken.toString() + "   "
      + googleAuth.idToken.toString());

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class LiveLocationPage extends StatefulWidget {

  static const String route = '/live_location';

  const LiveLocationPage({Key? key}) : super(key: key);

  @override
  _LiveLocationPageState createState() => _LiveLocationPageState();
}

class _LiveLocationPageState extends State<LiveLocationPage>  with TickerProviderStateMixin {

  UserCredential? _uc;
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    debugPrint("hola inside 1" );
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    debugPrint("hola inside 2");
    debugPrint ( googleUser?.email.toString());
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    debugPrint("hola inside 3");
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    debugPrint("hola inside 4 " + googleAuth!.accessToken.toString() + "   "
        + googleAuth.idToken.toString());
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> _handleSignIn() async {
    try {
      debugPrint("hola 1 before signInWithGoogle");
      _uc = await signInWithGoogle(); // to get firebase credentials.
      debugPrint("hola 2 aft signInWithGoogle email is ... " + _uc!.user!.email.toString());
      setState( () {
        _username = _uc!.user!.email.toString().split("@")[0]; // use first part of email as username atm...
        if (_username.isEmpty ) {_username = "username00000";}
      });

    } catch (error) {
      print(error);
    }
  }

  String _username = "not set user";
  int _index_to_show = 0; // used in playMode only
  bool playMode = false;
  int _selectedIndex = 0;
  // what type of note create menu pop up

  Future<void> _showActionSheet(BuildContext context) async {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) =>
          CupertinoActionSheet(
            title: const Text('What do we add?'),
            message: const Text('choose one'),
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  _createGeoNote(context);
                },
                child: const Text('text'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('document'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  _createAudioNote(context);
                },
                child: const Text('audio'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  _createPhotoGeoNote(context);
                  // Navigator.pop(context);
                },
                child: const Text('photo'),
              ),
              CupertinoActionSheetAction(

                /// This parameter indicates the action would perform
                /// a destructive action such as delete or exit and turns
                /// the action's text color to red.
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('cancel'),
              )
            ],
          ),
    );
  }
  String _myRouteTitle = "";
  List<GeoNote> myGeoNotes = [];
  List<LatLng> _myRoutePoint = [];
  LocationData? _currentLocation;
  late final MapController _mapController;
  bool _liveUpdate = true;
  bool _paused = false;
  bool _permission = false;
  String? _serviceError = '';
  var interActiveFlags =   InteractiveFlag.pinchZoom | InteractiveFlag.doubleTapZoom;
  final Location _locationService = Location();

  Future<void> _onItemTapped(int index) async {

    setState(() {_selectedIndex = index;});

    if (_selectedIndex == 1) {
      setState(() {
          playMode = !playMode;
      });
      if (playMode) {
        setState(() {
          _liveUpdate =  false;
        });
        var bounds = LatLngBounds.fromPoints([myGeoNotes.first.getLatLon(),myGeoNotes.last.getLatLon()]);
        _animatedMapMove(_mapController.centerZoomFitBounds(bounds).center, _mapController.centerZoomFitBounds(bounds).zoom );
      }
    }

    if (playMode) {
      if (_selectedIndex == 4 ) {  setState(() { playMode = !playMode;  });}

      if (_selectedIndex == 2 ) {
        setState(() {_index_to_show = 0;});
        if (myGeoNotes.length > 2 ) {
          var bounds = LatLngBounds.fromPoints([myGeoNotes[_index_to_show].getLatLon(), myGeoNotes[_index_to_show + 1 ].getLatLon()]);
          _animatedMapMove(myGeoNotes[_index_to_show].getLatLon(), _mapController.centerZoomFitBounds(bounds).zoom);
        }
      }
      if (_selectedIndex == 3) {
        setState(() {
          _liveUpdate = false;
          if (_index_to_show < myGeoNotes.length - 1 ) {
            _index_to_show = _index_to_show + 1;
          }
        });
        var bounds = LatLngBounds.fromPoints([myGeoNotes[_index_to_show].getLatLon(), myGeoNotes[_index_to_show - 1 ].getLatLon()]);
        _animatedMapMove(myGeoNotes[_index_to_show].getLatLon(),  _mapController.centerZoomFitBounds(bounds).zoom);
        debugPrint(bounds.toString());

      }
      if (_selectedIndex == 0) {
        setState(() {
          _liveUpdate = false;
          if (_index_to_show > 0 ) {
            _index_to_show =   _index_to_show - 1 ;
          }
        });

        var bounds = LatLngBounds.fromPoints([myGeoNotes[_index_to_show].getLatLon(), myGeoNotes[_index_to_show + 1 ].getLatLon()]);
        _animatedMapMove(myGeoNotes[_index_to_show].getLatLon(), _mapController.centerZoomFitBounds(bounds).zoom );
      }

    } else {
        if ( (_selectedIndex == 4 || _selectedIndex == 3) ) {
            if (!kIsWeb && _selectedIndex == 3) {
              // debugPrint(_myRouteTitle);
              _myRouteTitle = await _getRouteTitleForSaving(context);
              Future<Database> db = getGeoNotesDB();
              debugPrint("db is open = $db.isOpen");
              insertBatchOfNotes(myGeoNotes, _myRouteTitle);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Saving your map as $_myRouteTitle'),
              ));
            }

            if (!kIsWeb ) {
              // TODO if kisWeb load assets of a route from the store json.
              List<String> myMaps = await getMyDistinctRoutes();
              myMaps.insert(0, "Create New");
              final selection = await Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) =>
                        MyListOfMaps(myMaps: myMaps, username: _username,)),);

              if (selection != "no changes") {
                debugPrint("selected route map is $selection");
                if (selection == "Create new") {
                  _myRouteTitle = "";
                  myGeoNotes = [];
                  _myRoutePoint = [];
                }
                else {
                  _myRouteTitle = selection;
                  final newGeoNotes = await getAllNotesFor(_myRouteTitle);
                  myGeoNotes = [];
                  myGeoNotes.addAll(newGeoNotes);
                  _myRoutePoint = [];
                  _myRoutePoint.addAll(List.generate(myGeoNotes.length, (i) {
                    return myGeoNotes[i].getLatLon();
                  }));
                }
              } // yes changes
            }
        }
          if (_selectedIndex == 2 && !_paused) {
          _showActionSheet(context);
        }
        if (_selectedIndex == 0) {
          _paused = !_paused;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: _paused
                ? const Text('Now paused, not updating route')
                : const Text('Now recording, you can add notes'),
          ));
          setState(() {});
        }
    }
  } // on item tapped

  @override
  void initState() {
    super.initState();

    _handleSignIn();
    _mapController = MapController();
    initLocationService();
  }

  void initLocationService() async {

      if (_permission) {
        await _locationService.changeSettings(
          accuracy: LocationAccuracy.high, interval: 1000,);
      }
      //debugPrint("here");
      LocationData? location;
      bool serviceEnabled;
      bool serviceRequestResult;

      try {
        serviceEnabled = await _locationService.serviceEnabled();
        //debugPrint("here1");
        if (serviceEnabled) {
          final permission = await _locationService.requestPermission();
          //debugPrint("here2");
          setState(() {
            _permission = permission == PermissionStatus.granted;
            //debugPrint("here3");
          });

          if (_permission) {
            location = await _locationService.getLocation();
            _currentLocation = location;
            _locationService.onLocationChanged
                .listen((LocationData result) async {
              if (mounted) {
                setState(() {
                  _currentLocation = result;
                  //debugPrint( _myRoutePoint.toString());
                  // If Live Update is enabled, move map center
                  if (!_paused) {
                    _myRoutePoint.add(LatLng(_currentLocation!.latitude!,
                        _currentLocation!.longitude!));
                    if (_liveUpdate) {
                      //_mapController.move(LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!), _mapController.zoom);
                      _animatedMapMove( LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!), _mapController.zoom );

                    }
                  }
                }); //setstate
              }
            });
          }
        } else {
          serviceRequestResult = await _locationService.requestService();
          if (serviceRequestResult) {
            initLocationService();
            return;
          }
        }
      } on PlatformException catch (e) {
        debugPrint(e.toString());
        if (e.code == 'PERMISSION_DENIED') {
          _serviceError = e.message;
        } else if (e.code == 'SERVICE_STATUS_ERROR') {
          _serviceError = e.message;
        }
        location = null;
      }
  }

  @override
  Widget build(BuildContext context) {

    LatLng currentLatLng;

    // Until currentLocation is initially updated, Widget can locate to 0, 0
    // by default or store previous location value to show.
    if (_currentLocation != null) {
      currentLatLng =
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
    } else {
      currentLatLng = LatLng(42, 2.3);
    }

    var markers = <Marker>[
      Marker(
        width: 80.0,
        height: 80.0,
        point: currentLatLng,
        // anchorPos: AnchorAlign.top as AnchorPos,
        builder: (ctx) =>
        const Icon(
          Icons.circle_rounded,
          //Icons.boy
          //Icons.location_pin,
          color: Colors.blueAccent,
          size: 25.0,
        ),
      ),
    ];

    markers.addAll(_buildMarkersList(myGeoNotes));

    return Scaffold(
      appBar: AppBar(title: Text(_myRouteTitle.isEmpty ? "start mapping":_myRouteTitle) ),
      drawer: buildDrawer(context, LiveLocationPage.route),
      body:
      // IndexedStack(index: _selectedIndex,),
      Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            Flexible(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center:
                  LatLng(currentLatLng.latitude, currentLatLng.longitude),
                  zoom: 16.0,
                  interactiveFlags: interActiveFlags,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                    userAgentPackageName: 'dev.leaflet.flutter_map.example',
                  ),
                  PolylineLayerOptions(
                    polylines: [
                      Polyline(
                        points: _myRoutePoint,
                        strokeWidth: 4.0,
                        color: Colors.blue.withOpacity(0.7),),
                    ],
                  ),
                  MarkerLayerOptions(markers: markers)
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Builder(builder: (BuildContext context) {
        return myBottomNavigationBar();
      }),

      floatingActionButton: Builder(builder: (BuildContext context) {
        return FloatingActionButton(
          backgroundColor: Colors.black26,
          elevation: 0,
          onPressed: () {
            setState(() {
              _liveUpdate = !_liveUpdate;

              if (_liveUpdate) {
                interActiveFlags = // InteractiveFlag.rotate |
                InteractiveFlag.pinchZoom |
                InteractiveFlag.doubleTapZoom;

                //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //  content: Text(
                //      'Track Location, (only zoom is enabled)'),
                //));
              } else {

                interActiveFlags = InteractiveFlag.pinchZoom |
                InteractiveFlag.doubleTapZoom|
                InteractiveFlag.drag |
                InteractiveFlag.pinchMove;
              }
            });
          },
          child: _liveUpdate
              ? const Icon(Icons.navigation_rounded )
              : const Icon(Icons.location_disabled_outlined),
        );
      }),
    );
  }

  Widget myBottomNavigationBar() {
    if (playMode) {
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: Colors.black,
        items: <BottomNavigationBarItem>[

          const BottomNavigationBarItem(
            icon: Icon(Icons.chevron_left),
            label: 'prev',
            backgroundColor: Colors.black,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'edit',
            backgroundColor: Colors.black,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.not_started_outlined),
            label: 'next',
            backgroundColor: Colors.black,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chevron_right),
            label: 'start',

          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined),
            label: 'my Maps',

          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white70,
        unselectedItemColor: Colors.white70,
        onTap: _onItemTapped,
      );
    } else {
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: !_paused ? const Icon(Icons.local_cafe_rounded) : const Icon(
                Icons.fiber_manual_record_rounded, color: Colors.redAccent),
            label: !_paused ? 'pause' : 'resume',

          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'preview',
            backgroundColor: Colors.black,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outlined),
            label: 'Add',
            backgroundColor: Colors.black,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.save_alt_outlined),
            label: 'save',

          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined),
            label: 'my Maps',

          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white70,
        unselectedItemColor: Colors.white70,
        onTap: _onItemTapped,
      );
    }
  }

  // geo note functions
  void _delete (GeoNote geoNote){
    myGeoNotes.removeWhere((item) => item.note_index == geoNote.note_index );

  }
  // move these two to GeoNote use as static method but what about context?
  Future<void> _editGeoNote(BuildContext context, GeoNote oldNote) async {
    GeoNote updatedGeoNote;
    switch(oldNote.note_type) {
      case 'photo':
        updatedGeoNote = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditPhotoGeoNote(geoNote: oldNote)),);
        break;
      case 'text':
        updatedGeoNote = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditorScreen(geoNote: oldNote)),);
        break;

      case 'audio':
        updatedGeoNote = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditorScreen(geoNote: oldNote)),);
        break;

      default: //same as text
        updatedGeoNote = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditorScreen(geoNote: oldNote)),);

        break;
    }
    myGeoNotes[oldNote.note_index]  = updatedGeoNote;
    if (updatedGeoNote.deleteMe) {_delete(updatedGeoNote); }; // delete case

    //debugPrint(" xxx edited geo note $oldNote.id as $updatedGeoNote.toString()" );

  }

  Future<String> _getRouteTitleForSaving(BuildContext context) async {
    final String myRouteTitle = await Navigator.push(context, MaterialPageRoute(builder: (context) => TitleRoute()),);
    return myRouteTitle;
  }

  // create new empty geo note
  Future<void> _createGeoNote(BuildContext context) async {

    GeoNote newGeoNote = GeoNote(myGeoNotes.length,
        "text",
        _myRoutePoint.last.latitude,
        _myRoutePoint.last.longitude,
        "");
    newGeoNote = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditorScreen(geoNote: newGeoNote)),);
    if (newGeoNote.text != '') {
      myGeoNotes.add(newGeoNote);
    }

    //debugPrint(" added a new geo note $updatedGeoNote.id containing $updatedGeoNote.text.toString()" );
  }

  Future<void> _createAudioNote(BuildContext context) async {
    // ignore: use_build_context_synchronously!
    String audioPath = "";
    await Navigator.push(context, MaterialPageRoute(builder: (context)
    => AudioRecorder(
        onStop: (path) {
          setState(() {
            audioPath = path;
            debugPrint("el path del audio is... $audioPath");

            final audioGeoNote = GeoNote(myGeoNotes.length,
              "audio",
              _myRoutePoint.last.latitude,
              _myRoutePoint.last.longitude,
              "add a description to the audio...",
            );
            audioGeoNote.imgPath = path; // TODO is not an image it is audio.. store in different field?
            myGeoNotes.add(audioGeoNote);
            Navigator.pop(context);
          });
        })
    ));

  }

  // this only works with the iphone hardwre / it does not work with laptop.
  Future<void> _createPhotoGeoNote(BuildContext context) async {

    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    if (cameras.length < 1) {
      debugPrint("No cameras found in your device sorry");
      return;
    }

    final firstCamera = cameras.first;
    debugPrint("firstcamera $cameras.first");

    // ignore: use_build_context_synchronously!
    final imgPath = await Navigator.push(context, MaterialPageRoute(builder: (context) => TakePictureScreen(camera: firstCamera)));
    //debugPrint(" the img path is $imgPath");

    final imgGeoNote = GeoNote(myGeoNotes.length,
      "photo",
      _myRoutePoint.last.latitude,
      _myRoutePoint.last.longitude,
      "add a description to the photo...",
    );
    imgGeoNote.imgPath = imgPath;
    myGeoNotes.add(imgGeoNote);
  }

  List<Marker> _buildMarkersList(List<GeoNote> geoNotesList){
    var myMarkers = myGeoNotes.map((geoNote) {
      return Marker(
        width: 80.0,
        height: 80.0,
        point: geoNote.getLatLon(),

        //builder: (ctx) => const Icon(Icons.location_pin, color: Colors.pink,),
        builder: (ctx) => GestureDetector(
          onTap: () {
            _editGeoNote(context, geoNote);
          },
          child:  Icon(Icons.location_pin, color: myColorPalette(geoNote),  size: 40.0,),
        ),
      );
    }).toList();
    return myMarkers;
  }

  Color myColorPalette (GeoNote geoNote ) {
    switch(geoNote.note_type){
      case 'text':
        return const Color(0xCA20FFBA);

      case 'photo':
        return  const Color(0xC0BA6520);

      case 'audio':
        return  const  Color(0xB2FF209E);

      default:
        return  const  Color(0xB2FF209E);
    }

  }


  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: _mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: _mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: _mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
    CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }


}


