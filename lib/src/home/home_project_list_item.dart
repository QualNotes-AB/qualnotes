// Copyright 2023 Jose Berengueres. Qualnotes AB

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProjectItem extends StatelessWidget {
  const ProjectItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final QueryDocumentSnapshot<Map<String, dynamic>> item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 8,
      leading: const Icon(
        Icons.folder_outlined,
        color: Colors.black,
      ),
      title: Text(
        item.get('title').toString() + " id " + item.id.toString(),
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 18),
      ),
      enabled: true,
      minLeadingWidth: 0,
      onTap: () {
        context.goNamed('project', queryParams: {'prj_id': item.id.toString()});
      },
      //textAlign: item.get('sender') == 'me' ? TextAlign.end : TextAlign.start,
    );
  }
}
