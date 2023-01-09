// Copyright 2023 Jose Berengueres. All rights reserved.

import 'package:flutter/material.dart';

import '../../widgets.dart';

class ProjectSettings extends StatelessWidget {
  const ProjectSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        const SizedBox(height: 8),
        IconAndDetail(
            Icons.badge_outlined, "shared with: 3 [click here to edit]"),
        IconAndDetail(Icons.download_outlined, " Export"),
        IconAndDetail(
            Icons.calendar_month_outlined, "creation date: 2021/10/21 11:34"),
        IconAndDetail(Icons.edit, "last mod by: j.bingt@su.se"),
        IconAndDetail(
            Icons.calendar_month_outlined, "last mod: 2022/12/23 9:37"),
        IconAndDetail(
            Icons.calendar_month_outlined, "last export: 2022/12/23 9:34"),
        IconAndDetail(Icons.map_outlined, "maps: 1"),
        IconAndDetail(Icons.voice_chat, "interviews PO's: 3"),
        IconAndDetail(Icons.lock_outline, "signed consent forms: 34"),
        IconAndDetail(Icons.folder_open_outlined, "Storage in use: 132.2MB"),
        const SizedBox(height: 16),
        const Divider(
          height: 8,
          thickness: 1,
          indent: 8,
          endIndent: 8,
          color: Colors.grey,
        ),
        const SizedBox(height: 8),
        IconAndDetail(
            Icons.dangerous_outlined, "Danger zone (only visible to admin)"),
        IconAndDetail(Icons.delete_forever, "[delete] (cannot be undone)"),
        const SizedBox(height: 16),
        Text("to see your account info click here"),
      ],
    );
  }
}
