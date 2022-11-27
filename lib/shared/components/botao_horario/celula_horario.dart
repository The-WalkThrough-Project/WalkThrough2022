import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CelulaHorario extends StatefulWidget {
  final String? content1;
  final String? content2;
  final double? width;
  final double? height;
  final String? lab;
  final String? diaSemana;

  CelulaHorario(
      {Key? key,
      this.content1,
      this.content2,
      this.width,
      this.height,
      this.lab,
      this.diaSemana})
      : super(key: key);

  @override
  State<CelulaHorario> createState() => _CelulaHorarioState();
}

class _CelulaHorarioState extends State<CelulaHorario> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 30,
      height: widget.height ?? 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.content1 ?? "",
            style: TextStyle(
                fontSize: widget.content2 != null
                    ? widget.content2!.contains(":")
                        ? 10
                        : widget.content1!.contains('/') ?
                        8 
                        : 12
                    : 12,
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold),
          ),
          widget.content2 == null
              ? const Padding(padding: const EdgeInsets.all(0))
              : Text(
                  widget.content2 ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: widget.content2!.contains(":") ? 5 : 9,
                      color: Colors.deepPurple),
                ),
        ],
      ),
    );
  }
}
