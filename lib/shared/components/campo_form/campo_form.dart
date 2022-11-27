import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CampoForm extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  const CampoForm({Key? key, required this.label, required this.controller}) : super(key: key);

  @override
  State<CampoForm> createState() => _CampoFormState();
}

class _CampoFormState extends State<CampoForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextFormField(
                inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(
                    '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'))
              ],
                style: TextStyle(color: Colors.deepPurple),
                  decoration: InputDecoration(
                    floatingLabelStyle: TextStyle(color: Colors.deepPurple),
                    labelText: widget.label,
                    labelStyle:
                        const TextStyle(color: Color.fromARGB(255, 166, 140, 211)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 144, 117, 189)),
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  controller: widget.controller),
            );
  }
}