import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:walkthrough/modules/agenda/repositories/datasources/datasource_ds_fixo.dart';
import 'package:walkthrough/shared/databases/BD.dart';
import 'package:walkthrough/shared/providers/horario_agendado_to_fixo.dart';

class FirebaseDataSource extends DataSourceBaseF {
  final FirebaseFirestore _firebasefirestore = FirebaseFirestore.instance;
  final _bancoSQL = BancoHorarios.instance;

  @override
  Future<bool?> existeHorario(Map<String, dynamic>? horarioAgendado, String dia) async{
    List<String?>? lista = [];
    int g = -1;
    int h = - 1;
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
        .collection("horáriosFixos")
        .where('lab', isEqualTo: horarioAgendado?['lab'])
        .where('diaSemana', isEqualTo: dia)
        .get();

    for (var element in qs.docs) {
      String horarioRange = horarioAtoF(element.get('horario'));
      String hi = horarioRange.split('.')[0];
      String hf = horarioRange.split('.')[1];
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
              print(i.toString() + ':' + j.toString());
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
  Future<void> alterar(Map<String, dynamic> horarioFixo) async {
    QuerySnapshot qs = await _firebasefirestore
        .collection("horáriosFixos")
        .where("diaSemana", isEqualTo: horarioFixo['diaSemana'])
        .where('lab', isEqualTo: horarioFixo['lab'])
        .where('horario', isEqualTo: horarioFixo['horario'])
        .get();

    await _firebasefirestore
        .collection("horáriosFixos")
        .doc(qs.docs.last.id)
        .update(horarioFixo);
  }

  @override
  Future<void> excluir(Map<String, dynamic> horarioFixo) async {
    QuerySnapshot qs = await _firebasefirestore
        .collection("horáriosFixos")
        .where("diaSemana", isEqualTo: horarioFixo['diaSemana'])
        .where('lab', isEqualTo: horarioFixo['lab'])
        .where('horario', isEqualTo: horarioFixo['horario'])
        .get();

    await _firebasefirestore
        .collection("horáriosFixos")
        .doc(qs.docs.last.id)
        .delete();
  }

  @override
  Future<void> incluir(Map<String, dynamic> horarioFixo) async {
    QuerySnapshot qs = await _firebasefirestore
        .collection("horáriosFixos")
        .where('diaSemana', isEqualTo: horarioFixo['diaSemana'])
        .where('lab', isEqualTo: horarioFixo['lab'])
        .where('horario', isEqualTo: horarioFixo['horario']).get();

    qs.docs.length > 0 ? _firebasefirestore
        .collection("horáriosFixos")
        .doc(qs.docs.last.id)
        .update(horarioFixo) :
    _firebasefirestore.collection("horáriosFixos").add({
      'diaSemana': horarioFixo['diaSemana'],
      'lab': horarioFixo['lab'],
      'horario': horarioFixo['horario'],
      'nomeDisciplina': horarioFixo['nomeDisciplina'],
      'nomeProfessor': horarioFixo['nomeProfessor'],
    });
  }

  @override
  Future<Map<String, dynamic>?> selecionar(
      String lab, String diaSemana, String horario) async {}

  @override
  Future<List<Map<String, dynamic>>?> selecionarTodos() async {}

  @override
  Future<Query<Map<String, dynamic>>> selecionarTodosPLab(String lab) async {
    return await _firebasefirestore.collection("horáriosFixos").where('lab', isEqualTo: lab);
  }
  
  @override
  Future<String?> getAttTabelasHorarios() async{
    var ds = await _firebasefirestore.collection('attTabelasHorarios').doc('8GmeRFSzhN4X8wqTQeeg').get();
    if (ds.exists) {
      return ds.data()?['data'];
    }
  }
  
  @override
  Future<void> attTabelasHorarios(String data) async{
    Map<String, dynamic> attTabelasHorariosF = {
      'data': data
    };
    await _firebasefirestore.collection('attTabelasHorarios').doc('8GmeRFSzhN4X8wqTQeeg').update(attTabelasHorariosF);
  }
}
