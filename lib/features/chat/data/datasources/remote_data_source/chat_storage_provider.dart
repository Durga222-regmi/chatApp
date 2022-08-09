import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ChatStorageProviderRemoteDataSource {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String> uploadImage(File file) async {
    // try {
    final ref = _storage.ref().child(
        "Documents/${DateTime.now().millisecondsSinceEpoch}${getNameOnly(file.path)}");
    log("file:${file.path}");
    final uploadTask = ref.putFile(file);
    final imageUrl =
        (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    log("final image is$imageUrl");
    return await imageUrl;
    // }
    // catch (e) {
    //   log(e.toString());
    //   return Future.value(e.toString());
    // }
  }

  static getNameOnly(String? path) {
    return path?.split("/").last.split("%").last.split("?").first;
  }
}
