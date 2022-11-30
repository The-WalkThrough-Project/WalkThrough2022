import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:walkthrough/modules/checagemLogin/pages/checagem_novoLogin.dart';
import 'package:walkthrough/modules/home/pages/index.dart';
import 'package:walkthrough/modules/loginProf/models/prof_model.dart';
import 'package:walkthrough/modules/loginProf/repositories/profUser_repository.dart';
import 'package:walkthrough/shared/providers/firebaseAuth_provider.dart';
import 'package:walkthrough/shared/providers/firebase_firestore_provider.dart';

class UserProfController extends ChangeNotifier {
  final emailRecupera = TextEditingController();
  final login = TextEditingController();
  final senha = TextEditingController();
  final _repository = ProfUserRepository();
  final _firebaseAuthProvider = FireBaseAuthProvider();
  final _firebaseFirestoreProvider = FireBaseFirestoreProvider();

  recuperarSenha(
      {required VoidCallback? sucesso(),
      required VoidCallback? falha(String motivo)}) async{
    try {
      await _firebaseAuthProvider.atualizarSenha(emailRecupera.text.trim());
      sucesso();
    } on FirebaseAuthException catch (e) {
      if(e.toString().contains('invalid-email')){
        falha("Informe um email válido!");
      }else if(e.toString().contains('user-not-found')){
        falha("Usuário não encontrado!");
      }else if(e.toString().contains('missing-continue-uri')){
        falha("É necessária um URL na requisição!");
      }else if(e.toString().contains('unauthorized-continue-uri')){
        falha("O domínio requisitado não está autorizado!");
      }else if(e.toString().contains('requires-recent-login')){
        falha("Você precisa estar logado há menos tempo para atualizar sua senha!");
      }else falha(e.toString());
    } catch (e) {
      if (e.toString().contains('empty or null')) {
        falha('Email não informado');
      } else{
        falha(e.toString().substring(11));
      }
    }
  }

  removeToken() async {
    String? userId = await _firebaseAuthProvider.getCurrentUID();
    UserProf user = await _firebaseFirestoreProvider.getDadosUsuario(userId);
    user.codigo = '';
    _firebaseFirestoreProvider.removeToken(user.toMap(), userId);
  }

  Future<UserProf> getDados() async {
    try {
      final String? userId = await _firebaseAuthProvider.getCurrentUID();
      UserProf user = await _firebaseFirestoreProvider.getDadosUsuario(userId);
      return user;
    } catch (e) {
      return UserProf();
    }
  }

  Future<void> validarLogin(
      {required VoidCallback? sucesso(),
      required VoidCallback? falha(String motivo),
      required BuildContext context}) async {
    try {
      final email = login.text.trim();
      final usuario = UserProf(
        email: email,
      );
      usuario.isValid(senha.text);

      await _firebaseAuthProvider.efetuarLogin(email, senha.text);
      sucesso();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        falha('Login ou senha incorretos.');
      } else if (e.code == 'wrong-password') {
        falha('Login ou senha incorretos.');
      } else if (e.code == 'invalid-email') {
        falha('Informe um email válido.');
      } else if (e.code == 'user-disabled') {
        falha('Login ou senha incorretos.');
      }
    } catch (e) {
      falha(e.toString().substring(11));
    }
  }

  atualizaToken(UserProf prof) {
    _repository.atualizaToken(prof);
  }

  Future<void> logOut() async {
    _firebaseAuthProvider.logOut();
  }
}
