import 'package:http/http.dart' as http;
import 'package:sheet_demo/pages/state_management/state_management_page/bloc_api_pages/bloc_response.dart';

class BlocApi {
   blocApi() async {
    String url ='https://picsum.photos/v2/list?page=5&limit=20';
    print('Url --> $url');
    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print('response code: ${response.body}');
        if (response.body != null) {
           return blocResponseFromJson(response.body);
        } else {
          return null;
        }
      } else {
        print('Status Code --> ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Catch error in postsApi method --> $e');
      return null;
    }
  }
}
