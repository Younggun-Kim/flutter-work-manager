part of 'main_bloc.dart';

sealed class MainBlocEvent {
  const MainBlocEvent();

  const factory MainBlocEvent.increase() = MainCountIncreased;
  const factory MainBlocEvent.decrease() = MainCountDecreased;
}

class MainCountIncreased extends MainBlocEvent {
  const MainCountIncreased();
}

class MainCountDecreased extends MainBlocEvent {
  const MainCountDecreased();
}
