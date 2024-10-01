import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Admin/Pages/admin_home_page.dart';
import 'package:myshop/Admin/admin_navigation_bar.dart';
import 'package:myshop/pages/onStart/splash_screen.dart';



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
    return  const SplashScreen();
  }
}
