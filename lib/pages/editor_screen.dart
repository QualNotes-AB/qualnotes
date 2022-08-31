import 'package:flutter/material.dart';
import 'geonote.dart';
import 'editor_screen.dart';

import 'dart:io';
import 'package:record/record.dart';

import 'audio_player.dart';

// I dont know how to return value from this one so I use the one below...
class ModalFit extends StatelessWidget {
  ModalFit({Key? key}) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    //super.initState();
    _controller.addListener(() {
      final String text = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    //super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child:
          SafeArea(
              top: false,
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                <Widget>[

                Padding(padding: EdgeInsets.all(10.0), child:
                  TextFormField(
                    controller: _controller,
                    autofocus:true,
                    minLines: 5, // any number you need (It works as the rows for the textarea)
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Enter Something',
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    )
                  )
                ),

                ListTile(
                  title: Text('Delete'),
                  leading: Icon(Icons.delete),
                  onTap: () => Navigator.of(context).pop(),
                ),
                ListTile(
                  title: Text('Save & Close'),
                  leading: Icon(Icons.save_alt_outlined),
                  onTap: () => {
                    debugPrint(_controller.value.toString()),
                    //Navigator.of(context).pop(),
                    Navigator.pop(context, _controller.value.toString()),
                  },
                ),
                ],
          )
         )
    );
  }
}




// edits note
class EditorScreen extends StatelessWidget {

  //EditorScreen({Key? key}) : super(key: key);
  final GeoNote geoNote; // the geonote to edit
  EditorScreen({Key? key, required this.geoNote,}) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  String _prompt() {return geoNote.text.isEmpty ? "Enter Something": geoNote.text; }


  void initState() {
    //super.initState();
    _controller.addListener(() {
      final String text = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  Widget _preview (GeoNote gn) {
    switch(geoNote.note_type){
      case 'text':
        return  const Text("");

      case 'photo':
        return geoNote.imgPath.isNotEmpty ? Image.file(File(geoNote.imgPath), height: 150) : const Text("hello");

      case 'audio':
        return AudioPlayer(
          source: gn.imgPath,
          onDelete: () {
            //setState(() => showPlayer = false);
            // don t delete the player. no need.
          },
        );

      default:
        return  const Text("");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Note'),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex:1,
              fit:  FlexFit.tight,
              child: Padding(padding: EdgeInsets.all(5.0), child:
                  Center(
                    child: Container(
                      // child: geoNote.imgPath.isNotEmpty ? Image.file(File(geoNote.imgPath), height: 150) : const Text("hello"),
                      child: _preview(geoNote),
                    ),
                  ),
                )
            ,),
            Flexible(
                flex:1,
                child: Padding(padding: EdgeInsets.fromLTRB(10.0,0.0,10.0,0.0), child:
              TextFormField(
                  controller: _controller,
                  autofocus:true,
                  minLines: 4, // any number you need (It works as the rows for the textarea)
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: _prompt(),
                    contentPadding: const EdgeInsets.all(8.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  )
              )
              )
            ,),
            Padding(padding: EdgeInsets.fromLTRB(10.0,0.0,10.0,0.0), child:
              Row(
                children: <Widget>[
                  Padding(padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Close the screen and return "Yep!" as the result.
                        //debugPrint(_controller.value.toString());
                        geoNote.text = _controller.text;
                        Navigator.pop(context, geoNote);
                      },
                      child: const Text('Save'),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Close the screen and return "Nope." as the result.
                        Navigator.pop(context, '');
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Close the screen and return "Nope." as the result.
                        geoNote.deleteMe = true;
                        Navigator.pop(context, geoNote);
                      },
                      child: const Text('Delete'),
                    ),
                  ),
                  ]
              ),
            )
          ],
        ),
      ),
    );
  }
}


class TitleRoute extends StatelessWidget {

  TitleRoute({Key? key,}) : super(key: key);

  final TextEditingController _controller = TextEditingController();


  void initState() {
    _controller.addListener(() {
      final String text = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Save Map'),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(8.0), child:
            Center(
              child: Container(
                // child: geoNote.imgPath.isNotEmpty ? Image.file(File(geoNote.imgPath), height: 150) : const Text("hello"),
                child: const Text("Choose a title for your map"),
              ),
            ),
            ),
            Padding(padding: EdgeInsets.all(8.0), child:
            TextFormField(
                controller: _controller,
                autofocus:true,
                minLines: 1, // any number you need (It works as the rows for the textarea)
                keyboardType: TextInputType.text,
                maxLines: 1,
                //initialValue: myRouteTitle.isEmpty ? "Ex. My secret Gaudi route" :   myRouteTitle,
                decoration: const InputDecoration(
                  hintText: "Ex. My Secret Gaudi route",
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                )
            )
            ),


            Padding(padding: EdgeInsets.all(10.0), child:
            Row(
                children: <Widget>[
                  Padding(padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Close the screen and return "Yep!" as the result.
                        //debugPrint(_controller.value.toString());
                        Navigator.pop(context, _controller.text);
                      },
                      child: const Text('Save'),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Close the screen and return "Nope." as the result.
                        Navigator.pop(context, '');
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
              ]
            ),
            )
          ],
        ),
      ),
    );
  }
}

