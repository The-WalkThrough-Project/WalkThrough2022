import 'dart:convert';

class HorarioFixo {
    
    final int? id;
    final String? uid;
    final String? nomeProfessor;
    final String? nomeDisciplina;
    final String? lab;
    final String? diaSemana;
    final String? horario;

  HorarioFixo({
    this.id,
    this.uid,
    this.nomeProfessor,
    this.nomeDisciplina,
    this.lab,
    this.diaSemana,
    this.horario,
  });


  HorarioFixo copyWith({
    int? id,
    String? uid,
    String? nomeProfessor,
    String? nomeDisciplina,
    String? lab,
    String? diaSemana,
    String? horario,
  }) {
    return HorarioFixo(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      nomeProfessor: nomeProfessor ?? this.nomeProfessor,
      nomeDisciplina: nomeDisciplina ?? this.nomeDisciplina,
      lab: lab ?? this.lab,
      diaSemana: diaSemana ?? this.diaSemana,
      horario: horario ?? this.horario,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(id != null){
      result.addAll({'id': id});
    }
    if(uid != null){
      result.addAll({'uid': uid});
    }
    if(nomeProfessor != null){
      result.addAll({'nomeProfessor': nomeProfessor});
    }
    if(nomeDisciplina != null){
      result.addAll({'nomeDisciplina': nomeDisciplina});
    }
    if(lab != null){
      result.addAll({'lab': lab});
    }
    if(diaSemana != null){
      result.addAll({'diaSemana': diaSemana});
    }
    if(horario != null){
      result.addAll({'horario': horario});
    }
  
    return result;
  }

  factory HorarioFixo.fromMap(Map<String, dynamic> map) {
    return HorarioFixo(
      id: map['id']?.toInt(),
      uid: map['uid'],
      nomeProfessor: map['nomeProfessor'],
      nomeDisciplina: map['nomeDisciplina'],
      lab: map['lab'],
      diaSemana: map['diaSemana'],
      horario: map['horario'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HorarioFixo.fromJson(String source) => HorarioFixo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HorarioFixo(id: $id, uid: $uid, nomeProfessor: $nomeProfessor, nomeDisciplina: $nomeDisciplina, lab: $lab, diaSemana: $diaSemana, horario: $horario)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is HorarioFixo &&
      other.id == id &&
      other.uid == uid &&
      other.nomeProfessor == nomeProfessor &&
      other.nomeDisciplina == nomeDisciplina &&
      other.lab == lab &&
      other.diaSemana == diaSemana &&
      other.horario == horario;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      uid.hashCode ^
      nomeProfessor.hashCode ^
      nomeDisciplina.hashCode ^
      lab.hashCode ^
      diaSemana.hashCode ^
      horario.hashCode;
  }

  bool isValid(){
    if(nomeProfessor == null || nomeProfessor!.isEmpty){
      throw Exception("Nome do professor não informado.");
    }
    if(diaSemana == null || diaSemana!.isEmpty){
      throw Exception("Dia da semana não informado.");
    }
    if(nomeDisciplina == null || nomeDisciplina!.isEmpty){
      throw Exception("Nome da disciplina não informado.");
    }
    if(horario == null || horario!.isEmpty){
      throw Exception("Horário não informado.");
    }
    if(lab == null || lab!.isEmpty){
      throw Exception("Laboratório não informado.");
    }
    return true;
  }
}
