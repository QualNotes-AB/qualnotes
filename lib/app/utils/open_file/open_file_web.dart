// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:qualnote/app/utils/open_file/open_file_interface.dart';

class OpenFileWeb implements OpenFileUtil {
  @override
  void openFile(String path) async {
    html.window.open(path, '');
  }
}

OpenFileUtil getOpenFileUtil() => OpenFileWeb();
