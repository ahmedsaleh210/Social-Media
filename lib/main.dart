import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/home/states.dart';
import 'package:social_app/shared/BlocObserver.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/local/shared_preferences.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'layouts/home/cubit.dart';
import 'layouts/home/home_layout.dart';
import 'modules/login/login_screen.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  await Firebase.initializeApp();
  uId = CacheHelper.getData(key: 'uId');
  final Widget startWidget;
    if (uId != null) startWidget = HomeLayout();
    else startWidget = LoginScreen();
  runApp(MyApp(
    startwidget: startWidget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startwidget;
  // This widget is the root of your application.
  MyApp({
    required this.startwidget,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)
      {
        return HomeCubit()
          ..getUserData()
          ..getPosts();
        },
      child: BlocConsumer<HomeCubit,HomeLayoutStates>(
        listener: (context,state) {},
        builder: (context,state) => MaterialApp(
          theme: lightmode,
          debugShowCheckedModeBanner: false,
          home: startwidget,
        ),
      ),
    );
  }
}

