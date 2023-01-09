// Copyright 2023 Jose Berengueres. Qualnotes AB
// StreamBuidler design pattern adapted from
// https://www.youtube.com/watch?v=iZrMBB2c3DQ&t=441s&ab_channel=MrAlek

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'home_project_list_item.dart';
import '../../main.dart';

class ProjectList extends StatelessWidget {
  const ProjectList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('projects')
          //.where('owner' == 'HS4130cvxdQBOZERT6m4gN8Cpqs2')
          .orderBy('created', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return const CircularProgressIndicator();
        }

        final projectItems = snapshot.data?.docs;

        return ListView.builder(
          //reverse: true,
          itemCount: snapshot.data?.size ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return ProjectItem(item: projectItems![index]);
          },
        );
      },
    );
  }
}
