import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Admin/Common/show_stock_card.dart';
import 'package:myshop/Admin/Pages/add_Item_to_cat_page.dart';
import 'package:myshop/Admin/Pages/admin_home_page.dart';
import 'package:myshop/Admin/Pages/product_detail_Page.dart';
import 'package:myshop/Admin/Pages/display_avail_Item.dart';
import 'package:myshop/Admin/Services/admin_services.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/pages/singleItemPage/item_detail_page.dart';

import 'package:myshop/services/Provider/user_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBOfe_iSxGMg4XHKWUgvt-7grks5UyC4kc",
          appId: "1:521138022480:android:5cbd49520ad1258a58c955",
          messagingSenderId: "521138022480",
          projectId: "grocerry-app-2fb25",
          storageBucket: "grocerry-app-2fb25.appspot.com"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // return const OnBoardScree(;
    return AdminHomePage();
  }
}
