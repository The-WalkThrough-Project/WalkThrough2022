import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:walkthrough/modules/agenda/models/horario_fixo_model.dart';
import 'package:walkthrough/shared/components/botao_horario/celula_horario.dart';

class TabelaHorarios extends StatefulWidget {
  /*final String? content1;
  final String? content2;
  final double? width;
  final double? height;*/
  final String lab;
  final String diaSemana;
  final List horarios;
  final bool? zoom;

  const TabelaHorarios({Key? key, required this.lab, required this.diaSemana, required this.horarios, this.zoom}) : super(key: key);

  @override
  State<TabelaHorarios> createState() => _TabelaHorariosState();
}

class _TabelaHorariosState extends State<TabelaHorarios> {
  Widget titulo(String titulo) {
    return Text(
      titulo,
      style: TextStyle(
          color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 20),
      textAlign: TextAlign.center,
    );
  }

  Map<String, dynamic> retornaHorarios(String horarioT, String diaSemana, String lab){
    for(var horario in widget.horarios){
        if(horario.data()!['horario'] == horarioT && horario.data()!['diaSemana'] == diaSemana && horario.data()!['lab'] == lab){
          return horario.data();
        }
    }
    return {};
  }

  int primeiroOuSegundoHorariodeTarde(String diaSemana){
    for(var horario in widget.horarios){
        if(horario.data()!['horario'] == "3T4T" && horario.data()!['diaSemana'] == diaSemana){
          return 1;
        } else if(horario.data()!['horario'] == "4T5T" && horario.data()!['diaSemana'] == diaSemana){
          return 2;
        } 
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: widget.zoom ?? false ? Colors.white : null,
                    border: Border.all(color: Colors.deepPurple, width: 2),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 2),
                    child: titulo(
                      widget.diaSemana.contains("Segunda") ? "SEGUNDA-FEIRA" : 
                        widget.diaSemana.contains("Terça") ? "TERÇA-FEIRA" :
                          widget.diaSemana.contains("Quarta") ? "QUARTA-FEIRA" :
                            widget.diaSemana.contains("Quinta") ? "QUINTA-FEIRA" :
                              widget.diaSemana.contains("Sexta") ? "SEXTA-FEIRA" : ""
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CelulaHorario(
                        content1: "1M",
                        content2: "7:00\n7:50",
                      ),
                      CelulaHorario(
                        content1: "2M",
                        content2: "7:50\n8:40",
                      ),
                      CelulaHorario(
                        content1: "--",
                        content2: "8:40\n8:55",
                      ),
                      CelulaHorario(
                        content1: "3M",
                        content2: "8:55\n9:45",
                      ),
                      CelulaHorario(
                        content1: "4M",
                        content2: "9:45\n10:35",
                      ),
                      CelulaHorario(
                        content1: "--",
                        content2: "10:35\n10:50",
                      ),
                      CelulaHorario(
                        content1: "5M",
                        content2: "10:50\n11:40",
                      ),
                      CelulaHorario(
                        content1: "6M",
                        content2: "11:40\n12:30",
                      ),
                      CelulaHorario(
                        content1: "--",
                        content2: "12:30\n13:50",
                      ),
                      CelulaHorario(
                        content1: "1T",
                        content2: "13:50\n14:40",
                      ),
                      CelulaHorario(
                        content1: "2T",
                        content2: "14:40\n15:30",
                      ),
                      CelulaHorario(
                        content1: "--",
                        content2: "15:30\n15:50",
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CelulaHorario(
                        width: 60,
                        content1: retornaHorarios("1M2M", widget.diaSemana, widget.lab)['nomeProfessor'],
                        content2: retornaHorarios("1M2M", widget.diaSemana, widget.lab)['nomeDisciplina'],
                      ),
                      CelulaHorario(),
                      CelulaHorario(
                        width: 60,
                        content1: retornaHorarios("3M4M", widget.diaSemana, widget.lab)['nomeProfessor'],
                        content2: retornaHorarios("3M4M", widget.diaSemana, widget.lab)['nomeDisciplina'],
                      ),
                      CelulaHorario(),
                      CelulaHorario(
                        width: 60,
                        content1: retornaHorarios("5M6M", widget.diaSemana, widget.lab)['nomeProfessor'],
                        content2: retornaHorarios("5M6M", widget.diaSemana, widget.lab)['nomeDisciplina'],
                      ),
                      CelulaHorario(),
                      CelulaHorario(
                        width: 60,
                        content1: retornaHorarios("1T2T", widget.diaSemana, widget.lab)['nomeProfessor'],
                        content2: retornaHorarios("1T2T", widget.diaSemana, widget.lab)['nomeDisciplina'],
                      ),
                      CelulaHorario()
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(2)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CelulaHorario(
                        content1: "3T",
                        content2: "15:50\n16:40",
                      ),
                      CelulaHorario(
                        content1: "4T",
                        content2: "16:40\n17:30",
                      ),
                      CelulaHorario(
                        content1: "5T",
                        content2: "17:30\n18:20",
                      ),
                      CelulaHorario(
                        content1: "--",
                        content2: "18:20\n19:00",
                      ),
                      CelulaHorario(
                        content1: "1N",
                        content2: "19:00\n19:50",
                      ),
                      CelulaHorario(
                        content1: "2N",
                        content2: "19:50\n20:40",
                      ),
                      CelulaHorario(
                        content1: "--",
                        content2: "20:40\n20:55",
                      ),
                      CelulaHorario(
                        content1: "3N",
                        content2: "20:55\n21:45",
                      ),
                      CelulaHorario(
                        content1: "4N",
                        content2: "21:45\n22:35",
                      ),
                      CelulaHorario(width: 90),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      primeiroOuSegundoHorariodeTarde(widget.diaSemana) == 1 ?
                        Row(
                          children: [
                            CelulaHorario(
                              width: 60,
                              content1: retornaHorarios("3T4T", widget.diaSemana, widget.lab)['nomeProfessor'],
                              content2: retornaHorarios("3T4T", widget.diaSemana, widget.lab)['nomeDisciplina'],
                            ),
                            CelulaHorario(),
                          ],
                        ) : primeiroOuSegundoHorariodeTarde(widget.diaSemana) == 2 ?
                        Row(
                          children: [
                            CelulaHorario(),
                            CelulaHorario(
                              width: 60,
                              content1: retornaHorarios("4T5T", widget.diaSemana, widget.lab)['nomeProfessor'],
                              content2: retornaHorarios("4T5T", widget.diaSemana, widget.lab)['nomeDisciplina'],
                            ),
                          ],
                        ) : CelulaHorario(
                              width: 90,
                              content1: "",
                              content2: "",
                            ),
                      CelulaHorario(),
                      CelulaHorario(
                        width: 60,
                        content1: retornaHorarios("1N2N", widget.diaSemana, widget.lab)['nomeProfessor'],
                        content2: retornaHorarios("1N2N", widget.diaSemana, widget.lab)['nomeDisciplina'],
                      ),
                      CelulaHorario(),
                      CelulaHorario(
                        width: 60,
                        content1: retornaHorarios("3N4N", widget.diaSemana, widget.lab)['nomeProfessor'],
                        content2: retornaHorarios("3N4N", widget.diaSemana, widget.lab)['nomeDisciplina'],
                      ),
                      CelulaHorario(width: 90),
                    ],
                  ),
                ]),
              ),
    );
  }
}