import 'open_file_stub.dart'
    if (dart.library.io) 'package:qualnote/app/utils/open_file/open_file_mobile.dart'
    if (dart.library.html) 'package:qualnote/app/utils/open_file/open_file_web.dart';

abstract class OpenFileUtil {
  void openFile(String path) async {}

  factory OpenFileUtil() => getOpenFileUtil();
}
