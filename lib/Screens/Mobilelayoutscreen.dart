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
          title: Text(
            'Chatapp',
            style: TextStyle(color: textcolor),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: const Color.fromARGB(255, 54, 53, 53),
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_vert,
                  color: const Color.fromARGB(255, 51, 50, 50),
                )),
          ],
          bottom: TabBar(
             controller: tabBarController,
            tabs: [
              Tab(text: 'CHATS'),
             
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, SelectContactsScreen.routeName);
            },
            child: Icon(Icons.comment),
            backgroundColor: Color.fromARGB(255, 188, 219, 239)),
        body: ContactsList(),
      ),
    );
  }
}
