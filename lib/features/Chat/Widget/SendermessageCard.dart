import 'package:flutter/material.dart';
import 'package:whatsapp/Widgets/Colors.dart';
import 'package:whatsapp/Widgets/common/enums/message_enums.dart';
import 'package:whatsapp/features/Chat/Widget/display_textimage.dart';

class Sendermessagecard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;

  const Sendermessagecard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: type == MessageEnum.text
              ? BoxDecoration(
                  color: Color.fromARGB(255, 153, 76, 175),
                  borderRadius: BorderRadius.circular(8),
                )
              : BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
             DisplayTextImageGIF(message: message, type: type),
                 
              SizedBox(height: 5),
              Text(
                date,
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
