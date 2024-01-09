import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/Widgets/common/loader.dart';
import 'package:whatsapp/features/Chat/Contoller/Chat_controller.dart';
import 'package:whatsapp/features/Chat/Repository/Chat_repository.dart';
import 'package:whatsapp/features/Chat/Widget/My_messagecard.dart';
import 'package:whatsapp/features/Chat/Widget/SendermessageCard.dart';
import 'package:whatsapp/models/message.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;

  const ChatList({
    Key? key,
    required this.recieverUserId,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  ScrollController messageController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    messageController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream:
          ref.watch(Chatcontrollerprovider).getmessages(widget.recieverUserId),
      builder: (context, snapshot) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          messageController.jumpTo(messageController.position.maxScrollExtent);
        });
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loader();
        }
        print('i am entered');

        print(snapshot.data);

       return Expanded(
         child: ListView.builder(
              controller: messageController,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final messagedata = snapshot.data![index];
                var timesent = DateFormat.Hm().format(messagedata.timeSent);
                if (messagedata.senderId ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  return MyMessageCard(
                      message: messagedata.text,
                      date: timesent,
                      type: messagedata.type);
                }
                return Sendermessagecard(
                  message: messagedata.text,
                  date: timesent,
                  type: messagedata.type,
                );
              },
            
          ),
       );
      },
    );
  }
}
