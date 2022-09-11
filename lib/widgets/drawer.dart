import 'package:flutter/material.dart';
import 'package:qualnotes/pages/live_location.dart';
import 'package:qualnotes/pages/privacy_policy.dart';

Widget _buildMenuItem(
    BuildContext context, Widget title, String routeName, String currentRoute) {
  var isSelected = routeName == currentRoute;

  return ListTile(
    title: title,
    selected: isSelected,
    onTap: () {
      if (isSelected) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(context, routeName);
      }
    },
  );
}

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        const DrawerHeader(
          child: Center(
            child: Text('Qual Note App Options'),
          ),
        ),
        _buildMenuItem(
          context,
          const Text('Mobile Mapping'),
          LiveLocationPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Privacy Policy'),
          MyWebView.route,
          currentRoute,
        ),
      ],
    ),
  );
}
