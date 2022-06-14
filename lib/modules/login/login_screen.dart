import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_app/layouts/home/cubit.dart';
import 'package:social_app/layouts/home/home_layout.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_app/modules/login/login_cubit.dart';
import 'package:social_app/modules/login/login_states.dart';
import 'package:social_app/modules/register/register_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/local/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  final emailcontroller = TextEditingController();
  final passwordconroller= TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit,ShopLoginStates>(
        listener: (context,state) {
          if (state is LoginErrorStates)
            showToastMessage(state.error);
          if (state is LoginSucessStates) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              navigateAndFinish(context, HomeLayout());
              print(CacheHelper.getData(key: 'uId'));
            });
            HomeCubit.get(context).getUserData();
            HomeCubit.get(context).getPosts();
          }
        },
        builder: (context,state) {
          var cubit = LoginCubit.get(context);
          return  Scaffold(
            backgroundColor: Colors.white.withOpacity(0.98),
              appBar: AppBar(
                backgroundColor: Colors.white.withOpacity(0.02),
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 19.0,
                        left: 19.0,
                        top: 20.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text('Log in',
                                style: TextStyle(
                                    fontSize: 35,
                                  fontWeight: FontWeight.w800
                                ),),
                              SizedBox(height:15.0,)
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: defaultButton(function: () {}, text: 'Facebook',radius: 30,background: HexColor('4267B2'),icon: Icons.facebook,textSize: 17.0)),
                              SizedBox(width: 15,),
                              Expanded(child: defaultButton(function: () {}, text: 'Google',radius: 30,background: HexColor('DB4437'),icon: MdiIcons.google,textSize: 17.0),),
                            ],
                          ),
                          SizedBox(height:30.0,),
                          Center(
                            child: Text('Or Sign in with email',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15.0
                              ),),
                          ),
                          SizedBox(height:25.0,),
                          Center(
                            child: Form(
                              key: formkey,
                              child: Column(
                                children: [
                                  defaultformfield(

                                      controller: emailcontroller,
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
                                  SizedBox(height:10,),
                                  defaultformfield(
                                      controller: passwordconroller,
                                      type: TextInputType.visiblePassword,
                                      secure: cubit.isShown?false:true,
                                      label: 'Password',
                                      suffix: cubit.isShown?Icons.visibility:Icons.visibility_off,
                                      prefix: Icons.lock_outline,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Password is empty';
                                        }
                                        return null;
                                      },
                                      onSupmited: (value) {
                                        if (formkey.currentState!.validate())
                                        {
                                          cubit.userLogin(
                                              email: emailcontroller.text,
                                              password: passwordconroller.text);
                                        }
                                      },
                                      onSuffixPress: () {
                                        cubit.changePasswordSecure();
                                      }
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5.0),
                            child: Row(
                              children: [
                                Spacer(),
                                TextButton(onPressed: (){}, child: Text('Forget Password?',style: TextStyle(fontSize: 15,color: Colors.grey),)),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              BuildCondition(
                                condition: state is !LoginLoadingStates,
                                builder: (context) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                                  child: defaultButton(function: () {
                                    if (formkey.currentState!.validate())
                                    {
                                      cubit.userLogin(
                                          email: emailcontroller.text,
                                          password: passwordconroller.text);
                                    }
                                  },
                                    text: 'Sign In',
                                    height: 50,
                                  ),
                                ) ,
                                fallback: (context) => Center(child: CircularProgressIndicator(
                                  strokeWidth: 7,
                                )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Don\'t have an account?',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey
                                ),
                              ),
                              TextButton(onPressed: () {
                                navigateTo(context, RegisterScreen());
                              }, child: Text(''
                                  'Sign Up',
                                style: TextStyle(
                                  fontSize: 17,

                                ),
                              ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          );
        },
      ),
    );
  }
}
