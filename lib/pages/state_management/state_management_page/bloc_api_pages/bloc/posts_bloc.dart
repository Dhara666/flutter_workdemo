import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:sheet_demo/pages/state_management/state_management_page/bloc_api_pages/bloc/posts_events.dart';
import 'package:sheet_demo/pages/state_management/state_management_page/bloc_api_pages/bloc/posts_states.dart';
import 'package:sheet_demo/pages/state_management/state_management_page/bloc_api_pages/bloc_api.dart';

class PostsBloc extends Bloc<PostsEvents, PostsStates> {
  final http.Client httpClient;

  PostsBloc({this.httpClient}) : super(PostsStates());

  @override
  Stream<PostsStates> mapEventToState(PostsEvents event) async* {
    if (event is FetchedPosts) {
      print('Current state --> ${state.postsStatus}');
      yield await mapFetchedPostsStates(state);
    }
  }

  Future<PostsStates> mapFetchedPostsStates(PostsStates state) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.postsStatus == PostsStatus.initial) {
        final postsList = await BlocApi().blocApi();
        return state.copyWith(
          postsStatus: PostsStatus.success,
          postsLists: postsList,
          hasReachedMax: false,
        );
      }
      final postsList = await BlocApi().blocApi();
      return postsList.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              postsStatus: PostsStatus.success,
              postsLists: List.of(state.postsLists)..addAll(postsList));
    } catch (e) {
      print('Catch error in mapFetchedPostsStates --> $e');
      return state.copyWith(
          postsStatus: PostsStatus.failure,
          postsLists: null,
          hasReachedMax: false);
    }
  }
}
