import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';


class BluetoothApp extends StatefulWidget {
  const BluetoothApp({Key? key}) : super(key: key);

  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {
  
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  
  BluetoothConnection? connection;

  int? _deviceState;

  bool isDisconnecting = false;

  Map<String, Color> colors = {
    'onBorderColor': Colors.green,
    'offBorderColor': Colors.red,
    'neutralBorderColor': const Color.fromARGB(255, 144, 117, 189),
    'onTextColor': Colors.green[700] as Color,
    'offTextColor': Colors.red[700] as Color,
    'neutralTextColor': const Color.fromARGB(255, 144, 117, 189),
  };

  
  bool get isConnected => connection != null && connection!.isConnected;

  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  @override
  void initState() {
    super.initState();

    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0;

    //Pedir permissão de ligar o Bluetooth caso esse não esteja ligado ainda
    enableBluetooth();

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      if (connection != null) {
        connection?.dispose();
      }
      connection = null;
    }

    super.dispose();
  }

  // Pede permissão de uso do Bluetooth ao usuário
  Future<bool> enableBluetooth() async {
    //Retorna o estado atual do Bluetooth
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    //Mandar a lista de dispositivos pareados apenas quando o Bluetooth estiver ligado
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  //Para guardar e retornar a lista de dispositivos já pareados
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    //Para conseguir a lista de dispositivos já pareados no dispositivo
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Erro");
    }

    // Erro para chamar o setState a menos que mounted seja verdadeiro
    if (!mounted) {
      return;
    }

