import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

PreferredSizeWidget defaultAppBar (
{
  required BuildContext context,
  String? title,
  Function? function,
  List<Widget>? actions
}) => AppBar(
  leading: Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(IconBroken.Arrow___Left_2),
    ),
  ),
  titleSpacing: 0.0,
  title: Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Text(title.toString(),style: TextStyle(fontSize: 28.0),),
  ),
  actions: actions
);
Widget defaultButton(
    {
      double? height,
      IconData? icon,
      double width = double.infinity,
      double radius = 30.0,
      Color background = customColor,
      required Function function,
      required String text,
      double? textSize = 20.0
    }) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: background,
          boxShadow: [BoxShadow(
            color: Colors.grey.withOpacity(0.5),spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),

          ),]
      ),
      child: MaterialButton(onPressed: () {
        function();
      },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(icon,color: Colors.white,),
              ),
            Text(
              text,
              style: TextStyle(
                  fontSize: textSize,
                  color: Colors.white
              ),
            ),
          ],
        ),
      ),
    );

void navigateTo(context,widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void navigateAndFinish(context,widget) {
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => widget,),
          (route) => false

  );
}

Widget defaultformfield ({
  required TextEditingController controller,
  required TextInputType type,
  Function(String val)? onChanged,
  Function? onSuffixPress,
  String? Function(String? val)? onSupmited,
  Color fillColor = Colors.white,
  Color borderColor = Colors.white,
  String? Function(String? val)? validator,
  required String label,
  IconData? prefix,
  IconData? suffix,
  String? initialValue,
  double contentPadding = 12.2,
  bool isClickable=false,
  bool secure = false,
}

    ) =>
    TextFormField(
      autofocus: false,
      controller: controller,
      initialValue: initialValue,
      obscureText: secure,
      keyboardType: type,
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        contentPadding: new EdgeInsets.symmetric(vertical: contentPadding),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: defaultColor),
          borderRadius: BorderRadius.circular(10.7),


        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(25.7),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(25.7),
        ) ,
        labelText: label,
        prefixIcon: Icon(prefix,),
        suffixIcon: suffix!=null?IconButton(onPressed: () {onSuffixPress!();},
          icon: Icon(suffix,
            color: Colors.grey[600],),):null,
      ),
      onChanged: onChanged,
      readOnly: isClickable,
      validator: validator,
      onFieldSubmitted: onSupmited,

    );

Widget myDivider(double height,{
  Color? color = Colors.grey,
}) =>  Container(
  height: height,
  color: color,
  width: double.infinity,
);

void showToastMessage(String msg)
{
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 19.0
  );

  // void showBottomSheet(context,state) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) {
  //       return GestureDetector(
  //         onTap: () => Navigator.of(context).pop(),
  //         child: Container(
  //           color: Color.fromRGBO(0, 0, 0, 0.001),
  //           child: GestureDetector(
  //             onTap: () {},
  //             child: DraggableScrollableSheet(
  //               initialChildSize: 0.4,
  //               minChildSize: 0.2,
  //               maxChildSize: 0.75,
  //               builder: (_, controller) {
  //                 return Container(
  //                   decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.only(
  //                       topLeft: const Radius.circular(25.0),
  //                       topRight: const Radius.circular(25.0),
  //                     ),
  //                   ),
  //                   child:
  //                   HomeCubit.get(context).usersWhoLikes!.length > 0  ?
  //                   BuildCondition(
  //                     condition: state is !GetLikedUsersLoadingState,
  //                     builder: (context) => Column(
  //                       children: [
  //                         Icon(
  //                           Icons.remove,
  //                           color: Colors.grey[600],
  //                         ),
  //                         Expanded(
  //                           child: ListView.builder(
  //                             controller: controller,
  //                             itemCount: HomeCubit.get(context).usersWhoLikes!.length,
  //                             itemBuilder: (context, index) {
  //                               return Padding(
  //                                 padding: const EdgeInsets.all(8.0),
  //                                 child: Row(
  //                                   children: [
  //                                     Padding(
  //                                       padding: const EdgeInsets.all(8.0),
  //                                       child: CircleAvatar(
  //                                         radius: 20,
  //                                         backgroundImage: NetworkImage(
  //                                             '${HomeCubit.get(context).usersWhoLikes![index].image}'),
  //                                         backgroundColor: Colors.white,
  //                                       ),
  //                                     ),
  //                                     Text('${HomeCubit.get(context).usersWhoLikes![index].name}'),
  //                                   ],
  //                                 ),
  //                               );
  //                             },
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   )
  //                       :
  //                   Center(child: Text('No one like this post yet')),
  //                 );
  //               },
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }



}
