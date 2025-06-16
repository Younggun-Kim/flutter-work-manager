part of 'main_bloc.dart';

sealed class MainBlocEvent {
  const MainBlocEvent();

  const factory MainBlocEvent.countChanged(int delta) = MainCountChanged;
}

class MainCountChanged extends MainBlocEvent {
  final int num;

  const MainCountChanged(this.num);
}
