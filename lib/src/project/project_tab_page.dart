// Copyright 2023 Jose Berengueres. Qualnotes AB

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'stepper/project_stepper.dart';
import 'settings/project_settings.dart';
import 'chat/project_chat.dart';
import 'files/file_list.dart';

class ProjectPage extends StatelessWidget {
  String? prj_id;
  ProjectPage({super.key, this.prj_id});

  @override
  Widget build(BuildContext context) {
    return MyTabs(
      prj_id: prj_id,
    );
  }
}

class MyTabs extends StatelessWidget {
  String? prj_id;
  String? prj_title;

  MyTabs({super.key, this.prj_id});

  // this part new  to extract prj id
  @override
  Widget build(BuildContext context) {
    final docRef =
        FirebaseFirestore.instance.collection("projects").doc(prj_id);

    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        prj_title = data?['title'].toString();
        print("title: $prj_title");
      },
      onError: (e) => print("Error getting document: $e"),
    );

    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
//          title: Text(' to id: $prj_id'),
          title: Text(' to id: $prj_title'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.checklist_outlined),
                text: 'Checklist',
              ),
              Tab(
                icon: Icon(Icons.file_open_sharp),
                text: 'View files',
              ),
              Tab(
                icon: Icon(Icons.chat_bubble_outline),
                text: 'Q&A',
              ),
              Tab(
                icon: Icon(Icons.brightness_5_sharp),
                text: 'Settings',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: ProjectStepper(),
            ),
            Center(
              child: FileList(),
            ),
            Center(
              child: QAndA(),
            ),
            Center(
              child: ProjectSettings(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
