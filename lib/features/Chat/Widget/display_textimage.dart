import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/Widgets/common/enums/message_enums.dart';
import 'package:whatsapp/features/Chat/Widget/videoplayer.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGIF({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : Container(
          // padding: const EdgeInsets.all(3),
           height:200,
           width: 200,

          child:type==MessageEnum.image? CachedNetworkImage(imageUrl: message):VideoPlayerItem(videoUrl: message),
        );
  }
}
