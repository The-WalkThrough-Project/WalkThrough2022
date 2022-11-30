import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/timezone.dart';
import 'package:walkthrough/modules/agenda/controllers/controllerHorarioA.dart';
import 'package:walkthrough/modules/agenda/controllers/controllerHorarioF.dart';
import 'package:walkthrough/modules/agenda/models/horario_agendado_model.dart';
import 'package:walkthrough/modules/agenda/pages/horarios.dart';
import 'package:walkthrough/modules/loginProf/controllers/controller.dart';
import 'package:walkthrough/modules/loginProf/models/prof_model.dart';
import 'package:walkthrough/modules/agendamentos/pages/index.dart';
import 'package:walkthrough/shared/components/campo_form/campo_form.dart';
import 'package:walkthrough/shared/components/campo_form/campo_form_horario.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split('-')
      .map((str) => str.toCapitalized())
      .join('-');
}

class AgendaPage extends StatefulWidget {
  final UserProf usuario;

  const AgendaPage({Key? key, required this.usuario}) : super(key: key);

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  List<HorarioAgendado>? horariosTemp = [];
  final _controller = UserProfController();
  final _horariosAController = HorariosAgendadosController();
  final _horariosFController = HorarioController();
  DateTime hoje = DateTime.now();
  ValueListenable<Map<String, List<HorarioAgendado>>?> selectedHorarios =
      ValueNotifier({});
  Map<String, List<HorarioAgendado>>? selectedHorariosValue = {};
  bool carregando = false;

  DateTime _focusedDay = DateTime.now();
  late DateTime diaSelecionado;

  String dropdownValue = '304';

