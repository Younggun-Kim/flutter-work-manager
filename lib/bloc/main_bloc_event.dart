part of 'main_bloc.dart';

sealed class MainBlocEvent {
  const MainBlocEvent();

  const factory MainBlocEvent.oneOff() = MainCountOneOff;
  const factory MainBlocEvent.periodic() = MainCountPeriodic;
  const factory MainBlocEvent.processing() = MainCountProcessing;
  const factory MainBlocEvent.countChanged(int delta) = MainCountChanged;
  const factory MainBlocEvent.updated() = MainCountUpdated;
  const factory MainBlocEvent.postRetrieved() = MainPostRetrieved;
  const factory MainBlocEvent.postUpdated(
    GetPostResponseModel post,
  ) = MainPostUpdated;
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
  const MainCountChanged(this.num);

  final int num;
}

class MainCountUpdated extends MainBlocEvent {
  const MainCountUpdated();
}

class MainPostRetrieved extends MainBlocEvent {
  const MainPostRetrieved();
}

class MainPostUpdated extends MainBlocEvent {
  const MainPostUpdated(this.post);

  final GetPostResponseModel post;
}
