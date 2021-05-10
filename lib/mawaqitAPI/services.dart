import 'package:http/http.dart' as http;
import 'package:salatime/mawaqitAPI/mawaqit.dart';

class Services {
  //
  // var wlya;
  static String url = 'https://salat-dz.com/api/v2/mawaqit/?wilayas=';
  static Future<List<Mawaqit>> getMawaqit(wlya) async {
     url = 'https://salat-dz.com/api/v2/mawaqit/?wilayas=$wlya';
    try {
      final response = await http.get(Uri.parse(url));
      if (200 == response.statusCode) {
        final List<Mawaqit> mawaqit = mawaqitFromJson(response.body);
        return mawaqit;
      } else {
        return List<Mawaqit>.empty();
      }
    } catch (e) {
      return List<Mawaqit>.empty();
    }
  }
}
