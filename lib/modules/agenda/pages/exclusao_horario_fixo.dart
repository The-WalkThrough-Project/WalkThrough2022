import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:walkthrough/modules/agenda/controllers/controllerHorarioF.dart';
import 'package:walkthrough/shared/components/campo_form/campo_form.dart';
import 'package:walkthrough/shared/databases/BD.dart';
import 'dart:ui';

class ExcluiHF extends StatefulWidget {
  final String lab;

  const ExcluiHF({Key? key, required this.lab}) : super(key: key);

  @override
  State<ExcluiHF> createState() => _ExcluiHFState();
}

class _ExcluiHFState extends State<ExcluiHF> {
  final _controller = HorarioController();
  String valorHorario = '';
  String valorDia = '';
  String valorLab = '';

  @override
  void initState() {
    super.initState();
    valorDia = 'Segunda-Feira';
    valorHorario = '07:00 - 08:40 : 1M2M';
    valorLab = widget.lab;
    _controller.lab.text = widget.lab;
    _controller.diaSemana.text = valorDia;
    _controller.horario.text = valorHorario.substring(16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Exclusão de Horários Fixos",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            child: ListView(
          children: [
            Row(
              children: [
                const Expanded(
                    child: Text(
                  "Horário: ",
                  style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  textAlign: TextAlign.end,
                )),
                Expanded(
                  flex: 2,
                  child: DropdownButton<String>(
                    value: valorHorario,
                    items: <String>[
                      '07:00 - 08:40 : 1M2M',
                      '08:55 - 10:35 : 3M4M',
                      '10:50 - 12:30 : 5M6M',
                      '13:50 - 15:30 : 1T2T',
                      '15:50 - 17:30 : 3T4T',
                      '16:40 - 18:20 : 4T5T',
                      '19:00 - 20:40 : 1N2N',
                      '20:55 - 22:35 : 3N4N',
                    ].map<DropdownMenuItem<String>>((String valor1) {
                      return DropdownMenuItem<String>(
                        value: valor1,
                        child: Text(valor1),
                      );
                    }).toList(),
                    onChanged: (String? novoValor) {
                      setState(() {
                        valorHorario = novoValor ?? '';
                        _controller.horario.text = valorHorario.substring(16);
                      });
                    },
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
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                    child: Text(
                  "Laboratório: ",
                  style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  textAlign: TextAlign.end,
                )),
                Expanded(
                  flex: 2,
                  child: DropdownButton<String>(
                    value: valorLab,
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
                    onChanged: (String? novoValor) {
                      setState(() {
                        valorLab = novoValor ?? '';
                        _controller.lab.text = valorLab;
                      });
                    },
                    items: <String>[
                      '304',
                      '602',
                      '604',
                      '606',
                      '608',
                      '609',
                    ].map<DropdownMenuItem<String>>((String valor2) {
                      return DropdownMenuItem<String>(
                        value: valor2,
                        child: Text(valor2),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                    child: Text(
                  "Dia da Semana: ",
                  style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  textAlign: TextAlign.end,
                )),
                Expanded(
                  flex: 2,
                  child: DropdownButton<String>(
                    value: valorDia,
                    items: <String>[
                      'Segunda-Feira',
                      'Terça-Feira',
                      'Quarta-Feira',
                      'Quinta-Feira',
                      'Sexta-Feira',
                    ].map<DropdownMenuItem<String>>((String valor3) {
                      return DropdownMenuItem<String>(
                        value: valor3,
                        child: Text(valor3),
                      );
                    }).toList(),
                    onChanged: (String? novoValor) {
                      setState(() {
                        valorDia = novoValor ?? '';
                        _controller.diaSemana.text = valorDia;
                      });
                    },
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
                  ),
                ),
              ],
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.redAccent),
                onPressed: () async {
                  if (await confirm(
                    context,
                    title: const Text(
                      'Confirmação',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                    content: const Text(
                      'Você tem certeza de que deseja excluir este horário?',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                    textOK: const Text(
                      'Sim',
                      style: TextStyle(color: Colors.green),
                    ),
                    textCancel: const Text(
                      'Não',
                      style: TextStyle(color: Colors.red),
                    ),
                  )) {
                    _controller.excluirHorario(sucesso: () {
                      _controller.attTabelasHorarios();
                      Navigator.pop(context, true);
                      MotionToast.success(
                        title: const Text(
                          'Sucesso!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        description:
                            const Text('Horário excluído com sucesso!'),
                        animationType: AnimationType.fromLeft,
                        position: MotionToastPosition.top,
                        barrierColor: Colors.black.withOpacity(0.3),
                        width: 300,
                        height: 80,
                        dismissable: true,
                      ).show(context);
                    }, falha: (motivo) {
                      MotionToast.error(
                        title: const Text(
                          'Erro',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        description: Text(motivo),
                        animationType: AnimationType.fromLeft,
                        position: MotionToastPosition.top,
                        barrierColor: Colors.black.withOpacity(0.3),
                        width: 300,
                        height: 80,
                        dismissable: true,
                      ).show(context);
                    });
                  }
                },
                child: const Text("Excluir"))
          ],
        )),
      ),
    );
  }
}