  getHorarios() async {
    setState(() {
      carregando = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    selectedHorarios = await _horariosAController.getHorariosA();
    if (!mounted) return;
    setState(() {
      selectedHorariosValue = selectedHorarios.value;
      selectedHorariosValue?.forEach((key, value) {
        String data2 = diaSelecionado.toString().substring(0, 10);
        value.sort((a, b) => int.parse(a.horarioInicial.substring(3, 4))
            .compareTo(int.parse(b.horarioInicial.substring(3, 4))));
        value.sort((a, b) => int.parse(a.horarioInicial.substring(0, 2))
            .compareTo(int.parse(b.horarioInicial.substring(0, 2))));
        value.sort((a, b) => a.lab.compareTo(b.lab));
      });
      String hora = '', minuto = '';
      TimeOfDay.now().hour >= 10
          ? hora = TimeOfDay.now().hour.toString()
          : hora = '0' + TimeOfDay.now().hour.toString();
      TimeOfDay.now().minute >= 10
          ? minuto = TimeOfDay.now().minute.toString()
          : minuto = '0' + TimeOfDay.now().minute.toString();
      _horariosAController.horarioInicial.text = (hora + ':' + minuto);
      _horariosAController.horarioFinal.text = (hora + ':' + minuto);
      _horariosAController.nomeProfessor.text = widget.usuario.nome ?? '';
      carregando = false;
    });
  }

  List<HorarioAgendado> _getEventsfromDay(DateTime data) {
    String data2 = data.toString().substring(0, 10);
    return selectedHorariosValue?[data2] ?? [];
  }

  @override
  void dispose() {
    !carregando ? _horariosAController.dispose() : null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    carregando = true;
    if (DateTime.now().weekday == DateTime.sunday) {
      diaSelecionado = DateTime.now().add(const Duration(days: 1));
    } else if (DateTime.now().weekday == DateTime.saturday) {
      diaSelecionado = DateTime.now().add(const Duration(days: 2));
    } else {
      diaSelecionado = DateTime.now();
    }
    getHorarios();
    _horariosAController.lab.text = dropdownValue;
    getHorarios();
  }

  Future<void> _navegaEAtualiza(BuildContext context) async {
    final bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotificacaoPage(
                  usuario: widget.usuario,
                )));
    result ? getHorarios() : null;

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: !carregando
            ? Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'Agenda dos laboratórios',
                    style: TextStyle(fontSize: 18),
                  ),
                  actions: !carregando
                      ? widget.usuario.tipoUsuario == 'Gerenciador'
                          ? [
                              FutureBuilder<List?>(
                                  future:
                                      _horariosAController.getHorariosATemp(),
                                  builder: (context, snapshot) {
                                    int tamanho = 0;
                                    if (snapshot.data != null) {
                                      tamanho = snapshot.data!.length;
                                    }
                                    return IconButton(
                                      onPressed: () {
                                        _navegaEAtualiza(context);
                                      },
                                      icon: Stack(
                                        children: [
                                          const Icon(
                                            Icons.notifications,
                                            color: Colors.white,
                                          ),
                                          tamanho > 0
                                              ? Positioned(
                                                  right: 0,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(1),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    constraints:
                                                        const BoxConstraints(
                                                      minWidth: 12,
                                                      minHeight: 12,
                                                    ),
                                                    child: Text(
                                                      '${snapshot.data?.length}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 8,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                )
                                              : const Padding(
                                                  padding: EdgeInsets.all(0)),
                                        ],
                                      ),
                                    );
                                  }),
                            ]
                          : null
                      : null,
                  bottom: const TabBar(
                    tabs: <Widget>[
                      Tab(
                        text: 'Agendamento',
                        height: 62,
                        icon: Icon(Icons.calendar_month),
                        iconMargin: EdgeInsets.only(bottom: 5),
                      ),
                      Tab(
                        iconMargin: EdgeInsets.only(bottom: 5),
                        text: 'Horários',
                        height: 62,
                        icon: Icon(Icons.access_time),
                      ),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    !carregando
                        ? Scaffold(
                            body: Center(
                                child: ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                            color: Colors.deepPurple, width: 2),
                                        borderRadius: BorderRadius.circular(15),
                                        color: const Color.fromARGB(
                                            255, 241, 238, 245)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        TableCalendar(
                                          daysOfWeekStyle:
                                              const DaysOfWeekStyle(
                                            weekdayStyle: TextStyle(
                                                color: Colors.deepPurple,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          headerStyle: const HeaderStyle(
                                              rightChevronVisible: false,
                                              leftChevronVisible: false,
                                              formatButtonVisible: false,
                                              titleCentered: true,
                                              headerPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 10)),
                                          eventLoader: _getEventsfromDay,
                                          availableCalendarFormats: const {
                                            CalendarFormat.month: 'Mês'
                                          },
                                          startingDayOfWeek:
                                              StartingDayOfWeek.sunday,
                                          calendarStyle: CalendarStyle(
                                            outsideDaysVisible: false,
                                            defaultTextStyle: const TextStyle(
                                                color: Colors.deepPurple),
                                            weekendTextStyle: const TextStyle(
                                                color: Colors.red),
                                            selectedDecoration: BoxDecoration(
                                                color: Colors.deepPurple,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: const Color.fromARGB(
                                                        255, 147, 118, 226),
                                                    width: 1.5)),
                                            todayDecoration:
                                                const BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 190, 172, 221),
                                                    shape: BoxShape.circle),
                                          ),
                                          locale: 'pt_BR',
                                          firstDay: firstDay(hoje),
                                          lastDay: lastDay(hoje),
                                          focusedDay: _focusedDay.weekday == 7
                                              ? _focusedDay.subtract(
                                                  const Duration(days: -1))
                                              : _focusedDay.weekday == 6
                                                  ? _focusedDay.subtract(
                                                      const Duration(days: -2))
                                                  : _focusedDay,
                                          calendarFormat: CalendarFormat.month,
                                          selectedDayPredicate: (hoje) {
                                            if (hoje.weekday !=
                                                    DateTime.sunday &&
                                                hoje.weekday !=
                                                    DateTime.saturday) {
                                              return isSameDay(
                                                  diaSelecionado, hoje);
                                            } else {
                                              return false;
                                            }
                                          },
                                          onDaySelected:
                                              (selectedDay, focusedDay) {
                                            if (!isSameDay(
                                                diaSelecionado, selectedDay)) {
                                              setState(() {
                                                if (selectedDay.weekday !=
                                                        DateTime.sunday &&
                                                    selectedDay.weekday !=
                                                        DateTime.saturday) {
                                                  diaSelecionado = selectedDay;
                                                  _focusedDay = focusedDay;
                                                }
                                              });
                                            }
                                          },
                                          onPageChanged: (focusedDay) {
                                            _focusedDay = focusedDay;
                                          },
                                          calendarBuilders: CalendarBuilders(
                                            singleMarkerBuilder:
                                                (context, date, _) {
                                              return Container(
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color.fromARGB(
                                                        255, 147, 118, 226)),
                                                width: 8.0,
                                                height: 8.0,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0.5),
                                              );
                                            },
                                            headerTitleBuilder: (context, day) {
                                              return Center(
                                                child: Text(
                                                  formatDate(day, ['MM'],
                                                          locale:
                                                              const PortugueseDateLocale()) +
                                                      ' de ' +
                                                      formatDate(day, ['yyyy']),
                                                  style: const TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              );
                                            },
                                            disabledBuilder:
                                                ((context, day, focusedDay) {
                                              String text = day.day.toString();
                                              return Center(
                                                  child: Text(
                                                text,
                                                style: const TextStyle(
                                                    color: Colors.red),
                                              ));
                                            }),
                                            dowBuilder: (context, day) {
                                              if (day.weekday ==
                                                  DateTime.sunday) {
                                                const text = "Dom";
                                                return const Center(
                                                  child: Text(
                                                    text,
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                );
                                              } else if (day.weekday ==
                                                  DateTime.saturday) {
                                                const text = "Sáb";
                                                return const Center(
                                                  child: Text(
                                                    text,
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                );
                                              } else if (day.weekday ==
                                                  DateTime.monday) {
                                                const text = "Seg";
                                                return const Center(
                                                  child: Text(
                                                    text,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.deepPurple,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                );
                                              } else if (day.weekday ==
                                                  DateTime.tuesday) {
                                                const text = "Ter";
                                                return const Center(
                                                  child: Text(
                                                    text,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.deepPurple,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                );
                                              } else if (day.weekday ==
                                                  DateTime.wednesday) {
                                                const text = "Qua";
                                                return const Center(
                                                  child: Text(
                                                    text,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.deepPurple,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                );
                                              } else if (day.weekday ==
                                                  DateTime.thursday) {
                                                const text = "Qui";
                                                return const Center(
                                                  child: Text(
                                                    text,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.deepPurple,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                );
                                              } else if (day.weekday ==
                                                  DateTime.friday) {
                                                const text = "Sex";
                                                return const Center(
                                                  child: Text(
                                                    text,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.deepPurple,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ..._getEventsfromDay(diaSelecionado).map(
                                    (HorarioAgendado horarioAgendado) =>
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              18, 0, 18, 4),
                                          child: Card(
                                            elevation: 10,
                                            color: Colors.deepPurple,
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 147, 118, 226),
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: InkWell(
                                              radius: 400,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              highlightColor:
                                                  const Color.fromARGB(
                                                          255, 152, 102, 240)
                                                      .withAlpha(60),
                                              splashColor: const Color.fromARGB(
                                                      255, 152, 102, 240)
                                                  .withAlpha(60),
                                              onTap: () {},
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              10, 0, 20, 0),
                                                      child: Icon(
                                                          Icons.calendar_month,
                                                          color: Colors.white),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Horário: ${horarioAgendado.horarioInicial} às ${horarioAgendado.horarioFinal}",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        Text(
                                                          "Professor(a): " +
                                                              horarioAgendado
                                                                  .nomeProfessor +
                                                              "\nLaboratório: " +
                                                              horarioAgendado
                                                                  .lab,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    199,
                                                                    199,
                                                                    199),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                const Padding(padding: EdgeInsets.all(50))
                              ],
                            )),
                            floatingActionButton: Padding(
                              padding: const EdgeInsets.only(bottom: 35),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 147, 118, 226),
                                        width: 2),
                                    borderRadius: BorderRadius.circular(200)),
                                child: FloatingActionButton.extended(
                                  elevation: 15,
                                  onPressed: () {
                                    showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(25.0),
                                          ),
                                        ),
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) {
                                          double? altura =
                                              MediaQuery.maybeOf(context)
                                                  ?.size
                                                  .height;
                                          return Container(
                                            height: altura != null
                                                ? altura * 0.7
                                                : 700,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  FocusScope.of(context)
                                                      .unfocus(),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        20, 20, 20, 0),
                                                    child: Center(
                                                      child: Text(
                                                        'Data: ' +
                                                            diaSelecionado.day
                                                                .toString() +
                                                            '/' +
                                                            diaSelecionado.month
                                                                .toString() +
                                                            '/' +
                                                            diaSelecionado.year
                                                                .toString(),
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .deepPurple,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        20, 20, 20, 10),
                                                    child: CampoForm(
                                                        label: "Seu nome",
                                                        controller:
                                                            _horariosAController
                                                                .nomeProfessor),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: Row(
                                                      children: [
                                                        const Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(27, 0,
                                                                    0, 0),
                                                            child: Text(
                                                                'Laboratório:',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .deepPurple,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14)),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20),
                                                            child:
                                                                StatefulBuilder(
                                                              builder: (context,
                                                                      setState) =>
                                                                  DropdownButton<
                                                                      String>(
                                                                value:
                                                                    dropdownValue,
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .expand_more_rounded,
                                                                  color: Colors
                                                                      .deepPurple,
                                                                ),
                                                                elevation: 10,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .deepPurple),
                                                                dropdownColor:
                                                                    Colors
                                                                        .white,
                                                                underline:
                                                                    Container(
                                                                  color: Colors
                                                                      .transparent,
                                                                ),
                                                                onChanged: (String?
                                                                    newValue) {
                                                                  setState(() {
                                                                    dropdownValue =
                                                                        newValue!;
                                                                    _horariosAController
                                                                            .lab
                                                                            .text =
                                                                        dropdownValue;
                                                                  });
                                                                },
                                                                items: <String>[
                                                                  '304',
                                                                  '602',
                                                                  '604',
                                                                  '606',
                                                                  '608',
                                                                  '609',
                                                                ].map<
                                                                    DropdownMenuItem<
                                                                        String>>((String
                                                                    value) {
                                                                  return DropdownMenuItem<
                                                                      String>(
                                                                    value:
                                                                        value,
                                                                    child: Text(
                                                                        value),
                                                                  );
                                                                }).toList(),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                              'Horário inicial da aula:',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .deepPurple,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        15,
                                                                        10,
                                                                        20,
                                                                        0),
                                                                child:
                                                                    CampoFormHorario(
                                                                  horario:
                                                                      'inicial',
                                                                  controller:
                                                                      _horariosAController
                                                                          .horarioInicial,
                                                                  controller2:
                                                                      _horariosAController
                                                                          .horarioFinal,
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                                'Horário final da aula:',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .deepPurple,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14)),
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        5,
                                                                        10,
                                                                        0,
                                                                        0),
                                                                child:
                                                                    CampoFormHorario(
                                                                  horario:
                                                                      'final',
                                                                  controller:
                                                                      _horariosAController
                                                                          .horarioFinal,
                                                                  controller2:
                                                                      _horariosAController
                                                                          .horarioInicial,
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 20, 20, 0),
                                                    child: Center(
                                                      child: Text(
                                                        'Lembre-se de verificar se o laboratório selecionado está livre na data e no horário desejado!',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 20, 0, 10),
                                                    child: Center(
                                                      child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              side: const BorderSide(
                                                                  color: Colors
                                                                      .deepPurple),
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            if (_horariosAController.nomeProfessor.text.isEmpty ||
                                                                _horariosAController
                                                                    .horarioInicial
                                                                    .text
                                                                    .isEmpty ||
                                                                _horariosAController
                                                                    .horarioFinal
                                                                    .text
                                                                    .isEmpty) {
                                                              MotionToast.error(
                                                                title:
                                                                    const Text(
                                                                  'Erro',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                description:
                                                                    const Text(
                                                                        "Preencha todos os campos!"),
                                                                animationType:
                                                                    AnimationType
                                                                        .fromLeft,
                                                                position:
                                                                    MotionToastPosition
                                                                        .top,
                                                                barrierColor: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.3),
                                                                width: 300,
                                                                height: 80,
                                                                dismissable:
                                                                    true,
                                                              ).show(context);
                                                            } else if (await confirm(
                                                              context,
                                                              title: const Text(
                                                                'Confirmação',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .deepPurple),
                                                              ),
                                                              content:
                                                                  const Text(
                                                                'Você tem certeza?',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .deepPurple),
                                                              ),
                                                              textOK:
                                                                  const Text(
                                                                'Sim',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .green),
                                                              ),
                                                              textCancel:
                                                                  const Text(
                                                                'Não',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                            )) {
                                                              var horarioC = HorarioAgendado(
                                                                  emailProfessor: widget
                                                                          .usuario
                                                                          .email ??
                                                                      '',
                                                                  horarioAgendamento: formatDate(
                                                                      DateTime
                                                                          .now(),
                                                                      [
                                                                        dd,
                                                                        ' de ',
                                                                        MM,
                                                                        ' às ',
                                                                        HH,
                                                                        ':',
                                                                        nn,
                                                                        ':',
                                                                        ss
                                                                      ],
                                                                      locale:
                                                                          const PortugueseDateLocale()),
                                                                  nomeProfessor:
                                                                      _horariosAController
                                                                          .nomeProfessor
                                                                          .text
                                                                          .trim(),
                                                                  horarioInicial:
                                                                      _horariosAController
                                                                          .horarioInicial
                                                                          .text
                                                                          .trim(),
                                                                  horarioFinal:
                                                                      _horariosAController
                                                                          .horarioFinal
                                                                          .text
                                                                          .trim(),
                                                                  lab: _horariosAController
                                                                      .lab.text
                                                                      .trim(),
                                                                  data: diaSelecionado
                                                                      .toString(),
                                                                  isTemp: 1);
                                                              String? valida =
                                                                  _horariosAController
                                                                      .horarioIsValid(
                                                                          horarioC);
                                                              if (valida !=
                                                                  null) {
                                                                MotionToast
                                                                    .error(
                                                                  title:
                                                                      const Text(
                                                                    'Erro',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  description:
                                                                      Text(
                                                                          valida),
                                                                  animationType:
                                                                      AnimationType
                                                                          .fromLeft,
                                                                  position:
                                                                      MotionToastPosition
                                                                          .top,
                                                                  barrierColor: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.3),
                                                                  width: 300,
                                                                  height: 80,
                                                                  dismissable:
                                                                      true,
                                                                ).show(context);
                                                              } else if (await _horariosAController
                                                                      .existeHorario(
                                                                          horarioC) ||
                                                                  await _horariosFController.existeHorario(
                                                                      horarioC,
                                                                      DateFormat(
                                                                              'EEEE',
                                                                              'pt_Br')
                                                                          .format(
                                                                              diaSelecionado)
                                                                          .toTitleCase())) {
                                                                MotionToast
                                                                    .error(
                                                                  title:
                                                                      const Text(
                                                                    'Erro',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  description:
                                                                      const Text(
                                                                          "Este laboratório já está ocupado no dia e horário indicados!"),
                                                                  animationType:
                                                                      AnimationType
                                                                          .fromLeft,
                                                                  position:
                                                                      MotionToastPosition
                                                                          .top,
                                                                  barrierColor: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.3),
                                                                  width: 300,
                                                                  height: 80,
                                                                  dismissable:
                                                                      true,
                                                                ).show(context);
                                                              } else {
                                                                _horariosAController
                                                                    .cadastraHorarios(
                                                                        horarioC);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        const SnackBar(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          2500),
                                                                  behavior:
                                                                      SnackBarBehavior
                                                                          .fixed,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .deepPurple,
                                                                  content: Text(
                                                                    'Solicitação realizada com sucesso!',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ));
                                                                setState(() {
                                                                  getHorarios();
                                                                  _horariosAController
                                                                      .nomeProfessor
                                                                      .clear();
                                                                  _horariosAController
                                                                      .horarioInicial
                                                                      .clear();
                                                                  _horariosAController
                                                                      .horarioFinal
                                                                      .clear();
                                                                  dropdownValue =
                                                                      '304';
                                                                  _horariosAController
                                                                          .lab
                                                                          .text =
                                                                      dropdownValue;
                                                                });
                                                              }
                                                            }
                                                            return;
                                                          },
                                                          child: const Text(
                                                              'Agendar')),
                                                    ),
                                                  ),
                                                  const Center(
                                                    child: Text.rich(
                                                      TextSpan(
                                                          text:
                                                              'Em caso de dúvida entre em contato pelo e-mail ',
                                                          children: <
                                                              InlineSpan>[
                                                            TextSpan(
                                                                text:
                                                                    'raulivan@cefetmg.br',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ]),
                                                      style: TextStyle(
                                                          color:
                                                              Colors.deepPurple,
                                                          fontSize: 12),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  label: const Text(
                                      "Solicitar Agendamento de Horário"),
                                  icon: const Icon(Icons.add),
                                  extendedIconLabelSpacing: 10,
                                  backgroundColor: Colors.deepPurple,
                                ),
                              ),
                            ),
                            floatingActionButtonLocation:
                                FloatingActionButtonLocation.centerFloat,
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                            color: Colors.deepPurple,
                          )),
                    !carregando
                        ? HorariosPage(user: widget.usuario)
                        : const Center(
                            child: CircularProgressIndicator(
                            color: Colors.deepPurple,
                          ))
                  ],
                ),
              )
            : Scaffold(
                body: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      color: Colors.deepPurple,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Carregando...',
                        style:
                            TextStyle(color: Colors.deepPurple, fontSize: 18),
                      ),
                    )
                  ],
                )),
              ));
  }

  DateTime firstDay(DateTime dateTime) {
    if (dateTime.weekday == 7) {
      return dateTime.subtract(const Duration(days: -1));
    } else if (dateTime.weekday == 6) {
      return dateTime.subtract(const Duration(days: -2));
    } else {
      return dateTime;
    }
  }

  DateTime lastDay(DateTime dateTime) {
    if (dateTime.subtract(const Duration(days: -30)).weekday == 7) {
      return dateTime.subtract(const Duration(days: -28));
    } else if (dateTime.subtract(const Duration(days: -30)).weekday == 6) {
      return dateTime.subtract(const Duration(days: -29));
    } else {
      return dateTime.subtract(const Duration(days: -30));
    }
  }
}
