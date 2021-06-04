import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:timer_count_down/timer_controller.dart';

import 'package:salatime/mawaqitAPI/mawaqit.dart';
import 'package:salatime/mawaqitAPI/services.dart';

import 'wilayas.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Salatime',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        brightness: Brightness.dark,
        accentColor: Colors.amber,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage() : super();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

var myWith;
var myHeight;

class _MyHomePageState extends State<MyHomePage> {
  List<Mawaqit> _mawaqit;
  bool _loading;
  List<String> timers;

  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  TextEditingController _controller;
  String _valueChanged = '13';
  String _valueToValidate = '';
  String _valueSaved = '';

  bool _connectionStatus = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  String timer(String date) {
    DateTime parseDt = DateTime.parse(DateTime.now().year.toString() +
        '-' +
        '0' +
        DateTime.now().month.toString() +
        '-' +
        '0' +
        DateTime.now().day.toString() +
        ' ' +
        date);
    print(parseDt);
    return DateTime.now().difference(parseDt).inSeconds.toString();
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _loading = true;
    _connectionStatus = true;

    _controller = TextEditingController(text: '13');
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile)
      setState(() {
        _connectionStatus = false;
        Services.getMawaqit(_valueChanged).then((mawaqit) {
          setState(() {
            _mawaqit = mawaqit;
            _loading = false;
            timers = [
              timer(_mawaqit[0].fajr),
              timer(_mawaqit[0].chorok),
              timer(_mawaqit[0].dhohr),
              timer(_mawaqit[0].asr),
              timer(_mawaqit[0].maghrib),
              timer(_mawaqit[0].icha)
            ];
          });
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    myWith = MediaQuery.of(context).size.width;
    myHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sala',
                      style: TextStyle(
                        fontSize: 50,
                        fontFamily: 'Satisfy',
                      ),
                    ),
                    Text(
                      'Time',
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 50,
                          fontFamily: 'Satisfy'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: Center(
            child: _connectionStatus
                ? Center(
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Text(
                          'No Internet, check you network settings.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 100.0),
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  )
                : _loading
                    ? CircularProgressIndicator()
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                              child: Form(
                                key: _oFormKey,
                                child: Column(
                                  children: <Widget>[
                                    SelectFormField(
                                      controller: _controller,
                                      labelText: 'Wilaya',
                                      items: items,
                                      onChanged: (val) => setState(() {
                                        _valueChanged = val;
                                        Services.getMawaqit(_valueChanged)
                                            .then((mawaqit) {
                                          setState(() {
                                            _mawaqit = mawaqit;
                                            _loading = false;
                                            timers = [
                                              timer(_mawaqit[0].fajr),
                                              timer(_mawaqit[0].chorok),
                                              timer(_mawaqit[0].dhohr),
                                              timer(_mawaqit[0].asr),
                                              timer(_mawaqit[0].maghrib),
                                              timer(_mawaqit[0].icha)
                                            ];
                                            _ccontroller.restart();
                                          });
                                        });
                                      }),
                                      validator: (val) {
                                        setState(
                                            () => _valueToValidate = val ?? '');
                                        return null;
                                      },
                                      onSaved: (val) => setState(
                                          () => _valueSaved = val ?? ''),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            WaqtCard(
                                salat: 'الفجر',
                                timer: timers[indx],
                                mawaqit: _mawaqit[0].fajr),
                            WaqtCard(
                                salat: 'الشروق',
                                timer: timers[indx],
                                mawaqit: _mawaqit[0].chorok),
                            WaqtCard(
                                salat: 'الظهر',
                                timer: timers[indx],
                                mawaqit: _mawaqit[0].dhohr),
                            WaqtCard(
                                salat: 'العصر',
                                timer: timers[indx],
                                mawaqit: _mawaqit[0].asr),
                            WaqtCard(
                                salat: 'المغرب',
                                timer: timers[indx],
                                mawaqit: _mawaqit[0].maghrib),
                            WaqtCard(
                                salat: 'العشاء',
                                timer: timers[indx],
                                mawaqit: _mawaqit[0].icha),
                          ],
                        ),
                      ),
          )),
    );
  }
}

final CountdownController _ccontroller = new CountdownController();
int indx = 0;

class WaqtCard extends StatelessWidget {
  WaqtCard({
    this.salat,
    this.timer,
    String mawaqit,
  })  : _mawaqit = mawaqit,
        timerInt = int.parse(timer) * -1,
        super();
  final String salat;
  final String _mawaqit;
  final String timer;
  final int timerInt;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: (myHeight * 0.1),
        width: (myWith * 0.8),
        child: Center(
          child: Stack(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 40),
                child: AutoSizeText(
                  _mawaqit,
                  minFontSize: 18,
                  style: TextStyle(fontFamily: 'Anton'),
                ),
              ),
              //Text(timer),
              Center(
                child: Countdown(
                  controller: _ccontroller,
                  seconds: timerInt,
                  build: (_, double time) => time > 0
                      ? {
                          indx < 5 ? indx++ : indx = 0,
                          Text(
                            time.toInt().toString(),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )
                        }
                      : Container(
                          child: Text(
                            time.toInt().toString(),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                  onFinished: () => indx < 5 ? indx++ : indx = 0,
                ),
              ),
              // Center(
              //   child: Text(
              //     DateTime.now().toString(),
              //     style: TextStyle(
              //       color: Colors.amber,
              //       fontSize: 10,
              //     ),
              //   ),
              // ),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 40),
                child: AutoSizeText(
                  salat,
                  minFontSize: 17,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Mada',
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
