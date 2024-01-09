import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'dart:io';

import 'package:whatsapp/features/auth/repository/Authrepository.dart';
import 'package:whatsapp/models/user_model.dart';

final authcontrollerprovider = Provider((ref) {
  final authrepository = ref.watch(authrepositoryprovider);
  return Authcontroller(authrepository: authrepository, ref: ref);
});

final userdataauthprovider = FutureProvider((ref) {
  final authcontroller = ref.watch(authcontrollerprovider);
  return authcontroller.getcurrentuserdata();
});

class Authcontroller {
  final Authrepository authrepository;
  final ProviderRef ref;
  Authcontroller({required this.authrepository, required this.ref});

  Future<UserModel?> getcurrentuserdata() async {
    UserModel? user = await authrepository.getcurrentuserdata();
    return user;
  }

  void signinwithphone(BuildContext context, String phonenumber) {
    authrepository.signinwithphone(context, phonenumber);
  }

  void verifyOtp(BuildContext context, String verificationId, String userOTP) {
    authrepository.verifyOtp(
      context: context,
      verificationid: verificationId,
      userotp: userOTP,
    );
  }

  void SaveuserDatatoFirebase(
      BuildContext context, String name, File? profilepic) {
    authrepository.SaveuserDatatoFirebase(
        name: name, profilepic: profilepic, ref: ref, context: context);
  }

  Stream<UserModel> userdatabyid(String userid) {
    return authrepository.userdata(userid);
  }

  void Signout() {
    authrepository.signOut();
  }

  void Setstate(bool isonline) {
    authrepository.setUserState(isonline);
  }
}
