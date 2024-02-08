import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
// import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp/Widgets/Colors.dart';
import 'package:whatsapp/Widgets/common/enums/message_enums.dart';
import 'package:whatsapp/Widgets/common/utilis/utilis.dart';
import 'package:whatsapp/features/Chat/Contoller/Chat_controller.dart';
import 'dart:io';

import 'package:whatsapp/models/message.dart';

class Bottomchatfield extends ConsumerStatefulWidget {
  Bottomchatfield({required this.recieveruserid, super.key});
  final String recieveruserid;
  @override
  ConsumerState<Bottomchatfield> createState() => _BottomchatfieldState();
}

class _BottomchatfieldState extends ConsumerState<Bottomchatfield> {
  bool showsendbutton = false;
  bool isshowcontainer = false;
  bool isrecorderInit = false;
  bool isrecording = false;
  FocusNode focusnode = FocusNode();
  FlutterSoundRecorder? soundRecorder;
  final TextEditingController messagecontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    soundRecorder = FlutterSoundRecorder();
    super.initState();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic Permission is not Granted');
    }
    await soundRecorder!.openRecorder();
    isrecorderInit = true;
  }

  @override
  void sendTextmessgae() async {
    if (showsendbutton) {
      ref.read(Chatcontrollerprovider).Sendtextmessage(
          context, messagecontroller.text.trim(), widget.recieveruserid);
      setState(() {
        messagecontroller.text = '';
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isrecorderInit) {
        return;
      }
      if (isrecording) {
        await soundRecorder!.stopRecorder();
        sendfilemessage(File(path), MessageEnum.audio);
      } else {
        await soundRecorder!.startRecorder(toFile: path);
      }
      setState(() {
        isrecording = !isrecording;
      });
    }
  }

  void dispose() {
    messagecontroller;
    soundRecorder!.closeRecorder();
    isrecorderInit = false;
    super.dispose();
  }

  void showkeyboard() => focusnode.requestFocus();

  void hidekeyboard() => focusnode.unfocus();

  void hideemojicontainer() {
    setState(() {
      isshowcontainer = false;
    });
  }

  void showemojicontainer() {
    setState(() {
      isshowcontainer = true;
    });
  }

  void togglekeyboard() {
    if (isshowcontainer) {
      showkeyboard();
      hideemojicontainer();
    } else {
      hidekeyboard();
      showemojicontainer();
    }
  }

  void sendfilemessage(File file, MessageEnum messageEnum) {
    ref
        .read(Chatcontrollerprovider)
        .SendFilemessage(context, file, widget.recieveruserid, messageEnum);
    print('jijijijijij');
  }

  void Selectimage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendfilemessage(image, MessageEnum.image);
    }
  }

  void Selectvideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendfilemessage(video, MessageEnum.video);
    }
  }

  // void Selectgif() async {
  //   final gif = await PickGif(context);
  //   if (gif != null) {
  //     ref
  //         .read(Chatcontrollerprovider)
  //         .sendGif(context, gif.url, widget.recieveruserid);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                onTap: hideemojicontainer,
                controller: messagecontroller,
                focusNode: focusnode,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      showsendbutton = true;
                      hideemojicontainer();
                    });
                  } else {
                    setState(() {
                      showsendbutton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: togglekeyboard,
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: Color.fromARGB(255, 45, 43, 43),
                            ),
                          ),
                         
                        ],
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: Selectimage,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Color.fromARGB(255, 45, 43, 43),
                          ),
                        ),
                        IconButton(
                          onPressed: Selectvideo,
                          icon: const Icon(
                            Icons.attach_file,
                            color: Color.fromARGB(255, 45, 43, 43),
                          ),
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
                right: 2,
                left: 2,
              ),
              child: CircleAvatar(
                backgroundColor:appbarcolor,
                radius: 25,
                child: GestureDetector(
                  child: showsendbutton
                      ? Icon(Icons.send,color:Colors.grey,)
                      : isrecording
                          ? Icon(Icons.close,color:Colors.grey,)
                          : Icon(Icons.mic,color: Colors.grey,),
                  onTap: sendTextmessgae,
                ),
              ),
            ),
          ],
        ),
        isshowcontainer
            ? SizedBox(
                height: 300,
                child: EmojiPicker(onEmojiSelected: ((category, emoji) {
                  setState(() {
                    messagecontroller.text =
                        messagecontroller.text + emoji.emoji;
                  });
                  if (!showsendbutton) {
                    setState(() {
                      showsendbutton = true;
                    });
                  }
                })))
            : SizedBox()
      ],
    );
  }
}
