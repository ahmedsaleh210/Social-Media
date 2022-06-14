import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/home/cubit.dart';
import 'package:social_app/layouts/home/states.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chat/chat_details_screen.dart';
import 'package:social_app/shared/components/components.dart';

class ChatScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeLayoutStates>(
      listener: (context,state) {},
      builder: (context,state)
          {
            return BuildCondition(
              condition: HomeCubit.get(context).users.length>0,
              builder: (context) => ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context,index) =>  buildChatItem(HomeCubit.get(context).users[index],context),
                  separatorBuilder: (context,index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: myDivider(0.2),
                  ),
                  itemCount: HomeCubit.get(context).users.length
              ),
              fallback: (context) => Center(child: CircularProgressIndicator(),),
            );
          },
    );
  }
  Widget buildChatItem(UserModel model,context)
  {
    return InkWell(
      onTap: () {
        navigateTo(context, ChatDetails(model));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
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
                          fontSize: 17.5,
                        ),
                      ),
                      SizedBox(width: 3.0,),
                      Icon(Icons.check_circle,size: 16,color: Colors.blue,)
                    ],
                  ),
                  Text(
                      'hello from other size',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          height: 1.15,
                        fontSize: 16.0
                      ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            // IconButton(onPressed: () {
            //   print(uId);
            // }, icon: Icon(
            //     IconBroken.More_Circle
            // ),
            // ),
          ],
        ),
      ),
    );
  }
}
