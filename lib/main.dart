import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:star_metter/pages/intro.dart';
import './widgets/menu/menu.dart';
import './blocs/home/home_bloc.dart';
import './services/services.dart';
import 'config/colors.dart';
import 'pages/pages.dart';

enum CurrentPage { HOME, ARTICLES, ABOUT }

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
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
  CurrentPage _currentPage = CurrentPage.HOME;

  @override
  Widget build(BuildContext context) {
    return _repositoryProvider();
  }

  Widget _repositoryProvider() {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HomeService>(
          create: (context) {
            return HomeService();
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
          return HomeBloc(homeService)..add(HomeLoadInit());
        },
      ),
    ], child: _main());
  }

  void _menuButtonHandler(CurrentPage page) {
    zoomController.close!();
    setState(() {
      _currentPage = page;
      isOpen = false;
    });
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
        color: Nord.darkLight,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light.copyWith(
              systemNavigationBarColor: Colors.white,
              statusBarBrightness:
                  Platform.isIOS ? Brightness.dark : Brightness.light,
              statusBarIconBrightness:
                  Platform.isIOS ? Brightness.dark : Brightness.light,
              systemNavigationBarIconBrightness:
                  Platform.isIOS ? Brightness.dark : Brightness.light,
              systemNavigationBarDividerColor: Colors.white,
              statusBarColor: !isOpen ? Nord.darkMedium : Nord.dark,
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
                child: Home(showMenu: () {
                  zoomController.open!();
                  setState(() => isOpen = true);
                }),
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
        if (state is HomeSplash) return const Loading();
        if (state is HomeIntro) return const Intro();
        return const Loading();
      },
    );
  }
}
