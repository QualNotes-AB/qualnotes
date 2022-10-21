import 'dart:developer';

import 'package:open_file/open_file.dart';
import 'package:qualnote/app/utils/open_file/open_file_interface.dart';

class OpenFileMobile implements OpenFileUtil {
  @override
  void openFile(String path) async {
    var result = await OpenFile.open(path);
    log(result.message);
  }
}

OpenFileUtil getOpenFileUtil() => OpenFileMobile();
