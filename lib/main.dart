import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import './widgets/widgets.dart';
import './blocs/home/home_bloc.dart';
import './services/services.dart';
import 'blocs/settings/settings_bloc.dart';
import 'config/colors.dart';
import 'pages/pages.dart';

enum CurrentPage { INTRO, LOADING, HOME, ARTICLES, ABOUT, SETTINGS }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  StorageService storageService = StorageService();

  storageService.getDatabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ZoomDrawerController zoomController = ZoomDrawerController();
  bool isOpen = false;
  CurrentPage _currentPage = CurrentPage.LOADING;

  @override
  Widget build(BuildContext context) {
    return _repositoryProvider();
  }

  void _setDefaultPage({CurrentPage page = CurrentPage.HOME}) {
    setState(() => _currentPage = page);
  }

  void _menuButtonHandler(CurrentPage page) {
    zoomController.close!();
    setState(() {
      isOpen = false;
      _currentPage = page;
    });
  }

  Widget _repositoryProvider() {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HomeService>(
          create: (context) {
            return HomeService();
          },
        ),
        RepositoryProvider<WeightService>(
          create: (context) {
            return WeightService();
          },
        ),
        RepositoryProvider<StarsService>(
          create: (context) {
            return StarsService();
          },
        ),
        RepositoryProvider<SettingsService>(
          create: (context) {
            return SettingsService();
          },
        ),
      ],
      child: _multiBlocProvider(),
    );
  }

  Widget _multiBlocProvider() {
    return MultiBlocProvider(providers: [
      BlocProvider<HomeBloc>(
        create: (context) {
          final homeService = RepositoryProvider.of<HomeService>(context);
          final weightService = RepositoryProvider.of<WeightService>(context);
          final starsService = RepositoryProvider.of<StarsService>(context);
          return HomeBloc(
            homeService,
            weightService,
            starsService,
          )..add(HomeLoadInit(isInit: true, handlePage: _setDefaultPage));
        },
      ),
      BlocProvider<SettingsBloc>(
        create: (context) {
          final settingsService =
              RepositoryProvider.of<SettingsService>(context);
          return SettingsBloc(settingsService)..add(SettingsLoadInit());
        },
      ),
    ], child: _main());
  }

  Widget _main() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(
            headline1: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.bold,
              color: CustomColor.primaryAccent,
              fontFamily: 'Merienda',
            ),
            headline2: TextStyle(
              fontSize: 70,
              fontWeight: FontWeight.w200,
              color: Colors.black,
              fontFamily: 'Roboto',
            ),
            headline3: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
              fontFamily: 'Roboto',
            ),
            headline4: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
              fontFamily: 'Roboto',
            ),
            bodyText1: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Colors.black87,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        color: Nord.darkLight,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light.copyWith(
              systemNavigationBarColor: Colors.white,
              statusBarBrightness:
                  Platform.isIOS ? Brightness.light : Brightness.dark,
              statusBarIconBrightness:
                  Platform.isIOS ? Brightness.light : Brightness.dark,
              systemNavigationBarIconBrightness:
                  Platform.isIOS ? Brightness.light : Brightness.dark,
              systemNavigationBarDividerColor: Colors.white,
              statusBarColor:
                  isOpen ? CustomColor.primaryAccentLight : Colors.white,
            ),
            child: _blocBuilder(),
          ),
        ),
      ),
    );
  }

  Widget _blocBuilder() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomePage) {
          return ZoomDrawer(
            controller: zoomController,
            disableGesture: isOpen,
            style: DrawerStyle.Style5,
            menuScreen: Menu(
              currentPage: _currentPage,
              onClick: _menuButtonHandler,
              user: state.user,
            ),
            mainScreen: GestureDetector(
              onTap: () {
                if (isOpen) {
                  zoomController.close!();
                  setState(() => isOpen = false);
                }
              },
              onPanUpdate: (details) {
                if (details.delta.dx < 0) {
                  zoomController.close!();
                  setState(() => isOpen = false);
                }
              },
              child: AbsorbPointer(
                absorbing: isOpen,
                child: Home(
                  user: state.user,
                  progress: state.progress,
                  showMenu: () {
                    zoomController.open!();
                    setState(() => isOpen = true);
                  },
                ),
              ),
            ),
            borderRadius: 24.0,
            showShadow: true,
            angle: -12.0,
            backgroundColor: CustomColor.primaryAccentDark,
            slideWidth: MediaQuery.of(context).size.width * .45,
            openCurve: Curves.fastOutSlowIn,
            closeCurve: Curves.bounceIn,
          );
        }
        if (state is HomeSplash) {
          return const Loading(
            isHeader: true,
          );
        }
        if (state is HomeIntro) {
          return Intro(
            handlePage: _setDefaultPage,
            introMode: state.introMode,
          );
        }
        if (state is HomeSettings) {
          return Settings(
            handlePage: _setDefaultPage,
            users: state.users,
            userId: state.userId,
          );
        }
        return const Loading();
      },
    );
  }
}
