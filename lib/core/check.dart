import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:walkthrough/core/app.dart';

class FirebaseAppInit extends StatelessWidget {
  FirebaseAppInit({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Ocorreu um erro ao inicializar o Firebase!"),
            );
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return const MyApp();
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Walkthorugh',
            theme: ThemeData(
                primarySwatch: Colors.deepPurple, fontFamily: 'Roboto'),
            home: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(
                  color: Colors.deepPurple,
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Carregando...',
                    style: TextStyle(color: Colors.deepPurple, fontSize: 18),
                  ),
                )
              ],
            )),
          );
        });
  }
}