    //Guardando a lista de dispositivos para ser usada fora deste método
    setState(() {
      _devicesList = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text("Conexão Bluetooth"),
          backgroundColor: Colors.deepPurple,
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              label: Text(""),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () async {
                await getPairedDevices().then((_) {
                  show('Lista de dispositivos atualizada');
                });
              },
            ),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Visibility(
              visible: _isButtonUnavailable &&
                  _bluetoothState == BluetoothState.STATE_ON,
              child: const LinearProgressIndicator(
                backgroundColor: Colors.yellow,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    child: Text(
                      'Ativar Bluetooth',
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Switch(
                    activeTrackColor: Colors.deepPurpleAccent,
                    inactiveThumbColor: Color.fromARGB(255, 224, 208, 248),
                    value: _bluetoothState.isEnabled,
                    onChanged: (bool value) {
                      future() async {
                        if (value) {
                          await FlutterBluetoothSerial.instance.requestEnable();
                        } else {
                          await FlutterBluetoothSerial.instance
                              .requestDisable();
                        }

                        await getPairedDevices();
                        _isButtonUnavailable = false;

                        if (_connected) {
                          _disconnect();
                        }
                      }

                      future().then((_) {
                        setState(() {});
                      });
                    },
                  )
                ],
              ),
            ),
            const Divider(
              color: Color.fromARGB(255, 144, 117, 189),
            ),
            Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "DISPOSITIVOS PAREADOS",
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'Dispositivo:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          DropdownButton(
                            items: _getDeviceItems(),
                            onChanged: (value) => setState(
                                () => _device = value as BluetoothDevice),
                            value: _devicesList.isNotEmpty ? _device : null,
                            iconSize: 15,
                            icon: const Icon(Icons.arrow_downward_outlined),
                            focusColor: Colors.deepPurple,
                            iconEnabledColor: Colors.deepPurple,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _isButtonUnavailable
                                ? null
                                : _connected
                                    ? _disconnect
                                    : _connect,
                            child: Text(
                              _connected ? 'Desconectar' : 'Conectar',
                              style: const TextStyle(fontSize: 10),
                            ),
                            style: ElevatedButton.styleFrom(
                              maximumSize: const Size(90, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side:
                                    const BorderSide(color: Colors.deepPurple),
                              ),
                              onSurface:
                                  const Color.fromARGB(255, 110, 57, 189),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: _deviceState == 0
                                ? const Color.fromARGB(255, 144, 117, 189)
                                : _deviceState == 1
                                    ? colors['onBorderColor'] as Color
                                    : colors['offBorderColor'] as Color,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        elevation: _deviceState == 0 ? 4 : 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "PORTA",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: _deviceState == 0
                                          ? Colors.deepPurple
                                          : _deviceState == 1
                                              ? colors['onTextColor']
                                              : colors['offTextColor'],
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextButton(
                                onPressed: _connected
                                    ? _abrirPorta
                                    : null,
                                child: Text(
                                  "ABRIR",
                                  style: TextStyle(
                                    color: _deviceState == 0
                                        ? const Color.fromARGB(255, 144, 117, 189)
                                        : _deviceState == 1
                                            ? colors['onBorderColor'] as Color
                                            : colors['offBorderColor'] as Color,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: _connected
                                    ? _trancarPorta
                                    : null,
                                child: Text(
                                  "FECHAR",
                                  style: TextStyle(
                                    color: _deviceState == 0
                                        ? const Color.fromARGB(255, 144, 117, 189)
                                        : _deviceState == 1
                                            ? colors['onBorderColor'] as Color
                                            : colors['offBorderColor'] as Color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(
              color: Color.fromARGB(255, 144, 117, 189),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Obs.: Se você não consegue encontrar o dispositivo na lista acima, favor pareá-lo nas configurações de Bluetooth do dispositivo.",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        child: const Text("Configurações de Bluetooth"),
                        onPressed: () {
                          FlutterBluetoothSerial.instance.openSettings();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(color: Colors.deepPurple),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
    );
  }

  // Cria a lista de dispositivos já pareados
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(const DropdownMenuItem(
        child: Text('NADA'),
      ));
    } else {
      for (var device in _devicesList) {
        items.add(DropdownMenuItem(
          child: Text(device.name as String),
          value: device,
        ));
      }
    }
    return items;
  }

  //Método para conectar o Bluetooth do smartphone
  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    try {
      if (_device == null) {
        show('Nenhum dispositivo selecionado');
      } else {
        if (!isConnected) {
          await BluetoothConnection.toAddress(_device!.address)
              .then((_connection) {
            print('Conectado ao dispositivo');
            connection = _connection;
            setState(() {
              _connected = true;
            });

            connection!.input?.listen(null).onDone(() {
              if (isDisconnecting) {
                print('Desconectando localmente!');
              } else {
                print('Desconectado remotamente!');
              }
              if (mounted) {
                setState(() {});
              }
            });
          }).catchError((error) {
            print('Não é possível conectar, ocorreu uma exceção');
            print(error);
          });
          show('Dispositivo conectado');

          setState(() => _isButtonUnavailable = false);
        }
      }
    } catch (e) {
      show('Não é possível conectar, ocorreu uma exceção');
      print(e);
    }
  }

  //Método para desconectar o Bluetooth do smartphone
  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await connection!.close();
    show('Dispositivo desconectado');
    if (!connection!.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  //Método para enviar mensagem de abertura da tranca
  void _abrirPorta() async {
    connection!.output.add(utf8.encode("1") as Uint8List);
    await connection!.output.allSent;
    show('Porta Aberta');
    setState(() {
      _deviceState = 1;
    });
  }

  //Método para enviar mensagem de trancamento da tranca
  void _trancarPorta() async {
    connection!.output.add(utf8.encode("0") as Uint8List);
    await connection!.output.allSent;
    show('Porta Trancada');
    setState(() {
      _deviceState = -1;
    });
  }

  //Mostrar mensagem na parte inferior da tela
  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    ScaffoldMessenger(key: _scaffoldKey, child: SnackBar(
        duration: Duration(milliseconds: 800),
                          behavior: SnackBarBehavior.fixed,
                          backgroundColor: Colors.deepPurple,
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
