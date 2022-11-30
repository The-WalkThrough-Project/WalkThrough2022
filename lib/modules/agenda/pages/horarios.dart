import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:walkthrough/modules/agenda/controllers/controllerHorarioF.dart';
import 'package:walkthrough/modules/agenda/models/horario_fixo_model.dart';
import 'package:walkthrough/modules/agenda/pages/cadastro_horario_fixo.dart';
import 'package:walkthrough/modules/agenda/pages/exclusao_horario_fixo.dart';
import 'package:walkthrough/modules/loginProf/models/prof_model.dart';
import 'package:walkthrough/shared/components/tabela_horario_dia/tabelaHorario.dart';
import 'package:walkthrough/shared/databases/BD.dart';

class HorariosPage extends StatefulWidget {
  final UserProf user;

  const HorariosPage({Key? key, required this.user}) : super(key: key);

  @override
  State<HorariosPage> createState() => _HorariosPageState();
}

class _HorariosPageState extends State<HorariosPage> {
  String dropdownValue = 'Lab 304';
  String? attTabelasHorarios = '';
  late List<HorarioFixo>? horarios = [];
  bool isLoading = false;
  final _controller = HorarioController();

  @override
  void initState() {
    super.initState();
    refreshHorarios();
  }

  Future refreshHorarios() async {
    setState(() {
      isLoading = true;
    });

    attTabelasHorarios = await _controller.getAttTabelasHorarios();
    horarios = await _controller.getHorariosF(dropdownValue.substring(4));
    setState(() {
      horarios;
    });

    setState(() {
      isLoading = false;
    });
  }

  Widget titulo(String titulo) {
    return Text(
      titulo,
      style: const TextStyle(
          color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 20),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    double? largura = MediaQuery.maybeOf(context)?.size.width;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("horáriosFixos")
            .where('lab', isEqualTo: dropdownValue.substring(4))
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 15, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Selecione um laboratório: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      ),
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(
                          Icons.expand_more_rounded,
                          color: Colors.deepPurple,
                        ),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        dropdownColor: Colors.white,
                        underline: Container(
                          color: Colors.transparent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue ?? '';
                            refreshHorarios();
                          });
                        },
                        items: <String>[
                          'Lab 304',
                          'Lab 602',
                          'Lab 604',
                          'Lab 606',
                          'Lab 608',
                          'Lab 609',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: widget.user.tipoUsuario == 'Gerenciador'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      backgroundColor: Colors.lightGreen),
                                  onPressed: () async {
                                    var result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) => CadastroHF(
                                                lab: dropdownValue
                                                    .substring(4)))));
                                    result == true ? refreshHorarios() : null;
                                  },
                                  child: const Text("CADASTRAR/ATUALIZAR")),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      backgroundColor: Colors.redAccent),
                                  onPressed: () async {
                                    var result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) => ExcluiHF(
                                                lab: dropdownValue
                                                    .substring(4)))));
                                    result == true ? refreshHorarios() : null;
                                  },
                                  child: const Text("EXCLUIR")),
                            ],
                          )
                        : null),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 9, 0, 12),
                  child: Text(
                    'Atualizado em: $attTabelasHorarios',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    textAlign: TextAlign.center,
                  ),
                ),        
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 9, 0, 12),
                  child: Text(
                    'Clique nas tabelas para ampliá-las com o gesto de pinça:',
                    style: TextStyle(
                        color: Colors.deepPurple),
                    textAlign: TextAlign.center,
                  ),
                ),
                snapshot.hasData && isLoading == false
                    ? Column(children: [
                        GestureDetector(
                          onTap: () => showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                  child: Container(
                                    height: 207,
                                    width:
                                        largura != null ? largura * 0.95 : 300,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: InteractiveViewer(
                                      child: TabelaHorarios(
                                        diaSemana: "Segunda-Feira",
                                        horarios: snapshot.data.docs ?? [],
                                        lab: dropdownValue.substring(4),
                                        zoom: true,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          child: TabelaHorarios(
                            diaSemana: "Segunda-Feira",
                            horarios: snapshot.data.docs ?? [],
                            lab: dropdownValue.substring(4),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                  child: Container(
                                    height: 207,
                                    width:
                                        largura != null ? largura * 0.95 : 300,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: InteractiveViewer(
                                      child: TabelaHorarios(
                                        diaSemana: "Terça-Feira",
                                        horarios: snapshot.data.docs ?? [],
                                        lab: dropdownValue.substring(4),
                                        zoom: true,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          child: TabelaHorarios(
                            diaSemana: "Terça-Feira",
                            horarios: snapshot.data.docs ?? [],
                            lab: dropdownValue.substring(4),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                  child: Container(
                                    height: 207,
                                    width:
                                        largura != null ? largura * 0.95 : 300,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: InteractiveViewer(
                                      child: TabelaHorarios(
                                        diaSemana: "Quarta-Feira",
                                        horarios: snapshot.data.docs ?? [],
                                        lab: dropdownValue.substring(4),
                                        zoom: true,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          child: TabelaHorarios(
                            diaSemana: "Quarta-Feira",
                            horarios: snapshot.data.docs ?? [],
                            lab: dropdownValue.substring(4),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                  child: Container(
                                    height: 207,
                                    width:
                                        largura != null ? largura * 0.95 : 300,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: InteractiveViewer(
                                      child: TabelaHorarios(
                                        diaSemana: "Quinta-Feira",
                                        horarios: snapshot.data.docs ?? [],
                                        lab: dropdownValue.substring(4),
                                        zoom: true,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          child: TabelaHorarios(
                            diaSemana: "Quinta-Feira",
                            horarios: snapshot.data.docs ?? [],
                            lab: dropdownValue.substring(4),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                  child: Container(
                                    height: 207,
                                    width:
                                        largura != null ? largura * 0.95 : 300,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: InteractiveViewer(
                                      child: TabelaHorarios(
                                        diaSemana: "Sexta-Feira",
                                        horarios: snapshot.data.docs ?? [],
                                        lab: dropdownValue.substring(4),
                                        zoom: true,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          child: TabelaHorarios(
                            diaSemana: "Sexta-Feira",
                            horarios: snapshot.data.docs ?? [],
                            lab: dropdownValue.substring(4),
                          ),
                        ),
                      ])
                    : const Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
                        ),
                      )
              ]));
        });
  }
}
