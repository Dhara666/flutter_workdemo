import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/constant/string_constant.dart';
import 'package:sheet_demo/pages/splash.dart';
import 'package:sheet_demo/pages/state_management/state_management_page/provider_api_pages/provider_api.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProviderPageApi()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyAppPage();
  }
}

class MyAppPage extends StatefulWidget {
  const MyAppPage({Key key}) : super(key: key);

  @override
  _MyAppPageState createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {
  Locale _locale;
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: _locale,
        theme: ThemeData(
          scaffoldBackgroundColor: ColorResource.white,
            fontFamily: FontString.mont,
            appBarTheme: AppBarTheme(color: ColorResource.themeColor)),
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        home: SplashPage()
      ),
    );
  }
}
// import 'package:flutter/material.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//         home: Scaffold(
//             appBar: AppBar(title: Text('Count Text length')),
//             body: Center(child: TextFieldClass())));
//   }
// }
//
// class TextFieldClass extends StatefulWidget {
//   _TextFieldState createState() => _TextFieldState();
// }
//
// class _TextFieldState extends State<TextFieldClass> {
//   final textController = TextEditingController();
//
//   int charLength = 20;
//   int characterLength = 20;
//
//   _onChanged(String value) {
//     setState(() {
//       charLength = characterLength - value.length;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Padding(
//               padding: EdgeInsets.all(8.0),
//               child:
//                   Text("Length = $charLength", style: TextStyle(fontSize: 20))),
//           Container(
//               width: 280,
//               padding: EdgeInsets.all(10.0),
//               child: TextFormField(
//                 maxLength: 20,
//                 controller: textController,
//                 decoration: InputDecoration(hintText: 'Enter Some Text Here'),
//                 onChanged: _onChanged,
//               )),
//         ],
//       ),
//     ));
//   }
// }
