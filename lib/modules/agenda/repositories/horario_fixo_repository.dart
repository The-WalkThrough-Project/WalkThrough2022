import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:walkthrough/modules/agenda/models/horario_agendado_model.dart';
import 'package:walkthrough/modules/agenda/models/horario_fixo_model.dart';
import 'package:walkthrough/modules/agenda/repositories/datasources/datasource_ds_fixo.dart';
import 'package:walkthrough/modules/agenda/repositories/datasources/firebase_datasourceHF.dart';

class HorarioFixoRepository{

  final DataSourceBaseF? _db = FirebaseDataSource();

  Future<void> attTabelasHorarios(String data) async{
    await _db!.attTabelasHorarios(data);
  }

  Future<String?> getAttTabelasHorarios() async{
    return await _db!.getAttTabelasHorarios();
  }

  Future<bool?> existeHorario(HorarioAgendado horario, String dia) async{
    return await _db!.existeHorario(horario.toMap(), dia);
  }

  Future<void> incluir(HorarioFixo horarioFixo) async{
    //Validações
    horarioFixo.isValid();
    //Persistência
    _db!.incluir(horarioFixo.toMap());
  }

  Future<void> excluir(HorarioFixo horarioFixo) async{
    _db!.excluir(horarioFixo.toMap());
  }

  Future<void> alterar(HorarioFixo horarioFixo) async{
    horarioFixo.isValid();
    _db!.alterar(horarioFixo.toMap());
  }

  Future<HorarioFixo?> selecionar(String lab, String diaSemana, String horario) async{
    final map = await _db!.selecionar(lab, diaSemana, horario);
    if(map == null){
      return null;
    }
    return HorarioFixo.fromMap(map);
  }

  Future<List<HorarioFixo>?> selecionarTodos() async{
    final maps = await _db!.selecionarTodos();
    var retorno = <HorarioFixo>[];
    if(maps == null){
      return null;
    }
    for (var map in maps) {
      final horarioFixo = HorarioFixo.fromMap(map);
      retorno.add(horarioFixo);
    }
    
    return retorno;
  }

  Future<List<HorarioFixo>?> selecionarTodosPLab(String lab) async {
    final maps = await _db!.selecionarTodosPLab(lab);
    var retorno = <HorarioFixo>[];
    if(maps == null){
      return null;
    }
    maps.get().then((value) {
      for (var map in value.docs) {
        final horarioFixo = HorarioFixo.fromMap(map.data());
        retorno.add(horarioFixo);
      }
    });
      
    return retorno;
  }
}