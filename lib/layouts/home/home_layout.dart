import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_app/layouts/home/cubit.dart';
import 'package:social_app/layouts/home/states.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/search/search_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class HomeLayout extends StatelessWidget {

  final notification = 5;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeLayoutStates>(
      listener: (context,state) {
        if (state is NewPost)
          navigateTo(context, NewPostScreen());
      },
      builder: (context,state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(cubit.titles[cubit.currentIndex],
              style: TextStyle(fontSize: 24.0),),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0,left: 8.0),
                child: Row(
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        IconButton(onPressed: () {}, icon: Icon(IconBroken.Notification,size: 27,),),

                        Padding(
                          padding: const EdgeInsets.only(top: 4.0,right: 5.0),
                          child: Badge(
                            position: BadgePosition.topEnd(),
                            borderRadius: BorderRadius.circular(5.0),
                            badgeContent: Text('${notification <= 50 ? notification: '50+'}',style: TextStyle(fontSize: 9.5,height: 1.0,color: Colors.white),),

                          ),
                        ),
                      ],
                    ),

                    Center(
                      child: IconButton(
                        onPressed: () {
                          navigateTo(context, SearchScreen());
                        },
                        icon: Icon(
                          IconBroken.Search,
                          size: 26,
                        ),
                      ),
                    ),

                    SizedBox(width: 7,),
                  ],
                ),
              )

            ],
          ),
          body: cubit.socialScreen[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                cubit.changeScreen(index);
              },
              currentIndex: cubit.currentIndex,
              iconSize: 28,

              items: [
                BottomNavigationBarItem(icon: Icon(IconBroken.Home),label: 'Home',),
                BottomNavigationBarItem(icon: Icon(MdiIcons.chatOutline),label: 'Chats',),
                BottomNavigationBarItem(icon: Icon(IconBroken.Upload),label: 'Add Post',),
                BottomNavigationBarItem(icon: Icon(IconBroken.Location),label: 'Users',),
                BottomNavigationBarItem(icon: Icon(IconBroken.Profile),label: 'Profile',),
              ],
            ),
        );
      },
    );
  }
}
