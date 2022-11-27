import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireBaseAuthProvider{
  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;

  Stream<User?> get onAuthStatedChanged => _firebaseauth.authStateChanges();

  Future<String?> getCurrentUID() async {
    return _firebaseauth.currentUser?.uid;
  }

  Future<User?> getCurrentUser() async {
    return _firebaseauth.currentUser;
  }

  Future<Map> efetuarLogin(String email, String senha) async {
    try {
      final userCredential = await _firebaseauth.signInWithEmailAndPassword(email: email, password: senha); 
        return {
          'id': userCredential.user?.uid,
          'displayName': userCredential.user?.displayName,
          'email': userCredential.user?.email,
          'photoURL': userCredential.user?.photoURL,
          'phoneNumber': userCredential.user?.phoneNumber
        };
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      if (e.code == 'user-not-found') {
        throw Exception('Login ou senha incorretos.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Login ou senha incorretos.');
      } else if (e.code == 'invalid-email'){
        throw Exception('Informe um email válido.');
      } else if (e.code == 'user-disabled'){
        throw Exception('Login ou senha incorretos.');
      }
      return {};
    }
  }

  Future<void> logOut() async{
    try {
      await _firebaseauth.signOut();
    } on Exception catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> atualizarEmail(User? user, String? emailNovo) async{
    try {
      await user?.updateEmail(emailNovo ?? '');
    } catch (e) {
      print(e.toString());
      if(e.toString().contains('invalid-email')){
        throw Exception("Informe um email válido!");
      }else if(e.toString().contains('email-already-in-use')){
        throw Exception("Este email já está em uso!");
      }else if(e.toString().contains('requires-recent-login')){
        throw Exception("Você precisa estar logado há menos tempo para atualizar seu e-mail!");
      }else throw Exception(e.toString());
    }
  }

  Future<void> atualizarSenha(String email) async{
    try {
      await _firebaseauth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if(e.toString().contains('invalid-email')){
        throw Exception("Informe um email válido!");
      }else if(e.toString().contains('user-not-found')){
        throw Exception("Usuário não encontrado!");
      }else if(e.toString().contains('missing-continue-uri')){
        throw Exception("É necessária um URL na requisição!");
      }else if(e.toString().contains('unauthorized-continue-uri')){
        throw Exception("O domínio requisitado não está autorizado!");
      }else if(e.toString().contains('requires-recent-login')){
        throw Exception("Você precisa estar logado há menos tempo para atualizar sua senha!");
      }else throw Exception(e.toString());
    }
  }

  Future<User?> getDados() async{
    _firebaseauth.authStateChanges().listen((User? user) async{
      
    });
  }
}