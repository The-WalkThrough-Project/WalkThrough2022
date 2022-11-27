import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:walkthrough/modules/agenda/models/horario_agendado_model.dart';
import 'package:walkthrough/modules/agenda/repositories/datasources/datasource_ds_agendado.dart';
import 'package:walkthrough/modules/agenda/repositories/datasources/firebase_datasourceHA.dart';
import 'package:walkthrough/modules/agenda/repositories/datasources/sql_datasourceHA.dart';

class HorarioAgendadoRepository{

  final DataSourceBaseA? _db = FirebaseDataSourceHA();
  final DataSourceBaseA? _db2 = SQLDataSourceHA();

  Future<bool?> existeHorario(HorarioAgendado horarioAgendado) async{
    return await _db!.existeHorario(horarioAgendado.toMap());
  }

  Future<String?> getEmailGerenciador() async{
    return await _db!.getEmailGerenciador();
  }

  Future<void> incluir(HorarioAgendado horarioAgendado) async{
    //Validações
    horarioAgendado.isValid();
    //Persistência
    int? id = await _db2?.incluir(horarioAgendado.toMap());
    horarioAgendado.id = id;
    _db!.incluir(horarioAgendado.toMap());
  }

  Future<void> incluirOff(HorarioAgendado horarioAgendado) async{
    //Validações
    horarioAgendado.isValid();
    //Persistência
    await _db2?.incluir(horarioAgendado.toMap());
  }

  Future<void> excluir(HorarioAgendado? horarioAgendado) async{
    _db2!.excluir(horarioAgendado?.toMap());
    _db!.excluir(horarioAgendado?.toMap());
  }

  Future<void> alterar(HorarioAgendado horarioAgendado) async{
    horarioAgendado.isValid();
    _db!.alterar(horarioAgendado.toMap());
  }

  Future<HorarioAgendado?> selecionar(int id) async{
    final map = await _db!.selecionar(id);
    if(map == null){
      return null;
    }
    return HorarioAgendado.fromMap(map);
  }

  Future<List<HorarioAgendado>?> selecionarTodosTemp() async{
    List<Map<String, dynamic>?>? maps = [];
    try {
      maps = await _db!.selecionarTodosTemp();
    } on Exception catch (e) {
      print(e.toString());
      maps = await _db2!.selecionarTodosTemp();
    }
    print('maps: ' + maps.toString());
    var lista = <HorarioAgendado>[];
    if(maps == null){
      return null;
    }
    for (var map in maps) {
      if(map == null){
        return null;
      }
      var horarioAgendado = HorarioAgendado.fromMap(map);
      if (horarioAgendado.isTemp == 1) {
        lista.add(horarioAgendado);
      } else {
        null;
      }
    }
    
    return lista;
  }

  Future<bool?>? selecionarTodosDiaLab(Map<String, dynamic>? horarioAgendado) async{
     return await _db!.selecionarTodosDiaLab(horarioAgendado);
  }

  Future<ValueNotifier<Map<String, List<HorarioAgendado>>?>> selecionarTodos() async{
    List<Map<String, dynamic>?>? maps = [];
    try {
      maps = await _db!.selecionarTodos();
    } on Exception catch (e) {
      print(e.toString());
      maps = await _db2!.selecionarTodos();
    }
    print('maps: ' + maps.toString());
    var lista = <HorarioAgendado>[];
    Map<String, List<HorarioAgendado>> retorno = {};
    if(maps == null){
      return ValueNotifier(null);
    }
    for (var map in maps) {
      if(map == null){
        return ValueNotifier(null);
      }
      var horarioAgendado = HorarioAgendado.fromMap(map);
      if (horarioAgendado.isTemp == 0) {
        lista.add(horarioAgendado);
      } else {
        null;
      }
    }

    print(lista.toString());

    for (var item in lista) {
      if(!retorno.containsKey(item.data)) {
        retorno.addAll({item.data: [item]});
      } else {
        List<HorarioAgendado>? lista2 = <HorarioAgendado>[];
        lista2 = retorno.containsKey(item.data) ? retorno[item.data] : [];
        lista2!.add(item);
        retorno.addAll({item.data: lista2});
      }
    }
    
    print('retorno map: ' + retorno.toString());
    ValueNotifier<Map<String, List<HorarioAgendado>>> retorno1 = ValueNotifier(retorno);
    return retorno1;
  }
}