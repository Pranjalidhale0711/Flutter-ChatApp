import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/features/auth/controller/Authcontroller.dart';
import 'package:whatsapp/features/call/callrepository.dart';
import 'package:whatsapp/models/Calls.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.read(Callrepositoryprovider);
  return CallController(
    callRepository: callRepository,
    auth: FirebaseAuth.instance,
    ref: ref,
  );
});

class CallController {
  final Callrepository callRepository;
  final ProviderRef ref;
  final FirebaseAuth auth;
  CallController({
    required this.callRepository,
    required this.ref,
    required this.auth,
  });
  Stream<DocumentSnapshot> get callStream => callRepository.callStream;
  void makeCall(BuildContext context, String receiverName, String receiverUid,
      String receiverProfilePic) {
    ref.read(userdataauthprovider).whenData((value) {
      String callId = const Uuid().v1();
      Call senderCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value!.name,
        callerPic: value.profilePic,
        receiverId: receiverUid,
        receiverName: receiverName,
        receiverPic: receiverProfilePic,
        callId: callId,
        hasDialled: true,
      );

      Call recieverCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value.name,
        callerPic: value.profilePic,
        receiverId: receiverUid,
        receiverName: receiverName,
        receiverPic: receiverProfilePic,
        callId: callId,
        hasDialled: false,
      );

      callRepository.makecall(senderCallData, context, recieverCallData);
    });
  }

  void endCall(
    String callerId,
    String receiverId,
    BuildContext context,
  ) {
    callRepository.endCall(callerId, receiverId, context);
  }
}
