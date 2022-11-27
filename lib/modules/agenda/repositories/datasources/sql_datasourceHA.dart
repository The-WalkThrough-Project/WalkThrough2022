import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:walkthrough/modules/agenda/models/horario_agendado_model.dart';
import 'package:walkthrough/modules/agenda/repositories/datasources/datasource_ds_agendado.dart';
import 'package:walkthrough/shared/databases/BD.dart';

class SQLDataSourceHA extends DataSourceBaseA {
  static final _bancoSQL = BancoHorarios.instance;
  var db = _bancoSQL.database;

  @override
  Future<void> alterar(Map<String, dynamic>? horarioAgendado) async {
  }

  @override
  Future<void> excluir(Map<String, dynamic>? horarioAgendado) async {
      _bancoSQL.delete(horarioAgendado?['id']);
  }

  @override
  Future<int?> incluir(Map<String, dynamic>? horarioAgendado) async {
    String string = horarioAgendado?['data'];
    string = string.substring(0, 10);
    horarioAgendado?['data'] = string;
    return await _bancoSQL.insertHorarioAgendado(HorarioAgendado.fromMap(horarioAgendado));
  }

  @override
  Future<Map<String, dynamic>?> selecionar(int id) async {
    var map = await _bancoSQL.readHorarioAgendado(id);
    return map?.toMap();
  }

  @override
  Future<List<Map<String, dynamic>?>?> selecionarTodos() async {
    var lista = await _bancoSQL.readTodosHorariosAgendadosNotTemp();
    lista.map((e) => {
      HorarioAgendado(
        emailProfessor: e.emailProfessor,
        data: e.data,
        nomeProfessor: e.nomeProfessor,
        lab: e.lab,
        horarioFinal: e.horarioFinal,
        horarioInicial: e.horarioInicial,
        id: e.id,
        isTemp: e.isTemp,
        horarioAgendamento: e.horarioAgendamento
      ).toMap()
    }).toList();
  }
  
  @override
  Future<List<Map<String, dynamic>?>?> selecionarTodosTemp() async {
    var lista = await _bancoSQL.readTodosHorariosAgendadosTemp();
    lista.map((e) => {
      HorarioAgendado(
        emailProfessor: e.emailProfessor,
        data: e.data,
        nomeProfessor: e.nomeProfessor,
        lab: e.lab,
        horarioFinal: e.horarioFinal,
        horarioInicial: e.horarioInicial,
        id: e.id,
        isTemp: e.isTemp,
        horarioAgendamento: e.horarioAgendamento
      ).toMap()
    }).toList();
  }
  
  @override
  Future<bool?>? existeHorario(Map<String, dynamic>? horarioAgendado) {
    String string = horarioAgendado?['data'];
    string = string.substring(0, 10);
    horarioAgendado?['data'] = string;
  }
  
  @override
  Future<bool?>? selecionarTodosDiaLab(Map<String, dynamic>? horarioAgendado) {
  }

  @override
  Future<String?> getEmailGerenciador() async{
    return '';
  }
}
