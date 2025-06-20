part of 'main_bloc.dart';

class MainBlocState {
  MainBlocState({
    this.count = 0,
    this.post,
  });

  final int count;
  final GetPostResponseModel? post;
}

extension MainBlocStateEx on MainBlocState {
  MainBlocState copyWith({int? count, GetPostResponseModel? post}) =>
      MainBlocState(
        count: count ?? this.count,
        post: post ?? this.post,
      );
}
