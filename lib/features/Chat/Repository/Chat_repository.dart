import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:whatsapp/Widgets/common/enums/message_enums.dart';
import 'package:whatsapp/Widgets/common/repository/common_firebase_storage_repository.dart';
import 'package:whatsapp/Widgets/common/utilis/utilis.dart';
import 'package:whatsapp/data/datas.dart';
import 'package:whatsapp/models/chat_contact.dart';
import 'package:whatsapp/models/message.dart';
import 'package:whatsapp/models/user_model.dart';

final Chatrepositoryprovider = Provider((ref) => Chatrepository(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class Chatrepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  Chatrepository({required this.firestore, required this.auth});
  Stream<List<Chatcontact>> getcontact() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<Chatcontact> contacts = [];
      for (var document in event.docs) {
        var chatContact = Chatcontact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactid)
            .get();
        var user = UserModel.fromMap(userData.data()!);

        contacts.add(
          Chatcontact(
            name: user.name,
            profilepic: user.profilePic,
            contactid: chatContact.contactid,
            timesent: chatContact.timesent,
            lastmessage: chatContact.lastmessage,
          ),
        );
      }
      return contacts;
    });
  }

  Stream<List<Message>> getallmessages(String recieveruserid) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieveruserid)
        .collection('message')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  void _savedatatoContactSubcollection(
    UserModel senderuserdata,
    UserModel receiveruserdata,
    String text,
    DateTime timesent,
    String recieveruserid,
  ) async {
    var recieverChatcontact = Chatcontact(
        name: senderuserdata.name,
        profilepic: senderuserdata.profilePic,
        contactid: senderuserdata.uid,
        timesent: timesent,
        lastmessage: text);
    await firestore
        .collection('users')
        .doc(recieveruserid)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(recieverChatcontact.toMap());
    var senderChatcontact = Chatcontact(
        name: receiveruserdata.name,
        profilepic: receiveruserdata.profilePic,
        contactid: receiveruserdata.uid,
        timesent: timesent,
        lastmessage: text);
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieveruserid)
        .set(senderChatcontact.toMap());
  }

  void _savemessageTomessageSubcollection(
      {required String recieversuserid,
      required String text,
      required DateTime timesent,
      required String messageid,
      required String? username,
      required recieverusername,
      required MessageEnum messagetype}) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      recieverid: recieversuserid,
      text: text,
      type: messagetype,
      timeSent: timesent,
      messageId: messageid,
      isSeen: false,
    );
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieversuserid)
        .collection('message')
        .doc(messageid)
        .set(message.toMap());
    await firestore
        .collection('users')
        .doc(recieversuserid)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('message')
        .doc(messageid)
        .set(message.toMap());
  }

  void SendTextMessage(
      {required BuildContext context,
      required String text,
      required String recieverUserid,
      required UserModel senderUser}) async {
    print(recieverUserid);
    try {
      var timesent = DateTime.now();
      UserModel receiverUserdata;
      var userdata =
          await firestore.collection('users').doc(recieverUserid).get();
      receiverUserdata = UserModel.fromMap(userdata.data()!);
      var messageid = const Uuid().v1();
      _savedatatoContactSubcollection(
          senderUser, receiverUserdata, text, timesent, recieverUserid);
      _savemessageTomessageSubcollection(
          recieversuserid: recieverUserid,
          text: text,
          timesent: timesent,
          messageid: messageid,
          username: senderUser.name,
          recieverusername: receiverUserdata?.name,
          messagetype: MessageEnum.text);
    } catch (e) {
      print('errororrrrrrrrrr');
      showSnackbar(context: context, content: e.toString());
    }
  }
  // void SendGif(
  //     {required BuildContext context,
  //     required String gif,
  //     required String recieverUserid,
  //     required UserModel senderUser}) async {
  //   print(recieverUserid);
  //   try {
  //     var timesent = DateTime.now();
  //     UserModel receiverUserdata;
  //     var userdata =
  //         await firestore.collection('users').doc(recieverUserid).get();
  //     receiverUserdata = UserModel.fromMap(userdata.data()!);
  //     var messageid = const Uuid().v1();
  //     _savedatatoContactSubcollection(
  //         senderUser, receiverUserdata, 'gif', timesent, recieverUserid);
  //     _savemessageTomessageSubcollection(
  //         recieversuserid: recieverUserid,
  //         text: gif,
  //         timesent: timesent,
  //         messageid: messageid,
  //         username: senderUser.name,
  //         recieverusername: receiverUserdata?.name,
  //         messagetype: MessageEnum.gif);
  //   } catch (e) {
  //     print('errororrrrrrrrrr');
  //     showSnackbar(context: context, content: e.toString());
  //   }
  // }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String recieverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String imageUrl =
          await ref.read(commonfirebasestorageprovider).storeFiletoFirebase(
                'chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId',
                file,
              );

      UserModel? recieverUserData;

      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);

      String contactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMsg = '📸 Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎵 Audio';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg = 'GIF';
      }
      _savedatatoContactSubcollection(senderUserData, recieverUserData,
          contactMsg, timeSent, recieverUserId);

      _savemessageTomessageSubcollection(
        recieversuserid: recieverUserId,
        text: imageUrl,
        timesent: timeSent,
        messageid: messageId,
        username: senderUserData.name,
        messagetype: messageEnum,
        recieverusername: recieverUserData?.name,
      );
    } catch (e) {
     showSnackbar(context: context, content: e.toString());
    }
  }
}
