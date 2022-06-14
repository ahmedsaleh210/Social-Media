import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_app/layouts/home/cubit.dart';
import 'package:social_app/layouts/home/states.dart';
import 'package:social_app/modules/feed/feed_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class NewPostScreen extends StatelessWidget {

  final textController = TextEditingController();
  final now = DateTime.now();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeLayoutStates>(
      listener: (context,state) {
        if (state is CreateNewPostSucessState)
          Navigator.pop(context);
      },
      builder: (context,state) {
        return  Scaffold(
          appBar: defaultAppBar(context:
          context,
              title: 'Create Post',
              actions: [
                TextButton(
                  onPressed: (){
                    if (textController.text.isNotEmpty || HomeCubit.get(context).postImage != null)
                    {
                  if (HomeCubit.get(context).postImage == null)
                    HomeCubit.get(context).createPost(
                        dateTime: now.toString(),
                        postText: textController.text);
                  else
                    HomeCubit.get(context).uploadPostImage(
                      dateTime: now.toString(),
                      postText: textController.text,
                    );
                }
                    else showToastMessage('please add something to share with your friends');
                  },
                    child:
                    Text('Post',
                      style: TextStyle(
                  fontSize: 18,
                ),
                    ),
                ),
              ]
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              [
                if (state is CreateNewPostLoadingState)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                          '${HomeCubit.get(context).userModel!.image}'),
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
                                '${HomeCubit.get(context).userModel!.name}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
               Expanded(
                 child: Form(
                   key: formkey,
                   child: TextFormField(
                     controller: textController,
                     keyboardType: TextInputType.text,
                     maxLines: null,
                     decoration: InputDecoration(
                       hintText: 'What\'s on your mind ...',
                       border: InputBorder.none
                     ),
                       validator: (value) {
                         if (value!.isEmpty) {
                           return 'please write some words';
                         }
                         return null;
                       }
                   ),
                 ),
               ),
                if(HomeCubit.get(context).postImage!=null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 35.0),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          height: 150.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              image: DecorationImage(
                                image: FileImage(HomeCubit.get(context).postImage!),
                                fit: BoxFit.cover,
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: CircleAvatar(
                            radius: 17,
                            backgroundColor: Colors.white.withOpacity(0.85),
                            foregroundColor: Colors.black,
                            child: Center(
                              child: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: () {
                                    HomeCubit.get(context).removePostImage();
                                  },
                                  icon: Icon(MdiIcons.close,size: 19.5,)
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(onPressed: () {
                        HomeCubit.get(context).getPostImage();
                      }, child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(IconBroken.Image,size: 25.0,),
                          SizedBox(width: 7,),
                          Text('add photo',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(onPressed: () {}, child:
                      Text('# tags',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      ),
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
