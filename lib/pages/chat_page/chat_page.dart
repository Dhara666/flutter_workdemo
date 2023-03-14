import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sheet_demo/common_widget/circular_process_indicator.dart';
import 'package:sheet_demo/common_widget/common_appbar.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/pages/chat_page/full_photo_page.dart';
import 'package:sheet_demo/rest_api/push_notification/push_notification_rest_api.dart';
import 'package:sheet_demo/utils/size_utils.dart';

class ChatPage extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String peerName;
  final String peerToken;

  ChatPage({this.peerId, this.peerAvatar, this.peerName, this.peerToken});

  @override
  State createState() => ChatPageState(
        peerId: peerId,
        peerAvatar: peerAvatar,
        peerName: peerName,
        peerToken: peerToken,
      );
}

class ChatPageState extends State<ChatPage> {
  ChatPageState({this.peerId, this.peerAvatar, this.peerName, this.peerToken});

  String peerId;
  String peerAvatar;
  String peerName;
  String peerToken;

  var id = FirebaseAuth.instance.currentUser.uid;
  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  String groupChatId = "";

  File imageFile;
  bool isLoading = false;
  String imageUrl = "";

  final TextEditingController messageController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  bool isRead = false;

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  readLocal() async {
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }
    print("{group chat id -->> $groupChatId}");
    setState(() {});
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });

        uploadFile();
      }
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Stack(
            children: [commonIndicator()],
          ),
        );
      },
    );
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      print("imageUrl--->$imageUrl");
      setState(() {
        isLoading = false;
        Navigator.of(context, rootNavigator: false).pop();
        onSendMessage(content: imageUrl, type: 1);
        pushNotification(
            receiverName: widget.peerName,
            message: "Image",
            token: widget.peerToken,
            image: imageUrl);
        messageController.clear();
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  void onSendMessage({String content, int type}) {
    if (content.trim() != '') {
      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type,
            'isRead': isRead
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send',
          backgroundColor: ColorResource.themeColor,
          textColor: ColorResource.white);
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document != null) {
      if (document.get('idFrom') == id) {
        // Right (my message)
        return Container(
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  document.get('type') == 0
                      // Text
                      ? Flexible(
                          child: Container(
                            margin: EdgeInsets.only(
                                bottom: isLastMessageLeft(index) ? 3 : 5,
                                left: 20),
                            decoration: BoxDecoration(
                              color: ColorResource.themeColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                document.get('content'),
                                style: TextStyle(color: ColorResource.white),
                              ),
                            ),
                          ),
                        )
                      : document.get('type') == 1
                          // Image
                          ? InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullPhotoPage(
                                        url: document.get('content'),
                                        appbarText: 'Full Photo'),
                                  ),
                                );
                              },
                              child: Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    document.get("content"),
                                    width: 200.0,
                                    height: 150.0,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 200.0,
                                        height: 150.0,
                                        decoration: BoxDecoration(
                                          color: ColorResource.chatTheme,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor: Color(0xffc79ebc),
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    ColorResource.themeColor),
                                            value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null &&
                                                    loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, object, stackTrace) {
                                      return ClipRRect(
                                        child: Image.asset(
                                          'images/img_not_available.jpeg',
                                          width: 200.0,
                                          height: 150.0,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                margin: EdgeInsets.only(
                                  bottom: 5,
                                ),
                              ),
                            )
                          : Container(),
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
              isLastMessageRight(index)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10, bottom: 5),
                          child: Text(
                            DateFormat('dd MMM kk:mm').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(document.get('timestamp')))),
                            style: TextStyle(
                                color: ColorResource.themeColor,
                                fontSize: 10.0,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    )
                  : Container()
            ],
          ),
          margin: EdgeInsets.only(bottom: 5.0),
        );
      } else {
        // Left (peer message)
        return Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  //circle image chat partner
                  isLastMessageLeft(index)
                      ? ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(18.0),
                          ),
                          child: Image.network(
                            peerAvatar,
                            width: 25,
                            height: 25,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Color(0xffc79ebc),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      ColorResource.themeColor),
                                  value: loadingProgress.expectedTotalBytes !=
                                              null &&
                                          loadingProgress.expectedTotalBytes !=
                                              null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, object, stackTrace) {
                              return Icon(
                                Icons.account_circle,
                                size: 25,
                                color: ColorResource.chatTheme,
                              );
                            },
                          ),
                        )
                      : Container(width: 25.0),
                  document.get('type') == 0
                      ? Flexible(
                          flex: 1,
                          child: Container(
                              decoration: BoxDecoration(
                                color: ColorResource.chatTheme,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              margin: EdgeInsets.only(
                                  bottom: isLastMessageRight(index) ? 3 : 5,
                                  right: 20,
                                  left: 10),
                              // width: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(document.get('content'),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              )))
                      : document.get('type') == 1
                          ? InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullPhotoPage(
                                      url: document.get('content'),
                                      appbarText: 'Full Photo',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    document.get('content'),
                                    width: 200.0,
                                    height: 150.0,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 200.0,
                                        height: 150.0,
                                        decoration: BoxDecoration(
                                          color: ColorResource.chatTheme,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor: Color(0xffc79ebc),
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    ColorResource.themeColor),
                                            value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null &&
                                                    loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                margin: EdgeInsets.only(left: 10.0),
                              ),
                            )
                          : Container(),
                ],
              ),
              isLastMessageLeft(index)
                  ? Container(
                      child: Text(
                        DateFormat('dd MMM kk:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(document.get('timestamp')))),
                        style: TextStyle(
                            color: ColorResource.chatTheme,
                            fontSize: 10.0,
                            fontStyle: FontStyle.italic),
                      ),
                      margin: EdgeInsets.only(left: 35.0, top: 5),
                    )
                  : Container()
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.only(bottom: 5.0),
        );
      }
    } else {
      return SizedBox();
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage[index - 1].get('idFrom') == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage[index - 1].get('idFrom') != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(text: peerName),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),
              // Input content
              buildInput(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            color: ColorResource.white,
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            child: IconButton(
              icon: Icon(Icons.image),
              onPressed: getImage,
              color: ColorResource.themeColor,
            ),
          ),
          Flexible(
            child: Container(
              height: height * 0.05,
              child: TextField(
                onSubmitted: (value) {
                  onSendMessage(content: messageController.text, type: 0);
                  pushNotification(
                    receiverName: widget.peerName,
                    message: messageController.text,
                    token: widget.peerToken,
                  );
                  messageController.clear();
                },
                style:
                    TextStyle(color: ColorResource.themeColor, fontSize: 15.0),
                controller: messageController,
                cursorColor: ColorResource.themeColor,
                decoration: InputDecoration(
                    hintText: ' Message...',
                    hintStyle: TextStyle(color: ColorResource.chatTheme),
                    contentPadding: EdgeInsets.only(left: 5),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorResource.chatTheme),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorResource.themeColor),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    )),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              style: TextButton.styleFrom(
                primary: ColorResource.themeColor,
              ),
              onPressed: () {
                onSendMessage(content: messageController.text, type: 0);
                pushNotification(
                  receiverName: widget.peerName,
                  message: messageController.text,
                  token: widget.peerToken,
                );
                messageController.clear();
              },
              child: Text(
                "Send",
              ),
            ),
          ),
        ],
      ),
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: ColorResource.themeColor, width: 1)),
          color: ColorResource.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessage.addAll(snapshot.data.docs);
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data.docs[index]),
                    itemCount: snapshot.data.docs.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                } else {
                  return Center(child: commonIndicator());
                }
              },
            )
          : Center(
              child: commonIndicator(),
            ),
    );
  }
}
