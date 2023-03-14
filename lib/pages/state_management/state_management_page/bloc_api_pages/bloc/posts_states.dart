import 'package:sheet_demo/pages/state_management/state_management_page/bloc_api_pages/bloc_response.dart';

enum PostsStatus { initial, success, failure }

class PostsStates {
  PostsStatus postsStatus;
  List<BlocResponse> postsLists;
  bool hasReachedMax;

  PostsStates({
    this.postsStatus = PostsStatus.initial,
    this.postsLists = const <BlocResponse>[],
    this.hasReachedMax = false,
  });

  PostsStates copyWith({
    PostsStatus postsStatus,
    List<BlocResponse> postsLists,
    bool hasReachedMax,
  }) {
    return PostsStates(
      postsStatus: postsStatus ?? this.postsStatus,
      postsLists: postsLists ?? this.postsLists,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
