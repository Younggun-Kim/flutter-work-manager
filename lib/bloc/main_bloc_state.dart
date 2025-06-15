part of 'main_bloc.dart';

class MainBlocState {
  MainBlocState({this.count = 0});

  final int count;
}

extension MainBlocStateEx on MainBlocState {
  MainBlocState copyWith({int? count}) => MainBlocState(
    count: count ?? this.count,
  );
}
