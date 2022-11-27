import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DataSourceBaseF{

  Future<void> attTabelasHorarios(String data);

  Future<String?> getAttTabelasHorarios();

  Future<void> incluir(Map<String, dynamic> horarioFixo);

  Future<void> excluir(Map<String, dynamic> horarioFixo);

  Future<void> alterar(Map<String, dynamic> horarioFixo);

  Future<Map<String, dynamic>?> selecionar(String lab, String diaSemana, String horario);

  Future<List<Map<String, dynamic>>?> selecionarTodos();

  Future<Query<Map<String, dynamic>>?> selecionarTodosPLab(String lab);

  Future<bool?>? existeHorario(Map<String, dynamic>? horarioFixo, String dia);
  
}