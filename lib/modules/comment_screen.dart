import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/home/cubit.dart';
import 'package:social_app/layouts/home/states.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentScreen extends StatelessWidget {
  final String postId;
  final int postIndex;
  CommentScreen(this.postId,this.postIndex);
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeLayoutStates>(
      listener: (context,state) {},
      builder: (context,state)
      {
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Comments',
          ),
          body: Column(
            children: [
              BuildCondition(
                condition: HomeCubit.get(context).posts[postIndex].postComments.length>0,
                builder: (context) => Expanded(
                  child: ListView.separated(
                      itemBuilder: (context,index) => buildCommentItem(HomeCubit.get(context).posts[postIndex].postComments[index],context),
                      separatorBuilder: (context,index) => SizedBox(height: 5,),
                      itemCount: HomeCubit.get(context).posts[postIndex].postComments.length),
                ),
                fallback: (context) => Spacer(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
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
                            controller: commentController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'type your comment here...',
                            ),
                            minLines: 1,
                            maxLines: 3,
                            onFieldSubmitted: (value)
                            {

                            },
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: ()
                        {
                          if (commentController.text.isNotEmpty)
                            {
                              HomeCubit.get(context).addComment
                                (
                                  postID: postId,
                                  comment: CommentModel(
                                      commentId: '0',
                                      text: commentController.text,
                                      user: HomeCubit.get(context).userModel,
                                      dateTime: DateTime.now().toString()
                                  )
                              );
                              commentController.clear();
                            }
                        },
                        splashRadius: 25.0,
                        icon: Icon(
                          IconBroken.Send,
                          color: defaultColor,
                          size: 30.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildCommentItem(CommentModel model,context)
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                      '${model.user!.image}'),
                  backgroundColor: Colors.white,
                ),
              ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8,left: 10,bottom: 8,right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${model.user!.name}',
                          style: TextStyle(
                            fontSize: 15.0,
                            height: 1.2
                          ),
                        ),
                        Text(
                          '${timeago.format(DateTime.parse(model.dateTime.toString()))}',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                              height: 1.3,
                          ),
                        ),
                        SizedBox(height: 6,),
                        Text(
                            '${model.text}',
                            style: Theme.of(context).textTheme.caption!.copyWith(
                                height: 1.16,
                              color: Colors.black.withOpacity(0.68),
                              fontSize: 13.0
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
