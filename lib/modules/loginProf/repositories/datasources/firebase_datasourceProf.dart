import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:walkthrough/modules/loginProf/repositories/datasources/datasource_ds_prof.dart';

class FirebaseDataSourceProf extends DataSourceBaseProf {
  final _firebasefirestore = FirebaseFirestore.instance;

  @override
  Future<void> atualizaToken(Map<String, dynamic> professor) async {
    QuerySnapshot qs = await _firebasefirestore
        .collection('usuários')
        .where("id", isEqualTo: professor['id'])
        .get();
    await _firebasefirestore
        .collection('usuários')
        .doc(qs.docs.last.id)
        .update(professor);
  }

  @override
  Future<void> alterar(Map<String, dynamic> professor) async {
    QuerySnapshot qs = await _firebasefirestore
        .collection("usuários")
        .where("id", isEqualTo: professor['id'])
        .get();

    await _firebasefirestore
        .collection("usuários")
        .doc(qs.docs.last.id)
        .update(professor);
  }

  @override
  Future<void> excluir(Map<String, dynamic> professor) async {}

  @override
  Future<Map<String, dynamic>?> selecionar(String login) async {}

  @override
  Future<List<Map<String, dynamic>>?> selecionarTodos() async {}
}
