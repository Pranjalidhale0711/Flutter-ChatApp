import 'package:flutter/material.dart';
import 'package:whatsapp/Widgets/Colors.dart';


class Custombutton extends StatelessWidget {
  const Custombutton({required this.text,required this.onpressed, super.key});
  final String text;
  final VoidCallback onpressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onpressed, child: Text(text,style: TextStyle(color: textcolor),),
    style: ElevatedButton.styleFrom(backgroundColor: backgroundcolor,shadowColor: const Color.fromARGB(255, 11, 19, 26)),
    );
  }
}
