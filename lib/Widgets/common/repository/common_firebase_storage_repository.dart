import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:riverpod/riverpod.dart';

final commonfirebasestorageprovider=Provider((ref) => 
  CommonFirebaseStorageRespository(firebasestorage: FirebaseStorage.instance)
);

class CommonFirebaseStorageRespository {
  CommonFirebaseStorageRespository({required this.firebasestorage});
  final FirebaseStorage firebasestorage;
  Future<String> storeFiletoFirebase(String ref, File file) async {
    UploadTask uploadTask = firebasestorage.ref().child(ref).putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downloadurl = await snap.ref.getDownloadURL();
    return downloadurl;
  }
}
