import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:walkthrough/modules/loginProf/models/prof_model.dart';
import 'package:walkthrough/modules/loginProf/repositories/datasources/datasource_ds_prof.dart';
import 'package:walkthrough/modules/loginProf/repositories/datasources/firebase_datasourceProf.dart';

class ProfUserRepository{

  final DataSourceBaseProf? _db = FirebaseDataSourceProf();

  FirebaseFirestore getConexao(){
    return FirebaseFirestore.instance;
  }

  FirebaseAuth getConexaoAuth(){
    return FirebaseAuth.instance;
  }

  atualizaToken(UserProf professor){
    _db!.atualizaToken(professor.toMap());
  }

  Future<void> excluir(UserProf professor) async{
    _db!.excluir(professor.toMap());
  }

  Future<void> alterar(UserProf professor) async{
    professor.isValidUser();
    _db!.alterar(professor.toMap());
  }

  Future<UserProf?> selecionar(String login) async{
    final map = await _db!.selecionar(login);
    if(map == null){
      return null;
    }
    return UserProf.fromMap(map);
  }

  Future<List<UserProf>?> selecionarTodos() async{
    final maps = await _db!.selecionarTodos();
    var retorno = <UserProf>[];
    if(maps != null)
    for (var map in maps) {
      final professor = UserProf.fromMap(map);
      retorno.add(professor);
    }
    
    return retorno;
  }
}