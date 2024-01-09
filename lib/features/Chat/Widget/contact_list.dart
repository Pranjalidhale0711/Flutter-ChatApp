import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/Widgets/common/loader.dart';
import 'package:whatsapp/features/Chat/Contoller/Chat_controller.dart';
import 'package:whatsapp/features/Chat/Screen/Mobilechatscreen.dart';
import 'package:whatsapp/models/chat_contact.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: StreamBuilder<List<Chatcontact>>(
        stream: ref.watch(Chatcontrollerprovider).chatContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader();
          }
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var chatcontactdata = snapshot.data![index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                MobileChatScreen(name: chatcontactdata.name, uid: chatcontactdata.contactid)));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(chatcontactdata.name),
                          subtitle: Text(chatcontactdata.lastmessage),
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(chatcontactdata.profilepic),
                            radius: 30,
                          ),
                          trailing: Text(
                              DateFormat.Hm().format(chatcontactdata.timesent)),
                        ),
                      ),
                    )
                  ],
                );
              });
        },
      ),
    );
  }
}
