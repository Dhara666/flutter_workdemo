import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sheet_demo/common_widget/common_appbar.dart';
import 'package:sheet_demo/common_widget/common_button.dart';
import 'package:sheet_demo/common_widget/common_text.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/generated/l10n.dart';
import 'package:sheet_demo/utils/size_utils.dart';

class QrCodeScannerPage extends StatefulWidget {
  const QrCodeScannerPage({Key key}) : super(key: key);

  @override
  _QrCodeScannerPageState createState() => _QrCodeScannerPageState();
}

class _QrCodeScannerPageState extends State<QrCodeScannerPage> {
  Barcode result;
  QRViewController qrViewController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrViewController.pauseCamera();
    }
    qrViewController.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(text: S.of(context).qrCodeScanner),
      body: Column(
        children: <Widget>[
          Expanded(flex: 2, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: Container(
              height: height* 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Column(
                      children: [
                        Text('Barcode Type: ${describeEnum(result.format)}',style: TextStyle(color: ColorResource.themeColor),),
                        commonHeightBox(heightBox: 5),
                        Text('Data: ${result.code}',style: TextStyle(color: ColorResource.themeColor,fontSize: 12)),
                      ],
                    )
                  else
                    Text('Please Scan a code',style: TextStyle(color: ColorResource.themeColor,fontSize: 15),),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8),
                        child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(color: ColorResource.white)),
                            color: ColorResource.themeColor,
                            onPressed: () async {
                              await qrViewController?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: qrViewController?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text(
                                  'Flash: ${snapshot.data}',
                                  style: TextStyle(color: ColorResource.white),
                                );
                              },
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: MaterialButton(
                            color: ColorResource.themeColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(color: ColorResource.white)),
                            onPressed: () async {
                              await qrViewController?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: qrViewController?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${describeEnum(snapshot.data)}',style: TextStyle(color: ColorResource.white),);
                                } else {
                                  return Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8),
                        child: commonMaterialButton(
                          function: () async {
                            await qrViewController?.pauseCamera();
                          },
                          text: 'pause',
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: commonMaterialButton(
                          function: () async {
                            await qrViewController?.resumeCamera();
                          },
                          text: 'resume',
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (width < 400 || height < 400) ? 150.0 : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: ColorResource.themeColor,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 7,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.qrViewController = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    qrViewController?.dispose();
    super.dispose();
  }
}
