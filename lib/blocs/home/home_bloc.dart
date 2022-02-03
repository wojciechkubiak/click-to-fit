import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:star_metter/models/intro.dart';
import '../../models/progress.dart';
import '../../models/star.dart';
import '../../models/user.dart';
import '../../models/weight.dart';
import '../../services/weight.dart';
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
    on<HomeLoadSettings>(_mapHomeLoadSettings);
    on<HomeLoadStars>(_mapHomeLoadStars);
    on<HomeLoadMeasures>(_mapHomeLoadMeasures);
  }

  void _mapHomeInit(HomeEvent event, Emitter<HomeState> emit) async {
    if (event is HomeLoadInit) {
      event.isInit ? emit(HomeSplash()) : emit(HomeLoading());

      if (event.isInit) await Future.delayed(const Duration(seconds: 5));

      User? user = await _homeService.getUser(event.userId);

      if (user is User) {
        List<Weight> weightsList =
            await _weightService.getAllWeights(id: user.id!) ?? [];

        Weight? weight = weightsList.first;

        Weight? previousWeight = weightsList.length > 1 ? weightsList[1] : null;

        Star? star = await _starsService.getTodayStars(
          id: user.id!,
          progressLimit: user.stars,
        );
        List<Star> starProgress = await _starsService.getStars(
          id: user.id!,
          scope: DateScope.week,
        );

        Progress? progress = await _homeService.getProgress(
          user: user,
          starProgress: starProgress,
          star: star!,
          weight: weight,
          prevWeight: previousWeight,
          weightProgress: weightsList,
        );
        if (progress is Progress) {
          event.handlePage();
          emit(HomePage(user: user, progress: progress));
        }
      } else {
        emit(HomeIntro(introMode: IntroMode.init));
      }
    } else {
      emit(HomeSplash());
    }
  }

  void _mapHomeLoadSplash(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeSplash());
  }

  void _mapHomeLoadIntro(HomeEvent event, Emitter<HomeState> emit) async {
    if (event is HomeLoadIntro) {
      emit(HomeIntro(introMode: event.introMode, user: event.user));
    }
  }

  void _mapHomeLoadHomePage(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    if (event is HomeLoadPage) {
      if (event.user is User) {
        late Weight? weight;

        User user = event.user!;
        int? userId = await _homeService.insertUser(event.user!);
        user.id = userId;

        if (userId is int) {
          if (event.introMode == IntroMode.edit) {
            int? firstWeightID = await _weightService.getFirstWeightID(
              id: userId,
            );

            if (firstWeightID is int) {
              await _weightService.updateWeight(
                recordId: firstWeightID,
                weight: user.initWeight,
              );

              weight = Weight(
                id: firstWeightID,
                date: user.initDate,
                userId: userId,
                weight: user.initWeight,
              );
            } else {
              weight = await _weightService.insertNewRecord(
                userId: userId,
                weight: user.initWeight,
              );
            }

            _starsService.updateLastUserStars(
              userId: userId,
              stars: user.stars,
            );
          } else {
            weight = await _weightService.insertNewRecord(
              userId: userId,
              weight: user.initWeight,
            );
          }

          Weight? previousWeight =
              await _weightService.getPreviousWeight(id: user.id!);
          List<Weight>? weightHistory =
              await _weightService.getScopeWeights(id: user.id!);

          Star? star = await _starsService.getTodayStars(
            id: user.id!,
            progressLimit: user.stars,
          );
          List<Star> starProgress = await _starsService.getStars(
            id: user.id!,
            scope: DateScope.week,
          );

          Progress? progress = await _homeService.getProgress(
            user: user,
            starProgress: starProgress,
            star: star!,
            weight: weight,
            prevWeight: previousWeight,
            weightProgress: weightHistory,
          );
          if (progress is Progress) {
            await Future.delayed(const Duration(seconds: 4));

            emit(HomePage(user: user, progress: progress));
          }
        }
      }
    }
  }

  void _mapHomeLoadSettings(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    List<User> users = await _homeService.getUsers();
    User? currentUser = await _homeService.getUser(null);

    if (currentUser is User) {
      emit(HomeSettings(
        users: users,
        currentUser: currentUser,
      ));
    }
  }

  void _mapHomeLoadStars(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    int? userId = await _homeService.getCurrentUser();

    if (userId is int) {
      List<Star> stars = await _starsService.getStars(
        id: userId,
        scope: DateScope.week,
        isNullStarIncluded: false,
      );
      emit(HomeStars(stars: stars));
    }
  }

  void _mapHomeLoadMeasures(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    if (event is HomeLoadMeasures) {
      if (event.isDelayed) {
        await Future.delayed(const Duration(milliseconds: 1500));
      }

      if (event.user is User) {
        WeightService weightService = WeightService();

        List<Weight>? weights =
            await weightService.getScopeWeights(id: event.user!.id!);

        List<Weight>? allWeights =
            await weightService.getAllWeights(id: event.user!.id!);

        if (weights is List<Weight> && allWeights is List<Weight>) {
          emit(HomeMeasures(
            user: event.user!,
            weights: weights,
            allWeights: allWeights,
          ));
        }
      }
    }
  }
}
