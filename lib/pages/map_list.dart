import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:qualnotes/pages/geonote.dart';
import 'sahre_test.dart';
import 'db_utils.dart';
import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: MyListOfMaps(myMaps: ["Create new","ruta 1","ruta 2","ddd","gaudi ruta secreta","sssss"], username: "oriol user"),
        ),
      ),
    );
  }
}

upLoadMap  (String map_title, String username ) async {

  List<GeoNote> myGeoNotes = await getAllNotesFor(map_title);
  String my_gnotes = base64.encode(utf8.encode(jsonEncode(myGeoNotes)));
  debugPrint(my_gnotes);
  final ref = FirebaseStorage.instance.ref();
  final map_points_json = ref.child( username + "/" + map_title + "/" +  "map_points.json");
  await map_points_json.putString(my_gnotes, format: PutStringFormat.base64);
  debugPrint(map_points_json.toString());

  // do this as https://firebase.google.com/docs/firestore/manage-data/transactions#dart_2
  String html_ul_list = "";

  myGeoNotes.forEach( (element) async {
    if (element.imgPath.isNotEmpty) {
      var file_to_upload = ref.child(username + "/" + map_title + "/" +
          element.note_index.toString() +
          "." +
          element.imgPath
              .split(".")
              .last);
      file_to_upload.putFile(File(element.imgPath));
      String url = await file_to_upload.getDownloadURL();
      html_ul_list = html_ul_list + generate_card( element, url );
    } else {
      html_ul_list = html_ul_list + generate_card( element,"" );
    }

  });

  //final ref2 = FirebaseStorage.instance.ref();
  //final my_map_url = ref.child( username + "/" + map_title);
  String my_map_cloud_url = await map_points_json.getDownloadURL();
  debugPrint("download url: " + my_map_cloud_url);


  // pop up and show link to online website for sharing. ??
  String map_index_html = content_head + html_ul_list + content_tail;
  debugPrint(map_index_html.toString());
  final index_html = ref.child( username + "/" + map_title + "/" +  "index.html");
  String my_encoded_index = base64.encode(utf8.encode(map_index_html));
  await index_html.putString(my_encoded_index, format: PutStringFormat.base64);
  String index_url = await index_html.getDownloadURL();
  debugPrint("download url for index : " + index_url);
  await Share.share("Hi! checkout my mobile map..." + index_url,  subject: "Check out " +username + "'s " + map_title);
}

class MyListOfMaps extends StatelessWidget {
  List<String>myMaps;
  String username;
  MyListOfMaps({Key? key, required this.myMaps, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context,"no changes");
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black54,
            ),
          ),
          title: const Text('Maps in your device'),

        ),
        body: Padding(
            padding: EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: myMaps.length,
              itemBuilder: (BuildContext context, int index) {
                // debugPrint(myMaps[0]);

                return ListTile(
                  trailing:
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.cloud_upload_sharp),
                      onPressed: () => upLoadMap(myMaps[index], username),
                    ),
                    margin: EdgeInsets.only(top: 8.0),
                  ),
                  leading: myMaps[index] =="Create New" ? const Icon(Icons.add_circle_outline, color: Colors.blueAccent)
                      : const Icon(Icons.map_outlined, color: Colors.black54 ),
                  title: Text(myMaps[index] ),

                  textColor: myMaps[index] =="Create New" ? Colors.blueAccent:Colors.black54 ,
                  onTap: () => {Navigator.pop(context,myMaps[index])},
                );
              },
            )
        )
    );
  }


}


String content_head =
    "<!DOCTYPE html>"
    " <html><head><title>Your QualNotes map</title>"
    "<style type='text/css' media='all'> "
    ".list {"
    "max-width: 1400px;"
    "margin: 20px auto;"
    "}"
    ".img-list a {"
    "text-decoration: none;"
    "}"
    ".li-sub p {"
    "margin: 0;}"
    ".list li {"
    "border-bottom: 1px solid #ccc;"
    "display: table;"
    "border-collapse: collapse;"
    "width: 100%;"
    "}"
    ".inner {"
    "display: table-row;"
    "overflow: hidden;"
    "}"
    ".li-img {"
    "display: table-cell;"
    "vertical-align: middle;"
    "width: 30%;"
    "padding-right: 1em;"
    "}"
    ".li-img img {"
    "display: block;"
    "width: 100%;"
    "height: auto;"
    "}"
    ".li-text {"
    "display: table-cell;"
    "vertical-align: middle;"
    "width: 70%;"
    "}"
    ".li-head {"
    "margin: 10px 0 0 0;"
    "}"
    ".li-sub {"
    "margin: 0;"
    "}"
    "@media all and (min-width: 45em) {"
    ".list li {"
    "float: left;"
    "width: 50%;"
    "}"
    "}"
    "@media all and (min-width: 75em) {"
    ".list li {"
    "width: 33.33333%;"
    "}"
    "}"
    "/* for grid */"
    "@supports(display: grid) {"
    ".list {"
    "display: grid;"
    "grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));"
    "}"
    ".list li {"
    "width: auto; /* this overrides the media queries */"
    "}"
    "}"
    "</style>"
    ""
    "</head><body>"
    "<div class='supports'></div>"
    "<ul class='list img-list''>";


String content_tail="</ul></body></html>";

String generate_card (GeoNote my_geonote, String url_link ) {

  String note_index = my_geonote.note_index.toString();
  String desc = my_geonote.toString();
  String mediaurl = url_link;

  String content_li=""
      "<li>"
      "<a href='#' class='inner'>"
      "<div class='li-img'>";

  if (my_geonote.note_type == "audio") {
    content_li = content_li + "<audio controls> <source src= $mediaurl type='audio/mpeg'> </audio>";
  } else {
    content_li = content_li + "<img src='$mediaurl' />";
  }

  content_li = content_li + "</div>"
      "<div class='li-text'>"
      "<h3 class='li-head'>Note $note_index </h3>"
      "<div class='li-sub'>"
      "<p>$desc</p>"
      "</div>"
      "</div>"
      "</a>"
      "</li>";
  return content_li;
}