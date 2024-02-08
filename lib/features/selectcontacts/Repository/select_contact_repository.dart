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

  void selectContact(Contact selectedContact, BuildContext context) async {
  try {
    var userCollection = await firestore.collection('users').get();
    bool isFound = false;
    String selectedPhoneNum =
        selectedContact.phones[0].number.replaceAll(' ', '');
    selectedPhoneNum = selectedPhoneNum.replaceAll('(', '');
    selectedPhoneNum = selectedPhoneNum.replaceAll(')', '');
    selectedPhoneNum = selectedPhoneNum.replaceAll('-', '');
    if (selectedPhoneNum.length < 13) {
      selectedPhoneNum = '+91$selectedPhoneNum';
    }

    if (selectedPhoneNum.length != 13) {
      showSnackbar(context: context, content: 'Number Invalid');
    } else {
      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
          Navigator.push(context, MaterialPageRoute(builder: (context)=>
          MobileChatScreen(name: userData.name, uid: userData.uid, profilePic: userData.profilePic)
          ));
        }
      }
    }

    if (!isFound) {
      showSnackbar(
        context: context,
        content: 'The number $selectedPhoneNum does not exist',
      );
    }
  } catch (e) {
    showSnackbar(context: context, content: e.toString());
  }
}

}
