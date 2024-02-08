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
          margin: EdgeInsets.only(top: 5, left: 10, bottom: 5),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF9A4CAF), // Your chosen color
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(20),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DisplayTextImageGIF(message: message, type: type),
                    SizedBox(height: 5),
                    Text(
                      date,
                      style: TextStyle(fontSize: 12, color: const Color.fromARGB(255, 75, 74, 74)),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: -10,
                bottom: -5,
                child: CustomPaint(
                  size: Size(20, 20),
                  painter: ArrowPainter(isLeftArrow: true),
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
  final bool isLeftArrow;

  ArrowPainter({required this.isLeftArrow});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9A4CAF) // Your chosen color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(isLeftArrow ? 0 : size.width, 0)
      ..lineTo(isLeftArrow ? -10 : size.width - 10, size.height / 2)
      ..lineTo(isLeftArrow ? 0 : size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
