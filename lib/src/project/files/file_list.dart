// Copyright 2023 Jose Berengueres. Qualnotes AB
// StreamBuidler design pattern adapted from
// https://www.youtube.com/watch?v=iZrMBB2c3DQ&t=441s&ab_channel=MrAlek

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'file_item.dart';

class FileList extends StatelessWidget {
  String? prj_id;
  FileList({super.key, this.prj_id});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('projects')
          .doc('RYvvco4JVM41d6iTKNqx')
          .collection('collected_data')
          .orderBy('created', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return const CircularProgressIndicator();
        }

        final fileItems = snapshot.data?.docs;

        return ListView.builder(
          //reverse: true,
          itemCount: snapshot.data?.size ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return FileItem(item: fileItems![index]);
          },
        );
      },
    );
  }
}
