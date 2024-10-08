import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:myshop/bloc/ProductBloc/GetAllProducts_Cubit/get_all_products_cubit.dart';
import 'package:myshop/bloc/ProductBloc/GetBestSelling_Cubit/best_selling_product_cubit.dart';
import 'package:myshop/pages/onStart/splash_screen.dart';
import 'package:myshop/services/Provider/user_provider.dart';
import 'package:myshop/bloc/AuthBloc/LoginCubit/login_cubit.dart';
import 'package:myshop/utils/constants.dart';
import 'package:provider/provider.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = stripePublishingKey;

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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        BlocProvider(
          create: (_) => LoginCubit(),
        ),
        BlocProvider(
          create: (_) => BestSellingProductCubit(),
        ),
        BlocProvider(
          create: (_) => GetAllProductsCubit(),
        ),
      ],
      child: MaterialApp(
        navigatorObservers: [routeObserver],
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
    return const SplashScreen();
  }
}
