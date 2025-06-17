part of 'main_bloc.dart';

sealed class MainBlocEvent {
  const MainBlocEvent();

  const factory MainBlocEvent.oneOff() = MainCountOneOff;
  const factory MainBlocEvent.periodic() = MainCountPeriodic;
  const factory MainBlocEvent.processing() = MainCountProcessing;
  const factory MainBlocEvent.countChanged(int delta) = MainCountChanged;
  const factory MainBlocEvent.updated() = MainCountUpdated;
}

class MainCountOneOff extends MainBlocEvent {
  const MainCountOneOff();
}

class MainCountPeriodic extends MainBlocEvent {
  const MainCountPeriodic();
}

class MainCountProcessing extends MainBlocEvent {
  const MainCountProcessing();
}

class MainCountChanged extends MainBlocEvent {
  final int num;

  const MainCountChanged(this.num);
}

class MainCountUpdated extends MainBlocEvent {
  const MainCountUpdated();
}
