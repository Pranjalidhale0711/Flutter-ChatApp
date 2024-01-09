import 'package:flutter/material.dart';
import 'package:whatsapp/Widgets/Colors.dart';
import 'package:whatsapp/Widgets/common/custombutton.dart';
import 'package:whatsapp/features/auth/screens/loginscreen.dart';

class Landingscreen extends StatelessWidget {
  void navigatetologinscreen(BuildContext context) {
    Navigator.pushNamed(context, Loginscreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          const Center(
              child: Text(
            'Welcome to Chatapp',
            style: TextStyle(
                color: textcolor, fontSize: 30, fontWeight: FontWeight.w800),
          )),
          SizedBox(
            height: size.height / 9,
          ),
          Image.asset('lib/Utilis/download.png'),
          SizedBox(
            height: size.height / 9,
          ),
          const Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
              style: TextStyle(
                  color: textcolor, fontSize: 15, fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: size.height / 9,
          ),
          Custombutton(text: 'AGREE AND CONTINUE', onpressed: ()=>{
            navigatetologinscreen(context)
          })
        ],
      ),
    );
  }
}
