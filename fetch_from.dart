import 'package:http/http.dart' as http;

class FetchFrom{
  String url;
  String baseurl = "https://bhatakeed.in/iust/iust/";
  FetchFrom({required this.url});

  Future<dynamic> GetData() async {
        var response = await http.get(Uri.parse(baseurl + url));

        if (response.statusCode == 200) {
          return response.body;
        } else {
          return response.statusCode;
        }
  }

 String baseUrl(){
    return baseurl;
 }

}