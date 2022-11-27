import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:walkthrough/modules/agenda/models/horario_agendado_model.dart';
import 'package:walkthrough/modules/agenda/repositories/datasources/datasource_ds_agendado.dart';
import 'package:walkthrough/shared/databases/BD.dart';

class FirebaseDataSourceHA extends DataSourceBaseA {
  final FirebaseFirestore _firebasefirestore = FirebaseFirestore.instance;

  @override
  Future<String?> getEmailGerenciador() async{
    QuerySnapshot qs = await _firebasefirestore
        .collection("usuários")
        .where("tipoUsuario", isEqualTo: 'Gerenciador')
        .get();

    if (qs.docs.isEmpty) {
      return null;
    }

    return qs.docs.last.get('email') + ':' +  qs.docs.last.get('nome');
  }

  @override
  Future<void> alterar(Map<String, dynamic>? horarioAgendado) async {
    QuerySnapshot qs = await _firebasefirestore
        .collection("horáriosAgendados")
        .where("nomeProfessor", isEqualTo: horarioAgendado?['nomeProfessor'])
        .where('lab', isEqualTo: horarioAgendado?['lab'])
        .where('data', isEqualTo: horarioAgendado?['data'])
        .where('id', isEqualTo: horarioAgendado?['id'])
        .get();

    if (horarioAgendado == null) {
      return null;
    }

    await _firebasefirestore
        .collection("horáriosAgendados")
        .doc(qs.docs.last.id)
        .update(horarioAgendado);
  }

  @override
  Future<bool?>? selecionarTodosDiaLab(
      Map<String, dynamic>? horarioAgendado) async {
    List<String?>? lista = [];
    int g = -1;
    int h = - 1;
    String string = horarioAgendado?['data'];
    string = string.substring(0, 10);

    for (var i = int.parse(horarioAgendado?['horarioInicial'].substring(0, 2));
          i <= int.parse(horarioAgendado?['horarioFinal'].substring(0, 2));
          i++) {
        if (int.parse(horarioAgendado?['horarioInicial'].substring(3)) != 0 && g != 0) {
          g = int.parse(horarioAgendado?['horarioInicial'].substring(3));
        } else {
          g = 0;
        }
        if (i == int.parse(horarioAgendado?['horarioFinal'].substring(0, 2))) {
          h = int.parse(horarioAgendado?['horarioFinal'].substring(3)) + 1;
        }
        else {
          h = 60;
        }

        for (var j = g; j < h; j++) {
          if (i >= 10) {
            if (j >= 10) {
              lista.add(i.toString() + ':' + j.toString());
            } else {
              lista.add(i.toString() + ':' + '0' + j.toString());
            }
          } else {
            if (j >= 10) {
              lista.add('0' + i.toString() + ':' + j.toString());
            } else {
              lista.add('0' + i.toString() + ':' + '0' + j.toString());
            }
          }
          if (i == int.parse(horarioAgendado?['horarioFinal'].substring(0, 2)) && j == int.parse(horarioAgendado?['horarioFinal'].substring(3))) {
            break;
          }
        }
        g = 0;
      }

    QuerySnapshot qs = await _firebasefirestore
        .collection("horáriosAgendados")
        .where('lab', isEqualTo: horarioAgendado?['lab'])
        .where('data', isEqualTo: string)
        .where('isTemp', isEqualTo: 0)
        .get();
    print('dasdadas WQSQS:' + qs.docs.toString());
    

    for (var element in qs.docs) {
      String hi = element.get('horarioInicial');
      String hf = element.get('horarioFinal');
      int t = -1;
      int v = -1;
      print(int.parse(hi.substring(0, 2)).toString() + '+' + int.parse(hf.substring(0, 2)).toString());
      for (var i = int.parse(hi.substring(0, 2));
          i <= int.parse(hf.substring(0, 2));
          i++) {
        if (int.parse(hi.substring(3)) != 0 && t != 0) {
          t = int.parse(hi.substring(3));
        } else {
          t = 0;
        }
        if (i == int.parse(hf.substring(0, 2))) {
          v = int.parse(hf.substring(3)) + 1;
        }
        else {
          v = 60;
        }

        for (var j = t; j < v; j++) {
          for (var element in lista) {
            if (int.parse(element!.substring(0, 2)) == i && int.parse(element.substring(3)) == j){
              return true;
            }
          }
        }
        t = 0;
      }

    }

    return false;
  }

