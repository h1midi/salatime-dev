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
              Padding(
                padding: EdgeInsets.fromLTRB(myWith * 0.04, 16, 0, 0),
                child: Text(
                  _mawaqit,
                  style: GoogleFonts.anton(
                    textStyle: TextStyle(
                      fontSize: 25,
                    ),
                  ),
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
              Padding(
                padding: EdgeInsets.fromLTRB(myWith * 0.6, 20, 20, 20),
                child: Text(
                  salat,
                  style: GoogleFonts.mada(
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
