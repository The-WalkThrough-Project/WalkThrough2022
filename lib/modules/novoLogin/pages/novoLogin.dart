import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:walkthrough/modules/home/pages/index.dart';
import 'package:walkthrough/modules/loginProf/controllers/controller.dart';
import 'package:walkthrough/modules/loginProf/models/prof_model.dart';
import 'package:walkthrough/modules/loginProf/pages/index.dart';
import 'package:walkthrough/modules/novoLogin/controllers/controller.dart';
import 'package:walkthrough/shared/components/campo_form/campo_form.dart';

class NovoLogin extends StatefulWidget {
  final UserProf user;

  const NovoLogin({Key? key, required this.user}) : super(key: key);

  @override
  State<NovoLogin> createState() => _NovoLoginState();
}

class _NovoLoginState extends State<NovoLogin> {
  final _controller = NovoLoginController();
  final _controller2 = UserProfController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Atualize seus dados!',
          ),
          actions: [
            TextButton.icon(
                onPressed: () async {
                  if (await confirm(
                    context,
                    title: const Text(
                      'Confirmação',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                    content: const Text(
                      'Você tem certeza de que deseja sair?',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                    textOK: const Text(
                      'Sim',
                      style: TextStyle(color: Colors.green),
                    ),
                    textCancel: const Text(
                      'Não',
                      style: TextStyle(color: Colors.red),
                    ),
                  )) {
                    _controller2.removeToken();
                    _controller2.logOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false);
                  }
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                label: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                CampoForm(
                  label: 'Nome',
                  controller: _controller.nome,
                ),
                CampoForm(
                  label: 'Email',
                  controller: _controller.email,
                ),
                Row(
                  children: [
                    const Text(
                      'Assinale caso queira alterar a sua senha: ',
                      style: TextStyle(
                        color: Colors.deepPurple,
                      ),
                    ),
                    Checkbox(
                        side: MaterialStateBorderSide.resolveWith(
                          (states) => const BorderSide(
                              width: 2.0, color: Colors.deepPurple),
                        ),
                        activeColor: Colors.deepPurple,
                        value: _controller.hasSenha,
                        onChanged: (value) {
                          setState(() {
                            _controller.hasSenha = !_controller.hasSenha;
                          });
                        }),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    if(_controller.nome.text.isNotEmpty ||
                                _controller.email.text.isNotEmpty ||
                                _controller.hasSenha){
                    if (await confirm(
                      context,
                      title: const Text(
                        'Confirmação',
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                      content: const Text(
                        'Você tem certeza?',
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                      textOK: const Text(
                        'Sim',
                        style: TextStyle(color: Colors.green),
                      ),
                      textCancel: const Text(
                        'Não',
                        style: TextStyle(color: Colors.red),
                      ),
                    )) {
                      await _controller.atualizaDados(
                          sucesso: (usuario) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage(
                                        usuario: usuario ?? UserProf())));
                            MotionToast.success(
                              title: const Text(
                                'Sucesso',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              description: Text('Dados atualizados!'),
                              animationType: AnimationType.fromLeft,
                              position: MotionToastPosition.top,
                              barrierColor: Colors.black.withOpacity(0.3),
                              width: 300,
                              height: 80,
                              dismissable: true,
                            ).show(context);
                          },
                          falha: (motivo) {
                            MotionToast.error(
                              title: const Text(
                                'Erro',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              description: Text(motivo),
                              animationType: AnimationType.fromLeft,
                              position: MotionToastPosition.top,
                              barrierColor: Colors.black.withOpacity(0.3),
                              width: 300,
                              height: 80,
                              dismissable: true,
                            ).show(context);
                          },
                          usuario: widget.user,
                          primeiroLogin: true);
                    }}
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: (_controller.nome.text.isNotEmpty ||
                                _controller.email.text.isNotEmpty ||
                                _controller.hasSenha)
                        ? Colors.deepPurple
                        : const Color.fromARGB(255, 166, 140, 211),
                  ),
                  child: const Text('Atualizar'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
