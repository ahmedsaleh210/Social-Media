import 'dart:async';

import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/home/cubit.dart';
import 'package:social_app/layouts/home/states.dart';
import 'package:social_app/models/chat_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ChatDetails extends StatelessWidget {
  final UserModel model;
  ChatDetails(this.model);
  final messageController = TextEditingController();
  final listController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context )
      {
        HomeCubit.get(context).getMessages
          (
            receiverId: model.uId.toString()

      );
       return BlocConsumer<HomeCubit,HomeLayoutStates>(
          listener: (context,state) {
            if(state is SendMessageSucessState)
            {
              Timer(Duration(seconds: 1), ()=>listController.jumpTo(listController.position.maxScrollExtent));
            }
          },
          builder: (context,state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                          '${model.image}'),
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(width: 10,),
                    Text('${model.name}',
                      style: TextStyle(
                        fontSize: 20,
                      ),),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    BuildCondition(
                      condition: state is !GetMessageLoadingState,
                      builder: (context)
                      {
                        Timer(Duration(seconds: 0), ()=>listController.jumpTo(listController.position.maxScrollExtent));
                        return Expanded(
                        child: HomeCubit.get(context).messages.length>0?
                        ListView.separated(
                            controller: listController,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              var messages = HomeCubit
                                  .get(context)
                                  .messages[index];
                              if (HomeCubit
                                  .get(context)
                                  .userModel!
                                  .uId == messages.senderId)
                                return buildSenderMessage(messages);
                              else
                                return buildReceiverMessage(messages);
                            },
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 15,),
                            itemCount: HomeCubit
                                .get(context)
                                .messages
                                .length)
                          :Center(child: Text('No Messages has sent yet')),
                      );},
                      fallback: (context) => Expanded(child: Center(child: CircularProgressIndicator(),)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        //clipBehavior: Clip.antiAliasWithSaveLayer,
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
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  maxLines: 3,
                                  controller: messageController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'type your message here...',
                                  ),
                                  onFieldSubmitted: (value)
                                  {
                                    if (messageController.text.isNotEmpty) {
                                      HomeCubit.get(context).sendMessage(
                                        receiverId: model.uId.toString(),
                                        dateTime: DateTime.now().toString(),
                                        text: messageController.text,
                                      );
                                      messageController.clear();
                                    }
                                  },
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: ()
                              {
                                if (messageController.text.isNotEmpty) {
                                  HomeCubit.get(context).sendMessage(
                                    receiverId: model.uId.toString(),
                                    dateTime: DateTime.now().toString(),
                                    text: messageController.text,
                                  );
                                  messageController.clear();
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
              ),
            );
          },
        );
      },
    );
  }

  Widget buildReceiverMessage(ChatModel model)
  {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              )
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 10.0
            ),
            child: Text('${model.text}'),
          )
      ),
    );
  }

  Widget buildSenderMessage(ChatModel model)
  {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
          decoration: BoxDecoration(
              color: defaultColor.withOpacity(0.4),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              )
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 10.0
            ),
            child: Text('${model.text}'),
          )
      ),
    );
  }
}
