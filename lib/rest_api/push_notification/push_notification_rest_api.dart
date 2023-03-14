import 'dart:convert';

import 'package:http/http.dart' as http;

Future pushNotification(
    {String message, String receiverName, String token, String image}) async {
  String baseUrl = 'https://fcm.googleapis.com/fcm/send';
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAAnozNhCk:APA91bG313D8w7vA9t4H2ajX9lkOLR9_N_R3zTvrRE90_IQ8xKeULuHsgIDlWFGe5atn8vglO4w5UETvHolUefDlF_29I7pprAJv4Sm1KAZMlZAnOwnbAaS1ftoxvxYRHnKv37ogi4W2',
  };
  print('Headers --> $headers');
  String body = jsonEncode({
    "notification": {
      "body": message,
      "title": receiverName,
      "image": image,
    },
    "priority": "high",
    "data": {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "open_val": "B",
    },
    "registration_ids": [token]
  });
  print('body --> $body');
  final response = await http.post(
    Uri.parse(baseUrl),
    headers: headers,
    body: body,
  );
  print('Status code : ${response.statusCode}');
  print('Body : ${response.body}');
  if (response.statusCode == 200 || response.statusCode == 201) {
    var message = jsonDecode(response.body);
    return message;
  } else {
    print('Status code : ${response.statusCode}');
  }
}
