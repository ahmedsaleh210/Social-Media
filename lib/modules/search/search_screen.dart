import 'package:buildcondition/buildcondition.dart';
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

class SearchScreen extends StatelessWidget {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeLayoutStates>(
        listener: (context,state) {},
        builder: (context,state) {
          return  Scaffold(
            appBar: defaultAppBar(context: context,title: 'Search'),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1.0
                          ),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: TextFormField(
                                autofocus: true,
                                controller: searchController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'type your comment here...',
                                ),
                                minLines: 1,
                                maxLines: 3,
                                onFieldSubmitted: (value)
                                {

                                },
                                onChanged: (value)
                                {
                                  HomeCubit.get(context).search(value);
                                },
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: ()
                            {
                            },
                            splashRadius: 25.0,
                            icon: Icon(
                              IconBroken.Search,
                              color: Colors.black54,
                              size: 30.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                    HomeCubit.get(context).searchResult.isNotEmpty && searchController.text.isNotEmpty ?
                    ListView.separated(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) =>searchItem(context, HomeCubit.get(context).searchResult[index], index,state),
                      itemCount:HomeCubit.get(context).searchResult.length,
                      separatorBuilder: (BuildContext context, int index)=>SizedBox(height: 15.0,),

                    )
                        :
                    state is SearchLoadingState ?
                    Center(child: CircularProgressIndicator(),)
                        : Center(child: Text('No Search Result.'),),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  Widget searchItem(context,PostModel model,index,state)
  {
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
