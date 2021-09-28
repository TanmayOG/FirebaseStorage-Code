import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  static UploadTask? uploadTask(String location, File file) {
   final ref = FirebaseStorage.instance.ref(location);
    return ref.putFile(file);
  }
}
