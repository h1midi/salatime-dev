// To parse this JSON data, do
//
//     final mawaqit = mawaqitFromJson(jsonString);

import 'dart:convert';

List<Mawaqit> mawaqitFromJson(String str) =>
    List<Mawaqit>.from(json.decode(str).map((x) => Mawaqit.fromJson(x)));

String mawaqitToJson(List<Mawaqit> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Mawaqit {
  Mawaqit({
    required this.date,
    required this.wilaya,
    required this.fajr,
    required this.chorok,
    required this.dhohr,
    required this.asr,
    required this.maghrib,
    required this.icha,
  });

  DateTime date;
  Wilaya wilaya;
  String fajr;
  String chorok;
  String dhohr;
  String asr;
  String maghrib;
  String icha;

  factory Mawaqit.fromJson(Map<String, dynamic> json) => Mawaqit(
        date: DateTime.parse(json["date"]),
        wilaya: Wilaya.fromJson(json["wilaya"]),
        fajr: json["fajr"],
        chorok: json["chorok"],
        dhohr: json["dhohr"],
        asr: json["asr"],
        maghrib: json["maghrib"],
        icha: json["icha"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "wilaya": wilaya.toJson(),
        "fajr": fajr,
        "chorok": chorok,
        "dhohr": dhohr,
        "asr": asr,
        "maghrib": maghrib,
        "icha": icha,
      };
}

class Wilaya {
  Wilaya({
    required this.code,
    required this.arabicName,
    required this.englishName,
  });

  String code;
  String arabicName;
  String englishName;

  factory Wilaya.fromJson(Map<String, dynamic> json) => Wilaya(
        code: json["code"],
        arabicName: json["arabic_name"],
        englishName: json["english_name"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "arabic_name": arabicName,
        "english_name": englishName,
      };
}
