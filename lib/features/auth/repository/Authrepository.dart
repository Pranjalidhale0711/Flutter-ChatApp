import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:whatsapp/Screens/Mobilelayoutscreen.dart';
import 'package:whatsapp/Widgets/common/repository/common_firebase_storage_repository.dart';
import 'dart:io';
import 'package:whatsapp/Widgets/common/utilis/utilis.dart';
import 'package:whatsapp/features/auth/screens/Otpscreen.dart';
import 'package:whatsapp/features/auth/screens/Userinfoscreen.dart';
import 'package:whatsapp/features/landing/screens/Landingscreen.dart';
import 'package:whatsapp/models/user_model.dart';
import 'package:whatsapp/route.dart';

final authrepositoryprovider = Provider((ref) => Authrepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class Authrepository {
  const Authrepository({required this.auth, required this.firestore});
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  Future<UserModel?> getcurrentuserdata() async {
    var userdata =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userdata.data() != null) {
      user = UserModel.fromMap(userdata.data()!);
    }
    return user;
  }

  void signinwithphone(BuildContext context, String phonenumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phonenumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: ((String verificationId, int? resendToken) async {
          Navigator.pushNamed(
            context,
            OTPScreen.routeName,
            arguments: verificationId,
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      showSnackbar(context: context, content: e.toString());
    }
  }

// ignore: non_constant_identifier_names
  void verifyOtp({
    required BuildContext context,
    required String verificationid,
    required String userotp,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationid, smsCode: userotp);
      await auth.signInWithCredential(credential);
      print('hello iam being called');
      Navigator.pushNamedAndRemoveUntil(
        context,
        UserInformationScreen.routeName,
        (route) => false,
      );
      print('huooooooooooooo');
    } on FirebaseAuthException catch (e) {
      final errorMessage = e.message ?? 'An error occurred.';
      showSnackbar(context: context, content: errorMessage);
    }
  }

  void SaveuserDatatoFirebase(
      {required String name,
      required File? profilepic,
      required ProviderRef ref,
      required BuildContext context}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photourl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';
      if (profilepic != null) {
        photourl = await ref
            .read(commonfirebasestorageprovider)
            .storeFiletoFirebase('profilePic/$uid', profilepic);
      }
      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photourl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber.toString(),
          groupId: []);
      await firestore.collection('users').doc(uid).set(user.toMap());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Mobilelayoutscreen()),
          (route) => false);
    } catch (e) {
      showSnackbar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userdata(String userid) {
    return firestore
        .collection('users')
        .doc(userid)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

  void signOut() {
    auth.signOut();
    runApp(
      ProviderScope(
        child: MaterialApp(
          home: Landingscreen(),
          onGenerateRoute: (settings) => generateRoute(settings),
        ),
      ),
    );
  }

  void setUserState(bool isonline) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'isOnline': isonline});
  }
}
