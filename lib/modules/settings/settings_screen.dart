import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/home/cubit.dart';
import 'package:social_app/layouts/home/states.dart';
import 'package:social_app/modules/edit_profile/edit_profile_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeLayoutStates>(
      listener: (context,state) {},
      builder: (context,state) {
        var userModel = HomeCubit.get(context).userModel;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 195,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 150.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                              image: DecorationImage(
                                image: NetworkImage('${userModel?.cover}'),
                                fit: BoxFit.cover,
                              )
                          ),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 64.0,
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          CircleAvatar(
                            radius: 60.0,
                            backgroundImage: NetworkImage(
                                '${userModel?.image}'),
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,

                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.5,),
                Text(
                    '${userModel?.name}',
                    style: Theme.of(context).textTheme.bodyText1
                ),
                Text(
                    '${userModel?.bio}',
                    style: Theme.of(context).textTheme.caption
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                  '100',
                                  style: Theme.of(context).textTheme.bodyText1
                              ),
                              Text(
                                  'Posts',
                                  style: Theme.of(context).textTheme.caption
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                  '20',
                                  style: Theme.of(context).textTheme.bodyText1
                              ),
                              Text(
                                  'Photos',
                                  style: Theme.of(context).textTheme.caption
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                  '10k',
                                  style: Theme.of(context).textTheme.bodyText1
                              ),
                              Text(
                                  'Followers',
                                  style: Theme.of(context).textTheme.caption
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                  '56',
                                  style: Theme.of(context).textTheme.bodyText1
                              ),
                              Text(
                                  'Followings',
                                  style: Theme.of(context).textTheme.caption
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {  },
                      child: Text('Add Photos'),

                      ),
                    ),
                    SizedBox(width: 10,),
                    OutlinedButton(
                      onPressed: () {
                        navigateTo(context, EditProfileScreen());
                      },
                      child: Icon(IconBroken.Edit,size: 20.0,),

                    ),
                  ],
                )

              ],
            ),
          ),
        );
      },
    );
  }
}
