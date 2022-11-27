import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:walkthrough/modules/agenda/models/horario_agendado_model.dart';
import 'package:walkthrough/modules/agenda/models/horario_fixo_model.dart';
import 'package:walkthrough/modules/loginProf/models/prof_model.dart';

class BancoHorarios {
  static final BancoHorarios instance = BancoHorarios._init();

  List<HorarioFixo> horariosFixos = [];
  List<HorarioAgendado> horariosAgendados = [];
  List<UserProf> professores = [];
  HorarioFixo? horarioAtual;
  //final _method = const MethodChannel("cronolab.cronolab/widget");

  static Database? _db;

  BancoHorarios._init();

  Future<Database> get database async {
    if (_db != null) {
      // deleteDatabase('WTdatabase.db');
      return _db!;
    }

    _db = await _initDB("WTdatabase.db");
    return _db!;
  }

  Future<void> deleteDatabase(String path) =>
    databaseFactory.deleteDatabase(path);

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  static Future _createDB(Database db, int version) async {
    print("Criando Tabelas...");
    await db.execute(
        "CREATE TABLE horariosFixos(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, uid TEXT, nomeProfessor VARCHAR(50), nomeDisciplina VARCHAR(50), horario TEXT, diaSemana VARCHAR(20), lab VARCHAR(5));");
    
    await db.execute(
        "CREATE TABLE horariosAgendados(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, nomeProfessor VARCHAR(50), emailProfessor TEXT, horarioInicial TEXT, horarioFinal TEXT, data TEXT, lab VARCHAR(5), isTemp BOOLEAN, horarioAgendamento TEXT);");

    /* await db.execute(
        "CREATE TABLE professor(id VARCHAR(50) NOT NULL PRIMARY KEY, nome TEXT, professor TEXT, contato TEXT, turmaID VARCHAR(50), FOREIGN KEY (turmaID) REFERENCES turma(id) ON DELETE CASCADE);");
   */
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }


  /*static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }*/

  Future<void> insertHorarioFixo(HorarioFixo horarioFixo) async {
    print("Inserindo horário....");
    
    final db = await instance.database;
    db.close();

    final id = await db.insert("horariosFixos", horarioFixo.toMap());
    horarioFixo.copyWith(id: id);
  }

  Future<int?> insertHorarioAgendado(HorarioAgendado horarioAgendado) async {
    print("Inserindo horário....");
    
    final db = await instance.database;

    final id = await db.insert("horariosAgendados", horarioAgendado.toMap());
    horarioAgendado.copyWith(id: id);
    return id;
  }

  Future<HorarioAgendado?> readHorarioAgendado(int id) async {
    final db = await instance.database;

    final maps = await db.query("horariosAgendados", columns: [
      "id",
      "nomeProfessor",
      "horarioInicial",
      'horarioFinal',
      "data",
      "lab",
      'isTemp'
    ],
    where: 'id = ?',
    whereArgs: [id],
    );

    if(maps.isNotEmpty){
      return HorarioAgendado.fromMap(maps.first);
    } else {
      print("ID $id not found");
      return null;
    }

  }

  Future<HorarioFixo> readHorarioFixo(int id) async {
    final db = await instance.database;

    final maps = await db.query("horariosFixos", columns: [
      "id",
      "uid",
      "nomeProfessor",
      "nomeDisciplina",
      "horario",
      "diaSemana",
      "lab"
    ],
    where: 'id = ?',
    whereArgs: [id],
    );

    if(maps.isNotEmpty){
      return HorarioFixo.fromMap(maps.first);
    } else {
      throw Exception("ID $id not found");
    }

  }

  Future<List<HorarioFixo>> readTodosHorariosFixosLab(String lab) async{
    final db = await instance.database;

    final result = await db.query("horariosFixos", where: "lab = ?", whereArgs: [lab]);

    return result.map((json) => HorarioFixo.fromMap(json)).toList();
  }

  Future<List<HorarioAgendado>> readTodosHorariosAgendadosTemp() async{
    final db = await instance.database;

    final result = await db.query("horariosAgendados", where: "isTemp = ?", whereArgs: [true]);

    return result.map((json) => HorarioAgendado.fromMap(json)).toList();
  }

  Future<List<HorarioAgendado>> readTodosHorariosAgendadosNotTemp() async{
    final db = await instance.database;

    final result = await db.query("horariosAgendados", where: "isTemp = ?", whereArgs: [false]);

    return result.map((json) => HorarioAgendado.fromMap(json)).toList();
  }

  Future<int> update(HorarioFixo horario) async {

    final db = await instance.database;
    return db.update("horariosFixos", horario.toMap(), where: "id = ?", whereArgs: [horario.id]);

  }

  Future<int> delete(int id) async {

    final db = await instance.database;

    return await db.delete(
      "horariosFixos",
      where: "id = ?",
      whereArgs: [id]
    );

  }

  Future<int> deleteHA(int id) async {

    final db = await instance.database;

    return await db.delete(
      "horariosAgendados",
      where: "id = ?",
      whereArgs: [id]
    );

  }

  var horario = HorarioFixo(
    nomeDisciplina: "PID",
    nomeProfessor: 'Rafael',
    horario: '1M2M',
    lab: '602',
    diaSemana: 'segunda',
  );

  //insertHorarioFixo(horario);
}
