import 'package:flutter/material.dart';
import 'package:whatsapp/Widgets/common/custombutton.dart';

import 'package:country_picker/country_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/Widgets/common/utilis/utilis.dart';
import 'package:whatsapp/Widgets/Colors.dart';

import 'package:whatsapp/features/auth/controller/Authcontroller.dart';

class Loginscreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const Loginscreen({super.key});
  @override
  ConsumerState<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends ConsumerState<Loginscreen> {
  final Phonecontroller = TextEditingController();
  Country? countryname;
  @override
  void dispose() {
    Phonecontroller.dispose();
    super.dispose();
  }

  void sendphonenumber() {
    String phoneNumber = Phonecontroller.text.trim();
    if (countryname != null && phoneNumber.isNotEmpty) {
      ref
          .read(authcontrollerprovider)
          .signinwithphone(context, '+${countryname!.phoneCode}$phoneNumber');
    } else {
      showSnackbar(context: context, content: 'Fill all the fields');
    }
  }

  void countrypicker() {
    showCountryPicker(
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        print('Select country: ${country.displayName}');
        setState(() {
          countryname = country;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter your Phone number'),
        backgroundColor: appbarcolor,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Text('Chatapp needs to verify your phone number'),
          TextButton(
              onPressed: () {
                countrypicker();
              },
              child: Text('Pick your country')),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              if (countryname != null) Text('+${countryname!.phoneCode}'),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: size.width * 0.7,
                child: TextField(
                  controller: Phonecontroller,
                  decoration: InputDecoration(
                    hintText: 'Phone number',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.1,
          ),
          SizedBox(
            // width: 10,
            child:Custombutton(text: 'NEXT', onpressed: sendphonenumber),
          )
        ],
      ),
    );
  }
}
