import 'package:flutter/material.dart';
import 'package:salatime/mawaqitAPI/services.dart';
import 'package:salatime/mawaqitAPI/mawaqit.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'wilayas.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:auto_size_text/auto_size_text.dart';
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

var myWith;
var myHeight;

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
    myWith = MediaQuery.of(context).size.width;
    myHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sala',
                  style: GoogleFonts.satisfy(fontSize: 50),
                ),
                Text(
                  'Time',
                  style: GoogleFonts.satisfy(
                    textStyle: TextStyle(color: Colors.amber, fontSize: 50),
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
                                      });
                                    });
                                  }),
                                  validator: (val) {
                                    setState(
                                        () => _valueToValidate = val ?? '');
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
                        WaqtCard(salat: 'الفجر', mawaqit: _mawaqit[0].fajr),
                        WaqtCard(salat: 'الشروق', mawaqit: _mawaqit[0].chorok),
                        WaqtCard(salat: 'الظهر', mawaqit: _mawaqit[0].dhohr),
                        WaqtCard(salat: 'العصر', mawaqit: _mawaqit[0].asr),
                        WaqtCard(salat: 'المغرب', mawaqit: _mawaqit[0].maghrib),
                        WaqtCard(salat: 'العشاء', mawaqit: _mawaqit[0].icha),
                      ],
                    ),
                  ),
          )),
    );
  }
}

class WaqtCard extends StatelessWidget {
  const WaqtCard({
    Key key,
    @required this.salat,
    @required String mawaqit,
  })  : _mawaqit = mawaqit,
        super(key: key);
  final String salat;
  final String _mawaqit;

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
                  minFontSize: 17,
                  style: GoogleFonts.anton(),
                ),
              ),
              Center(
                child: Text(
                  '|',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 40,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 40),
                child: AutoSizeText(
                  salat,
                  minFontSize: 17,
                  style: GoogleFonts.mada(
                    textStyle: TextStyle(fontWeight: FontWeight.w500),
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
