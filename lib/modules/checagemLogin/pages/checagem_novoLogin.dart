import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:walkthrough/modules/home/pages/index.dart';
import 'package:walkthrough/modules/loginProf/controllers/controller.dart';
import 'package:walkthrough/modules/loginProf/models/prof_model.dart';
import 'package:walkthrough/modules/novoLogin/pages/novoLogin.dart';
import 'package:walkthrough/shared/providers/notifications/firebase_messaging_service.dart';
import 'package:walkthrough/shared/providers/notifications/notification_service.dart';

class LoginPageController extends StatefulWidget {
  const LoginPageController({Key? key}) : super(key: key);

  @override
  State<LoginPageController> createState() => _LoginPageControllerState();
}

class _LoginPageControllerState extends State<LoginPageController> {
  final _controller = UserProfController();
  UserProf user = UserProf();
  final _firebase_messaging_service =
      FirebaseMessagingService(NotificationService());
  String? token = '';
  bool novoLogin = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  getToken() async {
    token = await _firebase_messaging_service.getDeviceFirebaseToken();
    user = await _controller.getDados();
    setState(() {
      isLoading = true;
    });
    
    setState(() {
      user;
      if (user.nome == null) {
        return;
      }
      user.nome != '' ? null : novoLogin = true;
      token;
      user.codigo = token;
    });

    await _controller.atualizaToken(user);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return novoLogin && !isLoading
        ? NovoLogin(
            user: user,
          )
        : isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple),
              )
            : HomePage(usuario: user);
  }
}
