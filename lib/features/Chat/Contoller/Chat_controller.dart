import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:whatsapp/Widgets/common/enums/message_enums.dart';
import 'package:whatsapp/features/Chat/Repository/Chat_repository.dart';
import 'package:whatsapp/features/auth/controller/Authcontroller.dart';
import 'package:whatsapp/models/chat_contact.dart';
import 'package:whatsapp/models/message.dart';
import 'dart:io';

final Chatcontrollerprovider = Provider((ref) {
  final Chatrepository = ref.watch(Chatrepositoryprovider);
  return Chatcontroller(chatrepository: Chatrepository, ref: ref);
});

class Chatcontroller {
  final Chatrepository chatrepository;
  final ProviderRef ref;
  Chatcontroller({required this.chatrepository, required this.ref});
  void Sendtextmessage(
      BuildContext context, String text, String recieversuserid) {
    ref.read(userdataauthprovider).whenData((value) =>
        chatrepository.SendTextMessage(
            context: context,
            text: text,
            recieverUserid: recieversuserid,
            senderUser: value!));
  }

  Stream<List<Chatcontact>> chatContacts() {
    return chatrepository.getcontact();
  }

  Stream<List<Message>> getmessages(String recieversid) {
    return chatrepository.getallmessages(recieversid);
  }

  void SendFilemessage(BuildContext context, File file, String recieversuserid,
      MessageEnum messageEnum) {
    ref.read(userdataauthprovider).whenData((value) =>
        chatrepository.sendFileMessage(
            context: context,
            file: file,
            recieverUserId: recieversuserid,
            senderUserData: value!,
            ref: ref,
            messageEnum: messageEnum));
  }

  // void sendGif(BuildContext context, String gif, String recieveruserid) {
  //   ref.read(userdataauthprovider).whenData((value) => 
  //     chatrepository.SendGif(context: context, gif: gif, recieverUserid: recieveruserid, senderUser: value!)
  //   );
  // }
}
