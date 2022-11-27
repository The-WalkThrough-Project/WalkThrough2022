abstract class DataSourceBaseProf{

  Future<void> atualizaToken(Map<String, dynamic> professor);

  Future<void> excluir(Map<String, dynamic> professor);

  Future<void> alterar(Map<String, dynamic> professor);

  Future<Map<String, dynamic>?> selecionar(String login);

  Future<List<Map<String, dynamic>>?> selecionarTodos();
  
}