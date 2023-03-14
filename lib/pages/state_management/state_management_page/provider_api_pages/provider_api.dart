import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:sheet_demo/pages/state_management/state_management_page/provider_api_pages/provider_response.dart';

class ProviderPageApi extends ChangeNotifier {
  providerApi() async {
    String url = 'https://picsum.photos/v2/list?page=5&limit=20';
    print('url---> $url');
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print('response code: ${response.body}');
        return providerResponseFromJson(response.body);
      } else {
        print('response: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('catch error in DemoPage API --->$e');
      return null;
    }
  }
}
