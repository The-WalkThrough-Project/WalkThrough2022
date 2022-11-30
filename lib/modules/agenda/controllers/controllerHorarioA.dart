import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:walkthrough/modules/agenda/models/horario_agendado_model.dart';
import 'package:walkthrough/modules/agenda/models/horario_fixo_model.dart';
import 'package:walkthrough/modules/agenda/repositories/horario_agendado_repository.dart';
import 'package:walkthrough/modules/agenda/repositories/horario_fixo_repository.dart';
import 'package:walkthrough/shared/databases/BD.dart';
import 'package:walkthrough/shared/providers/email/send_email_provider.dart';

class HorariosAgendadosController extends ChangeNotifier {
  final horarioInicial = TextEditingController();
  final horarioFinal = TextEditingController();
  final nomeProfessor = TextEditingController();
  final lab = TextEditingController();
  final _repositoryA = HorarioAgendadoRepository();
  final _emailProvider = EmailProvider();

  Future<ValueNotifier<Map<String, List<HorarioAgendado>>?>> getHorariosA() async {
    var horarios = await _repositoryA.selecionarTodos();
    return horarios;
  }

  String? horarioIsValid(HorarioAgendado horarioAgendado){
    if((int.parse(horarioAgendado.horarioInicial.substring(0, 2)) >= 7 && int.parse(horarioAgendado.horarioInicial.substring(0, 2)) <= 22) && (int.parse(horarioAgendado.horarioFinal.substring(0, 2)) >= 7 && int.parse(horarioAgendado.horarioFinal.substring(0, 2)) <= 22)){
       
    } else {
      return 'Favor inserir um horário entre 07:00 e 22:35!';
    } 
    if ((int.parse(horarioAgendado.horarioInicial.substring(0, 2)) == 22)) {
      if (int.parse(horarioAgendado.horarioInicial.substring(3)) <= 35) {
        
      } else {
        return 'Favor inserir um horário entre 07:00 e 22:35!';
      } 
    } 
    if (int.parse(horarioAgendado.horarioFinal.substring(0, 2)) == 22) {
      if (int.parse(horarioAgendado.horarioFinal.substring(3)) <= 35) {
          
      } else {
        return 'Favor inserir um horário entre 07:00 e 22:35!';
      } 
    } 
    if(int.parse(horarioAgendado.horarioInicial.substring(0, 2)) <= int.parse(horarioAgendado.horarioFinal.substring(0, 2))){
      if(int.parse(horarioAgendado.horarioInicial.substring(0, 2)) == int.parse(horarioAgendado.horarioFinal.substring(0, 2))){
        if(int.parse(horarioAgendado.horarioInicial.substring(3)) >= int.parse(horarioAgendado.horarioFinal.substring(3))){
          return 'Favor inserir um horário final posterior ao horário inicial!';
        }
      }
    } else {
      return 'Favor inserir um horário final posterior ao horário inicial!';
    }

    if (int.parse(horarioAgendado.horarioFinal.substring(0, 2)) - int.parse(horarioAgendado.horarioInicial.substring(0, 2)) == 0) {
      if (int.parse(horarioAgendado.horarioFinal.substring(3)) - int.parse(horarioAgendado.horarioInicial.substring(3)) < 50) {
        return 'Favor inserir um horário de 50min a 1h40min!';
      }
    } else if (int.parse(horarioAgendado.horarioFinal.substring(0, 2)) - int.parse(horarioAgendado.horarioInicial.substring(0, 2)) == 1) {
      if ((60 - int.parse(horarioAgendado.horarioInicial.substring(3))) + int.parse(horarioAgendado.horarioFinal.substring(3)) < 50) {
        return 'Favor inserir um horário de 50min a 1h40min!';
      } else if ((60 - int.parse(horarioAgendado.horarioInicial.substring(3))) + int.parse(horarioAgendado.horarioFinal.substring(3)) > 100) {
        return 'Favor inserir um horário de 50min a 1h40min!';
      }
    } else if (int.parse(horarioAgendado.horarioFinal.substring(0, 2)) - int.parse(horarioAgendado.horarioInicial.substring(0, 2)) >= 2) {
      if ((60 - int.parse(horarioAgendado.horarioInicial.substring(3))) + int.parse(horarioAgendado.horarioFinal.substring(3)) + 60 > 100) {
        return 'Favor inserir um horário de 50min a 1h40min!';
      }
    }
    
  }

  void cadastraHorarios(HorarioAgendado horarioAgendado)async {
    _repositoryA.incluir(horarioAgendado);
    String? gerenciador = await _repositoryA.getEmailGerenciador();
    String data = horarioAgendado.data;
    data = data.substring(0, 10);
    await
    _emailProvider.enviaEmailSolicitacao(
      nomeProf: horarioAgendado.nomeProfessor, 
      emailProf: horarioAgendado.emailProfessor, 
      emailGerenciador: gerenciador == null ? 'thewalkthroughproj@gmail.com' : gerenciador.split(':')[0],
      assunto: 'Solicitação de Agendamento de Laboratório', 
      laboratorioAgendamento: horarioAgendado.lab,
      dataAgendamento: data.split('-')[2] + '/' + data.split('-')[1] + '/' + data.split('-')[0],
      horarioInicialAgendamento: horarioAgendado.horarioInicial,
      horarioFinalAgendamento: horarioAgendado.horarioFinal,
      nomeGerenciador: gerenciador == null ? 'Gerenciador' : gerenciador.split(':')[1],
    );
  }

  Future<void> respostaAgendamento(HorarioAgendado horarioAgendado, String mensagem, String? nomeGerenciador, String? emailGerenciador, String avaliacao) async{
    String data = horarioAgendado.data;
    data = data.substring(0, 10);
    await
    _emailProvider.enviaEmailResposta(
      nomeProf: horarioAgendado.nomeProfessor, 
      emailProf: horarioAgendado.emailProfessor,
      assunto: 'Resposta da Solicitação de Agendamento de Laboratório: ' + avaliacao + '!', 
      laboratorioAgendamento: horarioAgendado.lab,
      dataAgendamento: data.split('-')[2] + '/' + data.split('-')[1] + '/' + data.split('-')[0],
      horarioInicialAgendamento: horarioAgendado.horarioInicial,
      horarioFinalAgendamento: horarioAgendado.horarioFinal,
      nomeGerenciador: nomeGerenciador ?? '',
      emailGerenciador: emailGerenciador ?? '',

      mensagem: mensagem
    );
  }

  existeHorario(HorarioAgendado horarioAgendado) async{
    return await _repositoryA.selecionarTodosDiaLab(horarioAgendado.toMap());
  }

  Future<List<HorarioAgendado>?> getHorariosATemp() async {
    var horarios = await _repositoryA.selecionarTodosTemp();
    return horarios;
  }

  excluirHorarioTemp(HorarioAgendado? horarioAgendado) async {
    _repositoryA.excluir(horarioAgendado);
  }

  atualizarHorarioTemp(HorarioAgendado? horarioAgendado) async {
    if (horarioAgendado == null) {
      return null;
    }
    _repositoryA.alterar(horarioAgendado);
  }
}
