import 'package:flutter/material.dart';

class CampoFormHorario extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController controller2;
  final String horario;

  const CampoFormHorario(
      {Key? key, required this.controller, required this.horario, required this.controller2})
      : super(key: key);

  @override
  State<CampoFormHorario> createState() => _CampoFormHorarioState();
}

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

class _CampoFormHorarioState extends State<CampoFormHorario> {
  
  String format(BuildContext context, TimeOfDay _timeOfDay) {
      assert(debugCheckHasMediaQuery(context));
      assert(debugCheckHasMaterialLocalizations(context));
      final MaterialLocalizations localizations =
          MaterialLocalizations.of(context);
      return localizations.formatTimeOfDay(
        _timeOfDay,
        alwaysUse24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
      );
    }

  TimeOfDay _timeOfDay = const TimeOfDay(hour: 7, minute: 0);

  void _showTimePicker() {
    showTimePicker(
        helpText: 'SELECIONE UM HORÁRIO',
        cancelText: 'CANCELAR',
        confirmText: 'CONFIRMAR',
        hourLabelText: 'Hora',
        minuteLabelText: 'Minuto',
        errorInvalidText: 'Insira um valor válido',
        context: context,
        initialTime: TimeOfDay(hour:int.parse(widget.controller.text.split(":")[0]),minute: int.parse(widget.controller.text.split(":")[1])),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child ?? Container(),
          );
        }).then((value) {
      setState(() {
        _timeOfDay = value ?? TimeOfDay.now();
        widget.controller.text = _timeOfDay.to24hours();
        if (widget.horario == 'inicial') {
          int h = _timeOfDay.hour;
          int m = _timeOfDay.minute;
          int somaH = 1;
          int somaM = 40;
          if (somaM + m <= 59) {
            
          } else {
            int soma = somaM + m;
            somaH = 2;
            somaM = - (m - (soma - 60));
          }
          if (somaH + h <= 23) {
            
          } else{
            int soma = somaH + h;
            somaH = - (soma - (somaH + 1));
          }


          widget.controller2.text = _timeOfDay.replacing(hour: _timeOfDay.hour + somaH, minute: _timeOfDay.minute + somaM).to24hours();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showTimePicker,
      child: Container(
        width: 150,
        child: TextFormField(
          controller: widget.controller,
          style: TextStyle(
              fontSize: 15,
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold),
          decoration: InputDecoration(
              hintStyle: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 139, 108, 192),
                  fontWeight: FontWeight.bold),
              suffixIcon: Container(
                margin: EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: Colors.deepPurple))),
                child: IconButton(
                    onPressed: _showTimePicker,
                    icon: Icon(
                      Icons.timer,
                      color: Colors.deepPurple,
                    )),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.deepPurple)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.deepPurple))),
          readOnly: true,
        ),
      ),
    );
  }
}