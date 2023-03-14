import 'package:sheet_demo/pages/api_demo_pages/demo_page_model.dart';
import 'package:http/http.dart' as http;
class DemoPageApi {
  // providerApi() async {
  //   String url = 'https://picsum.photos/v2/list?page=5&limit=20';
  //   print('url---> $url');
  //   try {
  //     var response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       print('response code: ${response.body}');
  //       return providerResponseFromJson(response.body);
  //     } else {
  //       print('response: ${response.statusCode}');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('catch error in DemoPage API --->$e');
  //     return null;
  //   }
  // }

  paginationApi({int page, int limit}) async {
    String url = 'https://picsum.photos/v2/list?page=$page&limit=$limit';
    print('url---> $url');
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print('response code: ${response.body}');
        return demoPageApiModelFromJson(response.body);
      } else {
        print('response: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('catch error in Pagination API --->$e');
      return null;
    }
  }
}
