// Copyright 2023 Jose Berengueres. Qualnotes AB

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FileItem extends StatelessWidget {
  const FileItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final QueryDocumentSnapshot<Map<String, dynamic>> item;

  Icon mapit(String type) {
    switch (type) {
      case 'map':
        return const Icon(
          Icons.map_outlined,
          color: Colors.black,
        );
      case 'interview':
        return const Icon(
          Icons.chat_bubble_outline_rounded,
          color: Colors.black,
        );
      case 'consent':
        return const Icon(
          Icons.lock_person_outlined,
          color: Colors.black,
        );
      default:
        return const Icon(
          Icons.file_copy_outlined,
          color: Colors.black,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 8,
      leading: mapit(item.get('type').toString()),
      title: Text(
        item.get('title').toString(), // + " id " + item.id.toString(),
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 18),
      ),
      enabled: true,
      minLeadingWidth: 0,
      onTap: () {
        // TO DO generate organize urls in projectid/contentid/
        context.goNamed('project ... / content ... ',
            queryParams: {'content_id': item.id.toString()});
      },
      //textAlign: item.get('sender') == 'me' ? TextAlign.end : TextAlign.start,
    );
  }
}
