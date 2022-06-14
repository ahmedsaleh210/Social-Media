





import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/home/cubit.dart';
import 'package:social_app/layouts/home/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {

  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final phoneController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeLayoutStates>(
      listener: (context,state) {},
      builder: (context,state) {
        var userModel = HomeCubit.get(context).userModel;
        var profileImage = HomeCubit.get(context).profileImage;
        var coverImage = HomeCubit.get(context).coverImage;
        nameController.text = '${userModel?.name}';
        bioController.text = '${userModel?.bio}';
        phoneController.text = '${userModel?.phone}';
        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (HomeCubit.get(context).profileImage!=null)
                    HomeCubit.get(context).profileImage=null;
                  if (HomeCubit.get(context).coverImage!=null)
                    HomeCubit.get(context).coverImage=null;
                },
                icon: Icon(IconBroken.Arrow___Left_2),
              ),
            ),
            titleSpacing: 0.0,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(top:8.0,right: 7.0),
                  child: TextButton(
                      onPressed: () {
                        HomeCubit.get(context).updateUser(
                            name: nameController.text,
                            bio: bioController.text,
                            phone: phoneController.text);
                      },
                      child: Text('Update',
                        style: TextStyle(fontSize: 17),
                      ),
                  ),
                ),
              ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is UpdateUserLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  Container(
                    height: 195,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                height: 150.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                                    image: DecorationImage(
                                      image: coverImage == null ? NetworkImage(
                                          '${userModel?.cover}'):FileImage(coverImage) as ImageProvider,
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
                                              HomeCubit.get(context).getCoverImage();
                                            },
                                            icon: Icon(IconBroken.Camera,size: 19.5,)
                                        ),
                                    ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 64.0,
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 60.0,
                                  backgroundImage: profileImage == null ? NetworkImage(
                                      '${userModel?.image}'):FileImage(profileImage) as ImageProvider,
                                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2.0),
                                  child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.white.withOpacity(0.87),
                                      foregroundColor: Colors.black,
                                      child: Center(
                                          child: IconButton(
                                              onPressed: () {
                                                HomeCubit.get(context).getProfileImage();
                                              },
                                              splashColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              icon: Icon(IconBroken.Camera,size: 17.5,
                                              ),
                                          ),
                                      ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  if(HomeCubit.get(context).coverImage!=null || HomeCubit.get(context).profileImage!=null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0,right: 15,left: 15),
                    child: Row(
                      children: [
                        if (HomeCubit.get(context).profileImage!=null)
                        Expanded(child: Column(
                          children: [
                            defaultButton(function: () {
                              HomeCubit.get(context).uploadProfileImage(
                                  name: nameController.text,
                                  bio: bioController.text,
                                  phone: phoneController.text);
                            }, text: 'Upload Profile',),
                            if(state is UploadProfileImageLoading)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.grey,
                              ),
                            ),
                          ],
                        )),
                        SizedBox(width: 15,),
                        if (HomeCubit.get(context).coverImage!=null)
                        Expanded(child: Column(
                          children: [
                            defaultButton(function: () {
                              HomeCubit.get(context).uploadCoverImage(
                                  name: nameController.text,
                                  bio: bioController.text,
                                  phone: phoneController.text);
                            }, text: 'Upload Cover',),
                            if(state is UploadCoverImageLoading)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.grey,
                              ),
                            ),
                          ],
                        ),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
                    child: Column(
                      children: [
                        defaultformfield
                          (
                            prefix: IconBroken.User,
                            controller: nameController,
                            type: TextInputType.text,
                            label: 'Name',
                            borderColor: Colors.grey.withOpacity(0.4),
                            fillColor: Colors.grey.withOpacity(0.12),
                          contentPadding: 8,
                        ),
                        SizedBox(height: 15,),
                        defaultformfield
                          (
                          prefix: IconBroken.Info_Circle,
                          controller: bioController,
                          type: TextInputType.text,
                          label: 'Bio',
                          borderColor: Colors.grey.withOpacity(0.4),
                          fillColor: Colors.grey.withOpacity(0.12),
                          contentPadding: 8,
                        ),
                        SizedBox(height: 15,),
                        defaultformfield
                          (
                          prefix: IconBroken.Call,
                          controller: phoneController,
                          type: TextInputType.text,
                          label: 'Phone Number',
                          borderColor: Colors.grey.withOpacity(0.4),
                          fillColor: Colors.grey.withOpacity(0.12),
                          contentPadding: 8,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
