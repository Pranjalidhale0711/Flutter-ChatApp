import 'package:flutter/material.dart';
import 'package:whatsapp/features/Chat/Screen/Mobilechatscreen.dart';
import 'package:whatsapp/Widgets/common/error.dart';
import 'package:whatsapp/features/auth/screens/Otpscreen.dart';
import 'package:whatsapp/features/auth/screens/Userinfoscreen.dart';
import 'package:whatsapp/features/auth/screens/loginscreen.dart';
import 'package:whatsapp/features/selectcontacts/Screen/select_contract_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Loginscreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const Loginscreen(),
      );
    case OTPScreen.routeName:
      final verificationid = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationid,
        ),
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );
    case MobileChatScreen.routeName:
      final argument = settings.arguments as Map<String, dynamic>;
      final name = argument['name'];
      final uid = argument['uid'];

      return MaterialPageRoute(
        builder: (context) =>MobileChatScreen(name: name, uid: uid),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Errorscreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}
