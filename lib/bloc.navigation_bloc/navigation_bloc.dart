import 'package:bloc/bloc.dart';
import 'package:gabong_v1/pages/points_calculator/points_calculator.dart';
import 'package:gabong_v1/pages/rules.dart';
import '../pages/play_gabong.dart';

enum NavigationEvents {
  playGabongClickedEvent,
  pointsCalculatorClickedEvent,
  rulesClickedEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  NavigationBloc() : super(const PlayGabong());
  NavigationStates get initialState => const PlayGabong();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.playGabongClickedEvent:
        yield const PlayGabong();
        break;
      case NavigationEvents.pointsCalculatorClickedEvent:
        yield PointsCalculatorPage();
        break;
      case NavigationEvents.rulesClickedEvent:
        yield const RulesPage();
        break;
    }
  }
}

