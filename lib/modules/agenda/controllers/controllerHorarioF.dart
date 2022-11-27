import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:walkthrough/modules/agenda/models/horario_agendado_model.dart';
import 'package:walkthrough/modules/agenda/models/horario_fixo_model.dart';
import 'package:walkthrough/modules/agenda/repositories/horario_fixo_repository.dart';
import 'package:walkthrough/shared/databases/BD.dart';

class HorarioController extends ChangeNotifier{
  
  final nomeProfessor = TextEditingController();
  final nomeDisciplina = TextEditingController();
  final horario = TextEditingController();
  final lab = TextEditingController();
  final diaSemana = TextEditingController();
  final _repoHorarioF = HorarioFixoRepository();

  void salvarHorario(
    {required VoidCallback sucesso,
    required VoidCallback? falha(String motivo)}) async {
    
    try {
      final horarioF = HorarioFixo(
        nomeProfessor: nomeProfessor.text.trim(),
        nomeDisciplina: nomeDisciplina.text.trim(),
        diaSemana: diaSemana.text.trim(),
        lab: lab.text.trim(),
        horario: horario.text.trim()
      );
      horarioF.isValid();
      await _repoHorarioF.incluir(horarioF);
      sucesso();

    } catch (e) {
      falha(e.toString().substring(11));
    }
  }

  void excluirHorario(
    {required VoidCallback sucesso,
    required VoidCallback? falha(String motivo)}) async {
    
    try {
      final horarioF = HorarioFixo(
        nomeProfessor: nomeProfessor.text.trim(),
        nomeDisciplina: nomeDisciplina.text.trim(),
        diaSemana: diaSemana.text.trim(),
        lab: lab.text.trim(),
        horario: horario.text.trim()
      );
      
      await _repoHorarioF.excluir(horarioF);
      sucesso();
    } catch (e) {
      falha(e.toString().substring(11));
    }
  }

  existeHorario(HorarioAgendado horario, String dia) async{
    print(dia);
    return await _repoHorarioF.existeHorario(horario, dia);
  }

  Future<List<HorarioFixo>?> getHorariosF(String lab) async {
    return await _repoHorarioF.selecionarTodosPLab(lab);
  }

  Future<String?> getAttTabelasHorarios() async{
    return await _repoHorarioF.getAttTabelasHorarios();
  }

  Future<void> attTabelasHorarios() async{
    String data = DateFormat('dd/MM/yyyy', 'pt_Br').format(DateTime.now());
    await _repoHorarioF.attTabelasHorarios(data);
  }

}