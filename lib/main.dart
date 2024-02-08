import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/Widgets/common/error.dart';
import 'package:whatsapp/Widgets/common/loader.dart';
import 'package:whatsapp/Screens/Mobilelayoutscreen.dart';


import 'package:whatsapp/Widgets/Colors.dart';
import 'package:whatsapp/features/auth/controller/Authcontroller.dart';
import 'package:whatsapp/features/landing/screens/Landingscreen.dart';
import 'package:whatsapp/firebase_options.dart';
import 'package:whatsapp/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Whatsapp',
        theme: ThemeData.light()
            .copyWith(scaffoldBackgroundColor: backgroundcolor),
        // home: ResponsiveLayout(
        //     mobileScreenLayout: Mobilelayoutscreen(),
        //     webScreenLayout: Weblayoutscreen())
          home: ref.watch(userdataauthprovider).when(
            data: (user) {
              if (user == null) {
                return  Landingscreen();
              }
              return  Mobilelayoutscreen();
            },
            error: (err, trace) {
              return Errorscreen(
                error: err.toString(),
              );
            },
            loading: () => const Loader(),
          ),
          onGenerateRoute: (settings)=>generateRoute(settings),
            );
  }
}
