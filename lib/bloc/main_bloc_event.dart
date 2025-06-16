part of 'main_bloc.dart';

sealed class MainBlocEvent {
  const MainBlocEvent();

  const factory MainBlocEvent.increased() = MainCountIncreased;
  const factory MainBlocEvent.countChanged(int delta) = MainCountChanged;
  const factory MainBlocEvent.updated() = MainCountUpdated;
}

class MainCountIncreased extends MainBlocEvent {
  const MainCountIncreased();
}

class MainCountChanged extends MainBlocEvent {
  final int num;

  const MainCountChanged(this.num);
}

class MainCountUpdated extends MainBlocEvent {
  const MainCountUpdated();
}
