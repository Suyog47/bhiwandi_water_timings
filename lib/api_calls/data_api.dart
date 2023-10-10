import 'package:http/http.dart' as http;

class DataApiCalls{

  Future<dynamic> getData(id) async {
    final url = Uri.https(
      'bhiwandi-water-timings.000webhostapp.com',
      '/Residents/getData.php',
      {'q': '{https}'},
    );
    try {
      final response = await http.post(url, body: {
        'area_id': id,
      });
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(response.body);
        return "error";
      }
    } catch (e) {
      print('error$e');
      return "error";
    }
  }

  Future<dynamic> getAllData() async {
    final url = Uri.https(
      'bhiwandi-water-timings.000webhostapp.com',
      '/Residents/getAllData.php',
      {'q': '{https}'},
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(response.body);
        return "error";
      }
    } catch (e) {
      print('error$e');
      return "error";
    }
  }
}