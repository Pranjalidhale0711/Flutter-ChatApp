import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/Widgets/common/utilis/utilis.dart';
import 'package:whatsapp/models/Calls.dart';

final Callrepositoryprovider = Provider((ref) => Callrepository(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class Callrepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  Callrepository({required this.auth, required this.firestore});

  Stream<DocumentSnapshot> get callStream =>
      firestore.collection('call').doc(auth.currentUser!.uid).snapshots();
  
  void makecall(
      Call sendercalldata, BuildContext context, Call recievercallsdata) async {
    try {
      await firestore
          .collection('call')
          .doc(sendercalldata.callerId)
          .set(sendercalldata.toMap());
      await firestore
          .collection('call')
          .doc(sendercalldata.receiverId)
          .set(recievercallsdata.toMap());
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) =>
      //             Callscreen(call: sendercalldata, channelid: sendercalldata.callId)));
    } catch (e) {
      showSnackbar(context: context, content: e.toString());
    }
  }
   void endCall(
    String callerId,
    String receiverId,
    BuildContext context,
  ) async {
    try {
      await firestore.collection('call').doc(callerId).delete();
      await firestore.collection('call').doc(receiverId).delete();
    } catch (e) {
      showSnackbar(context: context, content: e.toString());
    }
  }
}