  @override
  Future<bool?> existeHorario(Map<String, dynamic>? horarioAgendado) async {
    String string = horarioAgendado?['data'];
    string = string.substring(0, 10);
    QuerySnapshot qs = await _firebasefirestore
        .collection("horáriosAgendados")
        .where('lab', isEqualTo: horarioAgendado?['lab'])
        .where('data', isEqualTo: string)
        .where('horarioInicial', isEqualTo: horarioAgendado?['horarioInicial'])
        .get();

    if (qs.size == 0) {
      return false;
    }
    return true;
  }

  @override
  Future<void> excluir(Map<String, dynamic>? horarioAgendado) async {
    QuerySnapshot qs = await _firebasefirestore
        .collection("horáriosAgendados")
        .where("nomeProfessor", isEqualTo: horarioAgendado?['nomeProfessor'])
        .where('lab', isEqualTo: horarioAgendado?['lab'])
        .where('data', isEqualTo: horarioAgendado?['data'])
        .where('horarioInicial', isEqualTo: horarioAgendado?['horarioInicial'])
        .where('isTemp', isEqualTo: horarioAgendado?['isTemp'])
        .where('id', isEqualTo: horarioAgendado?['id'])
        .get();

    await _firebasefirestore
        .collection("horáriosAgendados")
        .doc(qs.docs.last.id)
        .delete();
  }

  @override
  Future<int> incluir(Map<String, dynamic>? horarioAgendado) async {
    String string = horarioAgendado?['data'];
    string = string.substring(0, 10);
    _firebasefirestore.collection("horáriosAgendados").add({
      'id': horarioAgendado?['id'],
      'data': string,
      'lab': horarioAgendado?['lab'],
      'horarioInicial': horarioAgendado?['horarioInicial'],
      'horarioFinal': horarioAgendado?['horarioFinal'],
      'nomeProfessor': horarioAgendado?['nomeProfessor'],
      'isTemp': horarioAgendado?['isTemp'],
      'horarioAgendamento': horarioAgendado?['horarioAgendamento'],
      'emailProfessor': horarioAgendado?['emailProfessor'],
    });
    return horarioAgendado?['id'];
  }

  @override
  Future<Map<String, dynamic>?> selecionar(int id) async {}

  @override
  Future<List<Map<String, dynamic>?>?> selecionarTodos() async {
    var qs = await _firebasefirestore.collection('horáriosAgendados').get();
    return qs.docs
        .map((e) => HorarioAgendado(
                emailProfessor: e.data()['emailProfessor'],
                id: e.data()['id'],
                nomeProfessor: e.data()['nomeProfessor'],
                horarioInicial: e.data()['horarioInicial'],
                horarioFinal: e.data()['horarioFinal'],
                data: e.data()['data'],
                lab: e.data()['lab'],
                isTemp: e.data()['isTemp'],
                horarioAgendamento: e.data()['horarioAgendamento'])
            .toMap())
        .toList();
    
  }

  @override
  Future<List<Map<String, dynamic>?>?> selecionarTodosTemp() async {
    var qs = await _firebasefirestore.collection('horáriosAgendados').get();
    return qs.docs
        .map((e) => HorarioAgendado(
                emailProfessor: e.data()['emailProfessor'],
                id: e.data()['id'],
                nomeProfessor: e.data()['nomeProfessor'],
                horarioInicial: e.data()['horarioInicial'],
                horarioFinal: e.data()['horarioFinal'],
                data: e.data()['data'],
                lab: e.data()['lab'],
                isTemp: e.data()['isTemp'],
                horarioAgendamento: e.data()['horarioAgendamento'])
            .toMap())
        .toList();
  }
}
