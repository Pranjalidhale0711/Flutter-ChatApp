import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/Widgets/Colors.dart';
import 'package:whatsapp/Widgets/common/loader.dart';
import 'package:whatsapp/features/Chat/Widget/Chatlist.dart';
import 'package:whatsapp/features/Chat/Widget/bottom_chatfield.dart';
import 'package:whatsapp/features/auth/controller/Authcontroller.dart';
import 'package:whatsapp/features/auth/repository/Authrepository.dart';

import 'package:whatsapp/features/call/Callpickscreen.dart';
import 'package:whatsapp/features/call/callcontroller.dart';
import 'package:whatsapp/models/user_model.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final String profilePic;

  const MobileChatScreen(
      {required this.name,
      required this.uid,
      required this.profilePic,
      super.key});

  void makeCall(WidgetRef ref, BuildContext context) {
    ref.read(callControllerProvider).makeCall(
          context,
          name,
          uid,
          profilePic,
        );
  }

  void logout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Column(
            children: [
              Text('Are you sure you want to log out?'),
              IconButton(
                onPressed: () {
                  ref.watch(authrepositoryprovider).signOut();
                  Navigator.pop(context); // Close the dialog
                },
                icon: Icon(Icons.logout),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return CallPickupScreen(
      scaffold: Scaffold(
        appBar: AppBar(
          backgroundColor: appbarcolor,
          iconTheme: IconThemeData(color: Colors.grey),
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(profilePic),
                radius: 20,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(color: textcolor, fontSize: size.height / 40)),
                  StreamBuilder<UserModel>(
                    stream: ref.read(authcontrollerprovider).userdatabyid(uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Loader();
                      }
                      return Text(snapshot.data!.isOnline ? 'Online' : 'Offline', style: TextStyle(color: Colors.white, fontSize: size.height / 60));
                    },
                  ),
                ],
              ),
            ],
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                makeCall(ref, context);
              },
              icon: const Icon(Icons.video_call),
            ),
            IconButton(
              onPressed: () {
                logout(context, ref);
              },
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Column(
          children: [
            ChatList(recieverUserId: uid),
            Bottomchatfield(
              recieveruserid: uid,
            ),
          ],
        ),
      ),
    );
  }
}
