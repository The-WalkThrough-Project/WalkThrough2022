import 'dart:convert';

class UserProf {

  int? id;
  String? nome;
  String? codigo;
  String? email;
  String? tipoUsuario;

  UserProf({
    this.id,
    this.nome,
    this.codigo,
    this.email,
    this.tipoUsuario,
  });

  UserProf copyWith({
    int? id,
    String? nome,
    String? codigo,
    String? email,
    String? tipoUsuario,
  }) {
    return UserProf(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      codigo: codigo ?? this.codigo,
      email: email ?? this.email,
      tipoUsuario: tipoUsuario ?? this.tipoUsuario,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(id != null){
      result.addAll({'id': id});
    }
    if(nome != null){
      result.addAll({'nome': nome});
    }
    if(codigo != null){
      result.addAll({'codigo': codigo});
    }
    if(email != null){
      result.addAll({'email': email});
    }
    if(tipoUsuario != null){
      result.addAll({'tipoUsuario': tipoUsuario});
    }
  
    return result;
  }

  String toJson() => json.encode(toMap());

  factory UserProf.fromJson(String source) => UserProf.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserProf(id: $id, nome: $nome, codigo: $codigo, email: $email, tipoUsuario: $tipoUsuario)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserProf &&
      other.id == id &&
      other.nome == nome &&
      other.codigo == codigo &&
      other.email == email &&
      other.tipoUsuario == tipoUsuario;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      nome.hashCode ^
      codigo.hashCode ^
      email.hashCode ^
      tipoUsuario.hashCode;
  }

  bool isValid(String? senha){
    if((senha == null || senha.isEmpty) && (email == null || email!.isEmpty)){
        throw Exception("Preencha os campos!");
    }
    if(senha == null || senha.isEmpty){
      throw Exception("Senha não informada.");
    }
    if(email == null || email!.isEmpty){
      throw Exception("Login não informado.");
    }
    return true;
  }

  bool isValidUser(){
    if(email == null || email!.isEmpty){
      throw Exception("Email não informado.");
    }
    if(nome == null || nome!.isEmpty){
      throw Exception("Nome não informado.");
    }
    return true;
  }

  factory UserProf.fromMap(Map<String, dynamic>? map) {
    return UserProf(
      id: map?['id']?.toInt(),
      nome: map?['nome'],
      codigo: map?['codigo'],
      email: map?['email'],
      tipoUsuario: map?['tipoUsuario'],
    );
  }
}
