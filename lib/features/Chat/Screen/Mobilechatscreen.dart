import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/Widgets/Colors.dart';
import 'package:whatsapp/Widgets/common/loader.dart';
import 'package:whatsapp/features/Chat/Widget/Chatlist.dart';
import 'package:whatsapp/features/Chat/Widget/bottom_chatfield.dart';
import 'package:whatsapp/features/auth/controller/Authcontroller.dart';
import 'package:whatsapp/features/auth/repository/Authrepository.dart';
import 'package:whatsapp/models/user_model.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;

  const MobileChatScreen({required this.name, required this.uid, super.key});

  // void makeCall(WidgetRef ref, BuildContext context) {
  //   ref.read(callControllerProvider).makeCall(
  //         context,
  //         name,
  //         uid,
  //         profilePic,
  //         isGroupChat,
  //       );
  // }
  void logout(BuildContext context,WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        print("hi");
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarcolor,
        title: StreamBuilder<UserModel>(
            stream: ref.read(authcontrollerprovider).userdatabyid(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loader();
              }
              return Column(
                children: [
                  Text(name),
                  Text(snapshot.data!.isOnline ? 'online' : 'offline')
                ],
              );
            }),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {
              logout(context,ref);
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [  ChatList(recieverUserId: uid),
         Bottomchatfield(recieveruserid: uid,),
        // ChatList(recieverUserId: uid)
        ],
      ),
    );
  }
}
