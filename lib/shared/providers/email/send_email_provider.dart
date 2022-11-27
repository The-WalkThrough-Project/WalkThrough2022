import 'dart:convert';

import 'package:http/http.dart' as http;

class EmailProvider {
  Future enviaEmailSolicitacao({
    required String nomeProf,
    required String nomeGerenciador,
    required String emailProf,
    required String emailGerenciador,
    required String assunto,
    required String dataAgendamento,
    required String horarioInicialAgendamento,
    required String horarioFinalAgendamento,
    required String laboratorioAgendamento,
  }) async {
    final serviceId = 'service_ekfwezg';
    final templateId = 'template_5f0irng';
    final userId = 'leFtieyJCqYAeSCoq';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http//localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'nome_gerenciador': nomeGerenciador,
          'nome_prof': nomeProf,
          'assunto': assunto,
          'email_prof': emailProf,
          'email_gerenciador': emailGerenciador,
          'horarioInicial_agendamento': horarioInicialAgendamento,
          'data_agendamento': dataAgendamento,
          'laboratorio_agendamento': laboratorioAgendamento,
          'horarioFinal_agendamento': horarioFinalAgendamento,
        }
      }),
    );

    print(response.body);
  }

  Future enviaEmailResposta({
    required String nomeProf,
    required String nomeGerenciador,
    required String emailGerenciador,
    required String emailProf,
    required String assunto,
    required String dataAgendamento,
    required String horarioInicialAgendamento,
    required String horarioFinalAgendamento,
    required String laboratorioAgendamento,
    required String mensagem
  }) async {
    final serviceId = 'service_ekfwezg';
    final templateId = 'template_8al7s7g';
    final userId = 'leFtieyJCqYAeSCoq';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http//localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'nome_gerenciador': nomeGerenciador,
          'email_gerenciador': emailGerenciador,
          'nome_prof': nomeProf,
          'assunto': assunto,
          'email_prof': emailProf,
          'horarioInicial_agendamento': horarioInicialAgendamento,
          'data_agendamento': dataAgendamento,
          'laboratorio_agendamento': laboratorioAgendamento,
          'horarioFinal_agendamento': horarioFinalAgendamento,
          'mensagem': mensagem
        }
      }),
    );

    print(response.body);
  }
}
