import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_app/layouts/home/cubit.dart';
import 'package:social_app/layouts/home/home_layout.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/modules/register/register_cubit.dart';
import 'package:social_app/modules/register/register_states.dart';
import 'package:social_app/shared/components/components.dart';

class RegisterScreen extends StatelessWidget {
  final registerFormKey = GlobalKey<FormState>();
  final registerScaffoldKey = GlobalKey<ScaffoldState>();
  final registerEmailcontroller = TextEditingController();
  final registerPasswordcontroller = TextEditingController();
  final passwordConfirmcontroller = TextEditingController();
  final nameOfUsercontroller = TextEditingController();
  final phonecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit,ShopRegisterStates>(
          listener: (context,state)
          {
            if (state is CreateUserSucessStates) {
              navigateAndFinish(context, HomeLayout());
              HomeCubit.get(context).getUserData();
              HomeCubit.get(context).getPosts();
        }
      } ,
          builder: (context,state) {
            var cubit = RegisterCubit.get(context);
            return Scaffold(
                backgroundColor: Colors.white.withOpacity(0.97),
                appBar: AppBar(
                  backgroundColor: Colors.white.withOpacity(0.03),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sign up',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(height:20.0,),
                        Row(

                          children: [
                            Expanded(child: defaultButton(function: () {}, text: 'Facebook',radius: 30,background: HexColor('4267B2'),icon: Icons.facebook,textSize: 17.0)),
                            SizedBox(width: 15,),
                            Expanded(child: defaultButton(function: () {}, text: 'Google',radius: 30,background: HexColor('DB4437'),icon: MdiIcons.google,textSize: 17.0),),
                          ],
                        ),
                        SizedBox(height:25.0,),
                        Center(
                          child: Text('Or Sign up with email',
                            style: TextStyle(
                              color: Colors.grey,
                                fontSize: 15.0
                            ),),
                        ),
                        SizedBox(height: 20,),
                        Form(
                          key: registerFormKey,
                          child: Column(
                            children: [
                              defaultformfield(
                                  controller: nameOfUsercontroller,
                                  type: TextInputType.text,

                                  label: 'Name',
                                  prefix: Icons.person,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Name is empty';
                                    }
                                    return null;
                                  }
                              ),
                              SizedBox(height: 10,),
                              defaultformfield(
                                  controller: registerEmailcontroller,
                                  type: TextInputType.emailAddress,

                                  label: 'Email Address',
                                  prefix: Icons.email_outlined,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Email is empty';
                                    }
                                    return null;
                                  }
                              ),
                              SizedBox(height: 10,),
                              defaultformfield(
                                  controller: phonecontroller,
                                  type: TextInputType.phone,
                                  label: 'Phone Number',
                                  prefix: Icons.phone,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Phone Number is empty';
                                    }
                                    return null;
                                  }
                              ),
                              SizedBox(height: 10,),
                              defaultformfield(
                                  controller: registerPasswordcontroller,
                                  type: TextInputType.visiblePassword,
                                  secure: cubit.isShownPass?false:true,
                                  label: 'Password',
                                  suffix: cubit.isShownPass?Icons.visibility:Icons.visibility_off,
                                  prefix: Icons.lock_outline,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Password is empty';
                                    }
                                    else if (value != passwordConfirmcontroller.text)
                                    {
                                      return ('Does not match confirm password');
                                    }
                                    return null;
                                  },
                                  onSuffixPress: ()
                                  {
                                    cubit.changePasswordSecure();
                                  }
                              ),
                              SizedBox(height: 10,),
                              defaultformfield(
                                  controller: passwordConfirmcontroller,
                                  type: TextInputType.visiblePassword,
                                  secure: cubit.isShownConfirm?false:true,
                                  label: 'Confirm Password',
                                  suffix: cubit.isShownConfirm?Icons.visibility:Icons.visibility_off,
                                  prefix: Icons.lock_outline,
                                  validator: (value) {
                                    if (value!.isEmpty)
                                    {
                                      return 'Confirm Password is empty';
                                    }
                                    else if (value != registerPasswordcontroller.text)
                                    {
                                      return ('Does not match password');
                                    }
                                    return null;
                                  },
                                  onSupmited: (value) {
                                    if (registerFormKey.currentState!.validate())
                                    {
                                    }
                                  },
                                  onSuffixPress: ()
                                  {
                                    cubit.changeConfirmPassSecure();
                                  }
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        BuildCondition(
                          condition: state is !RegisterLoadingStates,
                          builder: (context) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 35,
                              vertical: 10,
                            ),
                            child: defaultButton(
                                function: () {
                                  if (registerFormKey.currentState!.validate())
                                  {
                                    cubit.userRegister(
                                        email: registerEmailcontroller.text,
                                        password: registerPasswordcontroller.text,
                                        name: nameOfUsercontroller.text,
                                        phone: phonecontroller.text);
                                  }
                                },
                                text: 'Sign up'),
                          ),
                          fallback: (context) => Center(child: CircularProgressIndicator(),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text('By signing up, You agreed with our terms of \n Services and Privacy Policy',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey
                            ),),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Already have an account?',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                ),),
                              TextButton(
                                onPressed: () {
                                  navigateTo(context, LoginScreen());
                                },
                                child: Text('Sign In',
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),

                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
            );
          }
      ),
    );
  }
}