import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:walkthrough/modules/home/pages/index.dart';
import 'package:walkthrough/modules/loginProf/controllers/controller.dart';
import 'package:walkthrough/modules/loginProf/models/prof_model.dart';
import 'package:walkthrough/modules/loginProf/pages/index.dart';
import 'package:walkthrough/shared/providers/firebaseAuth_provider.dart';

class HomeController extends StatefulWidget {
  const HomeController({Key? key}) : super(key: key);

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  final _controller = UserProfController();
  UserProf usuario = UserProf();
  
  @override
  initState(){
    super.initState();
    getDadosOnPage();
  }

  getDadosOnPage() async{
    usuario = await _controller.getDados();
    setState(() {
      usuario;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final FireBaseAuthProvider auth = FireBaseAuthProvider();

    return StreamBuilder(      
      stream: auth.onAuthStatedChanged,
      builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final bool signedIn = snapshot.hasData;
            if (signedIn) {
              return HomePage(usuario: usuario);
            } else {
              return const LoginPage();
            }
          }
          return Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            ),
        );
        }
    );
  }
}