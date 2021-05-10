import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:salatime/mawaqitAPI/services.dart';
import 'package:salatime/mawaqitAPI/mawaqit.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'wilayas.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:google_fonts/google_fonts.dart';

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

class _MyHomePageState extends State<MyHomePage> {
  List<Mawaqit> _mawaqit;
  bool _loading;

  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  TextEditingController _controller;
  String _valueChanged = '20';
  String _valueToValidate = '';
  String _valueSaved = '';

  @override
  void initState() {
    super.initState();
    _loading = true;
    Services.getMawaqit(_valueChanged).then((mawaqit) {
      setState(() {
        _mawaqit = mawaqit;
        _loading = false;
      });
    });
    _controller = TextEditingController(text: '01');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sala',
                style: GoogleFonts.satisfy(),
              ),
              Text(
                'Time',
                style: GoogleFonts.satisfy(
                  textStyle: TextStyle(color: Colors.amber),
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: _loading
              ? SpinKitRing(
                  color: Colors.amber,
                  size: 40.0,
                  lineWidth: 4,
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30.0),
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
                                    });
                                  });
                                }),
                                validator: (val) {
                                  setState(() => _valueToValidate = val ?? '');
                                  return null;
                                },
                                onSaved: (val) =>
                                    setState(() => _valueSaved = val ?? ''),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      WaqtCard(
                          pdng: EdgeInsets.fromLTRB(255, 20, 20, 20),
                          salat: 'الفجر',
                          mawaqit: _mawaqit[0].fajr),
                      WaqtCard(
                          pdng: EdgeInsets.fromLTRB(250, 20, 20, 20),
                          salat: 'الشروق',
                          mawaqit: _mawaqit[0].chorok),
                      WaqtCard(
                          pdng: EdgeInsets.fromLTRB(250, 20, 20, 20),
                          salat: 'الظهر',
                          mawaqit: _mawaqit[0].dhohr),
                      WaqtCard(
                          pdng: EdgeInsets.fromLTRB(255, 20, 20, 20),
                          salat: 'العصر',
                          mawaqit: _mawaqit[0].asr),
                      WaqtCard(
                          pdng: EdgeInsets.fromLTRB(250, 20, 20, 20),
                          salat: 'المغرب',
                          mawaqit: _mawaqit[0].maghrib),
                      WaqtCard(
                          pdng: EdgeInsets.fromLTRB(245, 20, 20, 20),
                          salat: 'العشاء',
                          mawaqit: _mawaqit[0].icha),
                    ],
                  ),
                ),
        ));
  }
}

class WaqtCard extends StatelessWidget {
  const WaqtCard({
    Key key,
    @required this.pdng,
    @required this.salat,
    @required String mawaqit,
  })  : _mawaqit = mawaqit,
        super(key: key);
  final String salat;
  final String _mawaqit;
  final EdgeInsetsGeometry pdng;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 80,
        width: 350,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(25, 25, 0, 0),
              child: Text(
                _mawaqit,
                style: GoogleFonts.anton(
                  textStyle: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(170, 10, 0, 0),
              child: Text(
                '|',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 50,
                ),
              ),
            ),
            Padding(
              padding: pdng,
              child: Text(
                salat,
                style: GoogleFonts.mada(
                  textStyle: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
