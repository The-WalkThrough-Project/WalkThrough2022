import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:intl/locale.dart';

class HorarioAgendado {
  
  int? id;
  final String horarioAgendamento;
  final String emailProfessor;
  final String nomeProfessor;
  final String horarioInicial;
  final String horarioFinal;
  final String data;
  final String lab;
  int? isTemp;

  HorarioAgendado({
    this.id,
    required this.horarioAgendamento,
    required this.emailProfessor,
    required this.nomeProfessor,
    required this.horarioInicial,
    required this.horarioFinal,
    required this.data,
    required this.lab,
    this.isTemp,
  });



  HorarioAgendado copyWith({
    int? id,
    String? horarioAgendamento,
    String? emailProfessor,
    String? nomeProfessor,
    String? horarioInicial,
    String? horarioFinal,
    String? data,
    String? lab,
    int? isTemp,
  }) {
    return HorarioAgendado(
      id: id ?? this.id,
      horarioAgendamento: horarioAgendamento ?? this.horarioAgendamento,
      emailProfessor: emailProfessor ?? this.emailProfessor,
      nomeProfessor: nomeProfessor ?? this.nomeProfessor,
      horarioInicial: horarioInicial ?? this.horarioInicial,
      horarioFinal: horarioFinal ?? this.horarioFinal,
      data: data ?? this.data,
      lab: lab ?? this.lab,
      isTemp: isTemp ?? this.isTemp,
    );
  }

  String toJson() => json.encode(toMap());

  factory HorarioAgendado.fromJson(String source) => HorarioAgendado.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HorarioAgendado(id: $id, horarioAgendamento: $horarioAgendamento, emailProfessor: $emailProfessor, nomeProfessor: $nomeProfessor, horarioInicial: $horarioInicial, horarioFinal: $horarioFinal, data: $data, lab: $lab, isTemp: $isTemp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is HorarioAgendado &&
      other.id == id &&
      other.horarioAgendamento == horarioAgendamento &&
      other.emailProfessor == emailProfessor &&
      other.nomeProfessor == nomeProfessor &&
      other.horarioInicial == horarioInicial &&
      other.horarioFinal == horarioFinal &&
      other.data == data &&
      other.lab == lab &&
      other.isTemp == isTemp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      horarioAgendamento.hashCode ^
      emailProfessor.hashCode ^
      nomeProfessor.hashCode ^
      horarioInicial.hashCode ^
      horarioFinal.hashCode ^
      data.hashCode ^
      lab.hashCode ^
      isTemp.hashCode;
  }

  bool isValid(){
    if(nomeProfessor.isEmpty){
      throw Exception("Nome do professor não informado.");
    }
    if(horarioInicial.isEmpty){
      throw Exception("Horário de início não informado.");
    }
    if(horarioFinal.isEmpty){
      throw Exception("Horário de fim não informado.");
    }
    if(lab.isEmpty){
      throw Exception("Laboratório não informado.");
    }
    return true;
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(id != null){
      result.addAll({'id': id});
    }
    result.addAll({'horarioAgendamento': horarioAgendamento});
    result.addAll({'emailProfessor': emailProfessor});
    result.addAll({'nomeProfessor': nomeProfessor});
    result.addAll({'horarioInicial': horarioInicial});
    result.addAll({'horarioFinal': horarioFinal});
    result.addAll({'data': data});
    result.addAll({'lab': lab});
    if(isTemp != null){
      result.addAll({'isTemp': isTemp});
    }
  
    return result;
  }

  factory HorarioAgendado.fromMap(Map<String, dynamic>? map) {
    return HorarioAgendado(
      id: map?['id']?.toInt(),
      horarioAgendamento: map?['horarioAgendamento'] ?? '',
      emailProfessor: map?['emailProfessor'] ?? '',
      nomeProfessor: map?['nomeProfessor'] ?? '',
      horarioInicial: map?['horarioInicial'] ?? '',
      horarioFinal: map?['horarioFinal'] ?? '',
      data: map?['data'] ?? '',
      lab: map?['lab'] ?? '',
      isTemp: map?['isTemp']?.toInt(),
    );
  }
}
