import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/home/cubit.dart';
import 'package:social_app/layouts/home/states.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/comment_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedScreen extends StatelessWidget {
  final dateTime = DateTime.now();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeLayoutStates>(
      listener: (context,state) {},
      builder: (context,state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          body: BuildCondition(
            condition: cubit.posts.length >  0,
            builder: (context) => RefreshIndicator(
              onRefresh: () {
                cubit.getPosts();
                return cubit.getUserData();
                },
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Card(
                      elevation: 5.0,
                      margin: EdgeInsets.all(8.0),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Image(
                            image: NetworkImage('https://image.freepik.com/free-photo/portrait-beautiful-young-woman-gesticulating_273609-41056.jpg'),
                            fit: BoxFit.cover,
                            height: 230,
                            width: double.infinity,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text('Communicate with friends',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white.withOpacity(0.75)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context,index) => buildPostItem(cubit.posts[index],context,index,state),
                      itemCount: cubit.posts.length,
                      separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10,) ,
                    ),
                  ],
                ),
              ),
            ),
            fallback: (context) => Center(child: CircularProgressIndicator(),),
          ),
        );
      }
    );
  }
  Widget buildPostItem(PostModel model,context,index,state) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                      '${model.image}'),
                  backgroundColor: Colors.white,
                ),
                SizedBox(width: 15.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${model.name}',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(width: 3.0,),
                          Icon(Icons.check_circle,size: 16,color: Colors.blue,)
                        ],
                      ),
                      Text(
                          '${timeago.format(DateTime.parse(model.dateTime.toString()))}',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                              height: 1.16
                          )
                      ),
                    ],
                  ),
                ),
                IconButton(onPressed: () {
                  print(uId);
                }, icon: Icon(
                    IconBroken.More_Circle
                ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: myDivider(1,color: Colors.grey[300]),
            ),
            Text('${model.postText}',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontSize: 16.0
              ),),
            // Wrap(
            //   spacing: 3.0,
            //   children: [
            //     InkWell(
            //       onTap: () {},
            //       child: Text(
            //         '#Software',
            //         textAlign: TextAlign.start,
            //         style: TextStyle(color: defaultColor),),
            //     ),
            //     InkWell(
            //       onTap: () {},
            //       child: Text(
            //         '#flutter',
            //         textAlign: TextAlign.start,
            //         style: TextStyle(color: defaultColor),),
            //     ),
            //   ],
            // ),
            if(model.postImage!='')
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Container(
                height: 150.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: NetworkImage('${model.postImage}'),
                      fit: BoxFit.cover,
                    )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5),
                      onTap: () {
                        if (model.postLikes.length>0) {
                          HomeCubit.get(context)
                              .getPostUsersLikes(model.postId);
                          _showBottomSheet(context, state);
                        }
                      },
                      child: Row(
                        children: [
                          model.postLikes.contains(uId)?
                          Icon(IconBroken.Heart,size: 21,color: Colors.red,)
                          :
                          Icon(IconBroken.Heart,size: 21,color: Colors.grey,),
                          SizedBox(width: 5,),
                          Text('${model.postLikes.length}',style: Theme.of(context).textTheme.caption,),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(IconBroken.Chat,size: 21,color: Colors.yellow,),
                        SizedBox(width: 4,),
                        Text('${model.postComments.length } ${model.postComments.length>1? 'Comments':'Comment'}',style: Theme.of(context).textTheme.caption,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: myDivider(1,color: Colors.grey[300]),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(3),
                    onTap: () {
                      navigateTo(context, CommentScreen(model.postId.toString(),index));
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                              '${HomeCubit.get(context).userModel?.image}'),
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(width: 15.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Write a comment...',
                                style: Theme.of(context).textTheme.caption!.copyWith(
                                    height: 1.16
                                )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(3),
                  onTap: ()
                  {
                    HomeCubit.get(context).likeUnlikePost(model.postId);
                  },
                  child: Row(
                    children: [
                      Icon(IconBroken.Heart,size: 21,color: Colors.red,),
                      SizedBox(width: 5,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Like',style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 15.0
                        ),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context,state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.4,
                minChildSize: 0.2,
                maxChildSize: 0.75,
                builder: (_, controller) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(25.0),
                        topRight: const Radius.circular(25.0),
                      ),
                    ),
                    child: BuildCondition(
                      condition: HomeCubit.get(context).usersWhoLikes!.length > 0,
                      builder: (context) => Column(
                        children: [
                          Icon(
                            Icons.remove,
                            color: Colors.grey[600],
                          ),
                          Text('People who like'),
                          Expanded(
                            child: ListView.builder(
                              controller: controller,
                              itemCount: HomeCubit.get(context).usersWhoLikes!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(
                                              '${HomeCubit.get(context).usersWhoLikes![index].image}'),
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                      Text('${HomeCubit.get(context).usersWhoLikes![index].name}'),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      fallback: (context) =>Center(child: CircularProgressIndicator(),),
                    )
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

}
