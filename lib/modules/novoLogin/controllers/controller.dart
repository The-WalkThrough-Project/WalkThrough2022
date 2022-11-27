import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:walkthrough/modules/loginProf/controllers/controller.dart';
import 'package:walkthrough/modules/loginProf/models/prof_model.dart';
import 'package:walkthrough/modules/loginProf/repositories/profUser_repository.dart';
import 'package:walkthrough/shared/providers/firebaseAuth_provider.dart';

class NovoLoginController extends ChangeNotifier {
  var nome = TextEditingController();
  var email = TextEditingController();
  bool hasSenha = false;
  final _repository = ProfUserRepository();
  final _firebase_auth = FireBaseAuthProvider();
  final _controllerLogout = UserProfController();

  atualizaDados(
      {required VoidCallback? sucesso(UserProf? usuario),
      required VoidCallback? falha(String motivo),
      required UserProf usuario,
      bool primeiroLogin = false}) async {
    try {
      final user = UserProf(
          nome: nome.text.trim(),
          email: email.text.trim(),
          codigo: usuario.codigo,
          id: usuario.id);
      
      print('[' + user.email! + ']');

      User? currentUser = await _firebase_auth.getCurrentUser();
      user.tipoUsuario = usuario.tipoUsuario;

      if (email.text.trim() != '') {
        await _firebase_auth.atualizarEmail(currentUser, user.email);
      } else {
        if (email.text.contains(' ')) {
          user.isValidUser();
        } else if (!primeiroLogin) {
          user.email = usuario.email;
        }
      }

      if (user.email != '' || user.nome != '') {
        await _repository.alterar(user);
        if (!primeiroLogin) {
          user.codigo = '';
        }
      }

      hasSenha ? await _firebase_auth.atualizarSenha(user.email ?? '') : null;

      sucesso(user);
    } on Exception catch (e) {
      falha(e.toString().substring(11));
    }
  }
}
