import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:star_metter/models/progress.dart';
import 'package:star_metter/models/star.dart';
import 'package:star_metter/models/user.dart';
import 'package:star_metter/models/weight.dart';
import 'package:star_metter/services/weight.dart';
import './../../services/services.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeService _homeService;
  final WeightService _weightService;
  final StarsService _starsService;

  HomeBloc(
    HomeService homeService,
    WeightService weightService,
    StarsService starsService,
  )   : _homeService = homeService,
        _weightService = weightService,
        _starsService = starsService,
        super(HomeInitial()) {
    on<HomeLoadInit>(_mapHomeInit);
    on<HomeLoadSplash>(_mapHomeLoadSplash);
    on<HomeLoadIntro>(_mapHomeLoadIntro);
    on<HomeLoadPage>(_mapHomeLoadHomePage);
  }

  void _mapHomeInit(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeSplash());

    await Future.delayed(const Duration(seconds: 5));
    User? user = await _homeService.getUser(null);
    if (user is User) {
      Weight? weight = await _weightService.getTodayWeight(
          initialWeight: user.initWeight, id: user.id!);
      Weight? previousWeight =
          await _weightService.getPreviousWeight(id: user.id!);
      List<Weight>? weightHistory =
          await _weightService.getWeights(id: user.id!);

      Star? star = await _starsService.getTodayStars(
        id: user.id!,
        progressLimit: user.stars,
      );
      List<Star> starProgress = await _starsService.getStars(id: user.id!);

      Progress? progress = await _homeService.getProgress(
        user: user,
        starProgress: starProgress,
        star: star!,
        weight: weight,
        prevWeight: previousWeight,
        weightProgress: weightHistory,
      );
      if (progress is Progress) {
        emit(HomePage(user: user, progress: progress));
      }
    } else {
      emit(HomeIntro());
    }
  }

  void _mapHomeLoadSplash(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeSplash());
  }

  void _mapHomeLoadIntro(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeIntro());
  }

  void _mapHomeLoadHomePage(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeSplash());

    if (event is HomeLoadPage) {
      if (event.user is User) {
        User user = event.user!;
        int? userId = await _homeService.insertUser(event.user!);
        user.id = userId;

        if (userId is int) {
          Weight? weight = await _weightService.insertNewRecord(
            id: userId,
            weight: user.initWeight,
          );
          Weight? previousWeight =
              await _weightService.getPreviousWeight(id: user.id!);
          List<Weight>? weightHistory =
              await _weightService.getWeights(id: user.id!);

          Star? star = await _starsService.getTodayStars(
            id: user.id!,
            progressLimit: user.stars,
          );
          List<Star> starProgress = await _starsService.getStars(id: user.id!);

          Progress? progress = await _homeService.getProgress(
            user: user,
            starProgress: starProgress,
            star: star!,
            weight: weight,
            prevWeight: previousWeight,
            weightProgress: weightHistory,
          );
          if (progress is Progress) {
            print('PROGGG ${progress.toJson()}');
            emit(HomePage(user: user, progress: progress));
          }
        }
      }
    }
  }
}
