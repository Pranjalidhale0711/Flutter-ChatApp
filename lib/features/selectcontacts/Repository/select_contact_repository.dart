import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:riverpod/riverpod.dart';
import 'package:whatsapp/features/Chat/Screen/Mobilechatscreen.dart';
import 'package:whatsapp/Widgets/common/utilis/utilis.dart';
import 'package:whatsapp/models/user_model.dart';

final Selectcontactrepositoryprovider = Provider(
    (ref) => SelectcontactRepository(firestore: FirebaseFirestore.instance));

class SelectcontactRepository {
  final FirebaseFirestore firestore;
  SelectcontactRepository({required this.firestore});
  Future<List<Contact>> getcontacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void Selectcontact(Contact selectcontact, BuildContext context) async {
    try {
      var usercollections = await firestore.collection('users').get();
      bool isfound = false;
      for (var documents in usercollections.docs) {
        var userdata = UserModel.fromMap(documents.data());
        print(selectcontact.phones[0].number);
        var selectedphonenumber =
            selectcontact.phones[0].number.replaceAll(' ', '');
            selectedphonenumber =  selectedphonenumber.replaceAll('(', '');
     selectedphonenumber =  selectedphonenumber.replaceAll(')', '');
     selectedphonenumber =  selectedphonenumber.replaceAll('-', '');
    if ( selectedphonenumber.length < 13) {
       selectedphonenumber = '+91$selectedphonenumber';
    }
           if (selectedphonenumber == userdata.phoneNumber) {
          isfound = true;
          Navigator.pushNamed(context, MobileChatScreen.routeName,
              arguments: {'name': userdata.name, 'uid': userdata.uid});
        }
      }
      if (!isfound) {
        showSnackbar(
            context: context,
            content: 'this phone no does not exists on this app');
      }
    } catch (e) {
      showSnackbar(context: context, content: e.toString());
    }
  }
}
