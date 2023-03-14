import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sheet_demo/common_widget/circular_process_indicator.dart';
import 'package:sheet_demo/common_widget/common_appbar.dart';
import 'package:sheet_demo/common_widget/common_text.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/generated/l10n.dart';
import 'package:sheet_demo/pages/chat_page/chat_page.dart';
import 'package:sheet_demo/utils/size_utils.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({Key key}) : super(key: key);

  @override
  _ChatHomePageState createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  var currentUserID = FirebaseAuth.instance.currentUser.uid;
  String groupChatId = "";
  List<QueryDocumentSnapshot> listMessage = new List.from([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(text: S.of(context).chatHomePageAppbar),
      body: ListView(
        children: [
          Container(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('user').snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) {
                      return buildItem(context, snapshot.data.docs[index]);
                    },
                    itemCount: snapshot.data.docs.length,
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.hasError.toString());
                } else {
                  return Padding(
                    padding: EdgeInsets.only(top: height * 0.4),
                    child: Center(child: commonIndicator()),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document['userID'] == currentUserID) {
      return SizedBox();
    }
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              peerId: document['userID'],
              peerAvatar: document['photoUrl'],
              peerName: document['firstName'],
              peerToken: document['token'],
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(5),
        height: height * 0.12,
        decoration: BoxDecoration(
            color: ColorResource.white,
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: width * 0.015),
                  child: document['photoUrl'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            document['photoUrl'],
                            fit: BoxFit.cover,
                            width: 35.0,
                            height: 35.0,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 35.0,
                                height: 35.0,
                                child: Center(child: commonIndicator()),
                              );
                            },
                            errorBuilder: (context, object, stackTrace) {
                              return Icon(
                                Icons.account_circle,
                                size: 50.0,
                                color: ColorResource.themeColor,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.account_circle,
                          size: 50.0,
                          color: ColorResource.themeColor,
                        ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: height * 0.025, left: width * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${document['email']}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ColorResource.themeColor,
                        ),
                      ),
                      commonHeightBox(heightBox: 5),
                      Text(
                        "${document['firstName'] + '\t' + '${document['lastName']}'}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ColorResource.themeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Container(
            //   height: height * 0.09,
            //   width: width * 0.09,
            //   margin: EdgeInsets.only(right: 5),
            //   decoration: BoxDecoration(
            //       shape: BoxShape.circle, color: ColorResource.themeColor),
            //   child: Center(
            //       child: Text(
            //     'New',
            //     style: TextStyle(
            //         color: ColorResource.backGroundColor, fontSize: 10),
            //   )),
            // )
          ],
        ),
      ),
    );
  }
}
