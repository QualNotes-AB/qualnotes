import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:flutter/material.dart';


class FireBaseAPI {

  static UploadTask? uploadFile(String dest, File file) {

    try {
      final ref = FirebaseStorage.instance.ref(dest);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return null;
    }

  }
}
