import 'package:flutter/material.dart';
import 'package:walkthrough/shared/providers/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override
  // void initState() {
  //   super.initState();
  //   initializeFirebaseMessaging();
  //   checkNotifications();
  // }

  // checkNotifications() async {
  //   await Provider.of<NotificationService>(context, listen: false).checkForNotifications();
  // }

  // initializeFirebaseMessaging() async {
  //   await Provider.of<FirebaseMessagingService>(context, listen: false).initialize();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WalkThrough',
      theme: ThemeData(primarySwatch: Colors.deepPurple, fontFamily: 'Roboto'),
      routes: Routes.list,
      initialRoute: Routes.initial,
      navigatorKey: Routes.navigatorKey,
      // supportedLocales: const [
      //   Locale('pt', 'BR'),
      //   Locale('en', '')
      // ],
      // localizationsDelegates: 
      //   GlobalMaterialLocalizations.delegates,
    );
  }
}
