
import 'package:latlong2/latlong.dart';


// Every thing is a geonote

// TODO GeoMap.toMarkers()  GeoMap.toCards()
class GeoNote {
  int note_index;//String route_title;
  String note_type;
  num lat, lon;
  String text;
  bool deleteMe = false;
  String imgPath = "";

  GeoNote(this.note_index, this.note_type,  this.lat, this.lon, this.text);

  GeoNote.fromMap3(Map<String, dynamic?> map) :
    note_index = map["note_index"],
    note_type = map["note_type"],
    lat = map["lat"],
    lon = map["lon"],
    text = map["text"],
    deleteMe = false,
    imgPath = map["img_path"];


  LatLng getLatLon() {return LatLng(this.lat as double, this.lon as double); }

  Map<String, dynamic> toJson() {
    return {
      'note_index': note_index,
      'note_type': note_type,
      'lat': lat,
      'lon': lon,
      'text': text,
      'img_path': imgPath,
    };
  }

  @override
  String toString() {
    return "Text: $text Taken at lat: $lat , lon: $lon. Index: $note_index of type: $note_type. ";
  }

  Map<String, Object?> toMap3(String routeTitle ) {
    var map = <String, Object?>{
      'note_index': note_index,
      'route_title': routeTitle,
      'note_type': note_type,
      'lat': lat,
      'lon': lon,
      'text': text,
      'img_path': imgPath,
    };
    return map;
  }


  Map<String, Object?> toMap2() {
    var map = <String, Object?>{
      'note_index': note_index,
      'note_type': note_type,
      'lat': lat,
      'lon': lon,
      'text': text,
      'img_path': imgPath,
    };
    return map;
  }

  Map<String, dynamic> toMap() {
    return {
      'note_index': note_index,
      'note_type': note_type,
      'lat': lat,
      'lon': lon,
      'text': text,
    };
  }

}

