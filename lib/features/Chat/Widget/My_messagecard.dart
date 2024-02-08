import 'package:flutter/material.dart';
import 'package:whatsapp/Widgets/Colors.dart';
import 'package:whatsapp/Widgets/common/enums/message_enums.dart';
import 'package:whatsapp/features/Chat/Widget/display_textimage.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;

  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(top: 5, right: 10, bottom: 5),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF128C7E), // Your primary color
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    DisplayTextImageGIF(message: message, type: type),
                    SizedBox(height: 5),
                    Text(
                      date,
                      style: TextStyle(fontSize: 12, color: const Color.fromARGB(255, 79, 75, 75)),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: -10,
                bottom: -5,
                child: CustomPaint(
                  size: Size(20, 20),
                  painter: ArrowPainter(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 114, 174, 167) // Your primary color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width + 10, size.height / 2)
      ..lineTo(size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
