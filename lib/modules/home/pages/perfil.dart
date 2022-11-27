import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:walkthrough/modules/loginProf/controllers/controller.dart';
import 'package:walkthrough/modules/loginProf/models/prof_model.dart';
import 'package:walkthrough/modules/loginProf/pages/index.dart';
import 'package:walkthrough/modules/novoLogin/controllers/controller.dart';
import 'package:walkthrough/shared/providers/firebaseAuth_provider.dart';

class PerfilPage extends StatefulWidget {
  final UserProf usuario;

  const PerfilPage({Key? key, required this.usuario}) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final FocusNode node1 = FocusNode();
  final FocusNode node2 = FocusNode();
  bool alterar = true;
  bool alterar2 = true;
  final _controller = UserProfController();
  final _controller2 = NovoLoginController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FireBaseAuthProvider auth = FireBaseAuthProvider();

    return StreamBuilder(
        stream: auth.onAuthStatedChanged,
        builder: (context, AsyncSnapshot<User?> snapshot) {
          return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                  appBar: AppBar(
                    title: Text("Seu Perfil: ${widget.usuario.tipoUsuario}"),
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
                              _controller.removeToken();
                              _controller.logOut();
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
                  body: !isLoading
                      ? ListView(
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 25),
                              child: Text(
                                'Clique no ícone da caneta para habilitar a edição dos campos desejados!',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
                              child: Text(
                                'Seu nome:',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(RegExp(
                                      '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'))
                                ],
                                focusNode: node1,
                                controller: _controller2.nome,
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                decoration: InputDecoration(
                                  hintText: widget.usuario.nome,
                                  suffixIcon: Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: Colors.deepPurple))),
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            alterar = false;
                                            FocusScope.of(context)
                                                .requestFocus(node1);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.deepPurple,
                                        )),
                                  ),
                                  hintStyle: const TextStyle(
                                      color:
                                          Color.fromARGB(255, 166, 140, 211)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 144, 117, 189)),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.deepPurple),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                                readOnly: alterar,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
                              child: Text(
                                'Seu email:',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(RegExp(
                                      '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'))
                                ],
                                focusNode: node2,
                                controller: _controller2.email,
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                decoration: InputDecoration(
                                  hintText: widget.usuario.email,
                                  suffixIcon: Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: Colors.deepPurple))),
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            alterar2 = false;
                                            FocusScope.of(context)
                                                .requestFocus(node2);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.deepPurple,
                                        )),
                                  ),
                                  hintStyle: const TextStyle(
                                      color:
                                          Color.fromARGB(255, 166, 140, 211)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 144, 117, 189)),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.deepPurple),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                                readOnly: alterar2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 10, 20, 0),
                              child: Row(
                                children: [
                                  const Text(
                                    'Assinale caso queira alterar a sua senha: ',
                                    style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Checkbox(
                                      side: MaterialStateBorderSide.resolveWith(
                                        (states) => const BorderSide(
                                            width: 2.0,
                                            color: Colors.deepPurple),
                                      ),
                                      activeColor: Colors.deepPurple,
                                      value: _controller2.hasSenha,
                                      onChanged: (value) {
                                        setState(() {
                                          _controller2.hasSenha =
                                              !_controller2.hasSenha;
                                        });
                                      }),
                                ],
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if ((!alterar || !alterar2) &&
                                              (_controller2
                                                      .nome.text.isNotEmpty ||
                                                  _controller2
                                                      .email.text.isNotEmpty) &&
                                              (_controller2.nome.text !=
                                                      widget.usuario.nome ||
                                                  _controller2.email.text !=
                                                      widget.usuario.email ||
                                                  _controller2.hasSenha) &&
                                              (_controller2.nome.text.trim() !=
                                                      '' ||
                                                  _controller2.email.text
                                                          .trim() !=
                                                      '') ||
                                          (_controller2.hasSenha)) {
                                        if (await confirm(
                                          context,
                                          title: const Text(
                                            'Confirmação',
                                            style: TextStyle(
                                                color: Colors.deepPurple),
                                          ),
                                          content: const Text(
                                            'Você terá que entrar novamente para atualizar suas informações. \n\nCerteza?',
                                            style: TextStyle(
                                                color: Colors.deepPurple),
                                          ),
                                          textOK: const Text(
                                            'Sim',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                          textCancel: const Text(
                                            'Não',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        )) {
                                          setState(() {
                                            isLoading = true;
                                            _controller2.nome.text.isNotEmpty
                                                ? null
                                                : _controller2.nome.text =
                                                    widget.usuario.nome ?? '';
                                            _controller2.email.text.isNotEmpty
                                                ? null
                                                : _controller2.email.text =
                                                    widget.usuario.email ?? '';
                                          });
                                          await _controller2.atualizaDados(
                                              sucesso: (usuario) {
                                                _controller.logOut();
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginPage()),
                                                    (route) => false);
                                                if ((!alterar || !alterar2) &&
                                                    (_controller2.nome.text !=
                                                            widget
                                                                .usuario.nome ||
                                                        _controller2
                                                                .email.text !=
                                                            widget.usuario
                                                                .email)) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    duration: Duration(
                                                        milliseconds: 2500),
                                                    behavior:
                                                        SnackBarBehavior.fixed,
                                                    backgroundColor:
                                                        Colors.deepPurple,
                                                    content: Text(
                                                      'Dados Atualizados com sucesso!',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ));
                                                }
                                                if (_controller2.hasSenha) {
                                                  MotionToast.success(
                                                    toastDuration:
                                                        const Duration(
                                                            seconds: 5),
                                                    title: const Text(
                                                      'Sucesso',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    description: const Text(
                                                        'Verifique seu email para alterar sua senha. \nLembre-se de checar o spam!'),
                                                    animationType:
                                                        AnimationType.fromTop,
                                                    position:
                                                        MotionToastPosition.top,
                                                    barrierColor: Colors.black
                                                        .withOpacity(0.3),
                                                    width: 300,
                                                    height: 80,
                                                    dismissable: true,
                                                  ).show(context);
                                                }
                                                setState(() {
                                                  alterar = true;
                                                  alterar2 = true;
                                                });
                                              },
                                              falha: (motivo) {
                                                MotionToast.error(
                                                  title: const Text(
                                                    'Erro',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  description: Text(motivo),
                                                  animationType:
                                                      AnimationType.fromLeft,
                                                  position:
                                                      MotionToastPosition.top,
                                                  barrierColor: Colors.black
                                                      .withOpacity(0.3),
                                                  width: 300,
                                                  height: 80,
                                                  dismissable: true,
                                                ).show(context);
                                                setState(() {
                                                  _controller2.nome.text ==
                                                          widget.usuario.nome
                                                      ? _controller2.nome.text =
                                                          ''
                                                      : null;
                                                  _controller2.email.text ==
                                                          widget.usuario.email
                                                      ? _controller2
                                                          .email.text = ''
                                                      : null;
                                                });
                                              },
                                              usuario: widget.usuario);
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      }
                                    },
                                    child: const Text('Confirmar'),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      backgroundColor: (_controller2
                                                      .nome.text.isNotEmpty ||
                                                  _controller2
                                                      .email.text.isNotEmpty) &&
                                              (_controller2.nome.text !=
                                                      widget.usuario.nome ||
                                                  _controller2.email.text !=
                                                      widget.usuario.email) && (_controller2.nome.text.trim() !=
                                                      '' ||
                                                  _controller2.email.text
                                                          .trim() !=
                                                      '') ||
                                                  (_controller2.hasSenha)
                                          ? Colors.deepPurple
                                          : const Color.fromARGB(
                                              255, 166, 140, 211),
                                    ),
                                  ),
                                ))
                          ],
                        )
                      : Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CircularProgressIndicator(
                                color: Colors.deepPurple,
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Carregando...',
                                  style: TextStyle(
                                      color: Colors.deepPurple, fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        )));
        });
  }
}
