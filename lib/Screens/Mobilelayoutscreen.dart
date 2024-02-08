import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/Widgets/Colors.dart';
import 'package:whatsapp/features/Chat/Widget/contact_list.dart';
import 'package:whatsapp/features/auth/controller/Authcontroller.dart';
import 'package:whatsapp/features/selectcontacts/Screen/select_contract_screen.dart';

class Mobilelayoutscreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<Mobilelayoutscreen> createState() => _MobilelayoutscreenState();
}

class _MobilelayoutscreenState extends ConsumerState<Mobilelayoutscreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
        late TabController tabBarController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     tabBarController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authcontrollerprovider).Setstate(true);
        break;
      case AppLifecycleState.detached:
        ref.read(authcontrollerprovider).Setstate(false);
        break;
      default:
        ref.read(authcontrollerprovider).Setstate(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appbarcolor,
          title: Center(
            child: Text(
              'Chats',
              
              style: TextStyle(color: textcolor,fontWeight: FontWeight.w700),
            ),
          ),
        
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, SelectContactsScreen.routeName);
            },
            child: Icon(Icons.comment,color: Colors.grey,),
            backgroundColor: Color.fromARGB(255, 7, 33, 50)),
        body: ContactsList(),
      ),
    );
  }
}
