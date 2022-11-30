import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:walkthrough/modules/agenda/repositories/datasources/datasource_ds_fixo.dart';
import 'package:walkthrough/modules/loginProf/models/prof_model.dart';

class FireBaseFirestoreProvider {
  FirebaseFirestore _firebasefirestore = FirebaseFirestore.instance;

  Future<UserProf> getDadosUsuario(String? id) async {
    try {
      var qs = await _firebasefirestore
          .collection('usuários')
          .doc(id)
          .get();
      UserProf user = UserProf.fromMap(qs.data());
      return user;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  removeToken(Map<String, dynamic> user, String? id) async{
    try {
    await _firebasefirestore
        .collection("usuários")
        .doc(id)
        .update(user);
    return true;
      
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
  
}
