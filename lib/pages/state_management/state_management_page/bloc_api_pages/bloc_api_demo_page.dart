import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheet_demo/common_widget/circular_process_indicator.dart';
import 'package:sheet_demo/common_widget/common_appbar.dart';
import 'package:sheet_demo/common_widget/common_text.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/constant/string_constant.dart';
import 'package:sheet_demo/generated/l10n.dart';
import 'package:sheet_demo/pages/state_management/state_management_page/bloc_api_pages/bloc/posts_bloc.dart';
import 'package:sheet_demo/pages/state_management/state_management_page/bloc_api_pages/bloc/posts_events.dart';
import 'package:sheet_demo/pages/state_management/state_management_page/bloc_api_pages/bloc/posts_states.dart';
import 'package:http/http.dart' as http;

class BlocApiDemo extends StatefulWidget {
  const BlocApiDemo({Key key}) : super(key: key);

  @override
  _BlocApiDemoState createState() => _BlocApiDemoState();
}

class _BlocApiDemoState extends State<BlocApiDemo> {
  @override
  Widget build(BuildContext context) {
    print('Current Page --> $runtimeType');
    return Scaffold(
      appBar: commonAppbar(text: S.of(context).blocApiAppbar),

      body: Center(
        child: BlocProvider(
          create: (context) {
            return PostsBloc(httpClient: http.Client())..add(FetchedPosts());
          },
          child: BlocBuilder<PostsBloc, PostsStates>(
            builder: (context, state) {
              switch (state.postsStatus) {
                case PostsStatus.failure:
                  return Center(child: Text('Failed to fetch data'));
                case PostsStatus.success:
                  return ListView.builder(
                    itemCount: state.postsLists.length,
                    itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color:  ColorResource.themeColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          commonHeightBox(heightBox: 10),
                          commonText(
                              text:
                                  "${CommonStrings.id} ${state.postsLists[index].id}",
                              color: ColorResource.white),
                          commonText(
                              text:
                                  "${CommonStrings.author} ${state.postsLists[index].author}",
                              color: ColorResource.white),
                          commonText(
                              text:
                                  "${CommonStrings.heightApi} ${state.postsLists[index].height.toString()}",
                              color: ColorResource.white),
                          commonText(
                              text:
                                  "${CommonStrings.widthApi} ${state.postsLists[index].width.toString()}",
                              color:ColorResource.white),
                          commonHeightBox(heightBox: 8),
                        ],
                      ),
                    ),
                  );
                default:
                  return Center(
                      child: commonIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
