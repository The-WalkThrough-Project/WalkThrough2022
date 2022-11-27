import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DataSourceBaseA{

  Future<bool?>? selecionarTodosDiaLab(Map<String, dynamic>? horarioAgendado);

  Future<bool?>? existeHorario(Map<String, dynamic>? horarioAgendado);

  Future<int?> incluir(Map<String, dynamic>? horarioAgendado);

  Future<void> excluir(Map<String, dynamic>? horarioAgendado);

  Future<void> alterar(Map<String, dynamic>? horarioAgendado);

  Future<Map<String, dynamic>?> selecionar(int id);

  Future<List<Map<String, dynamic>?>?> selecionarTodos();

  Future<List<Map<String, dynamic>?>?> selecionarTodosTemp();

  Future<String?> getEmailGerenciador();
  
}