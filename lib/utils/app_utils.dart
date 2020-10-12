

//import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:blog_tuto_ap/helpers/response_ob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
class AppUtils{



  static void showSnackBar(String title,ScaffoldState state,{Color bgColor=Colors.red,Color textColor=Colors.white}){
    state.showSnackBar(SnackBar(
      content: Text(title,style: TextStyle(
        color: textColor,
      ),),
      backgroundColor: bgColor,

    ));

  }


  static Widget loadingWidget({Stream stream,Widget widget}){
    return StreamBuilder<ResponseOb>(
      initialData: ResponseOb(),
      stream:stream,
      builder: (context,snapshot){
        ResponseOb resp=snapshot.data;
        if(resp.message==MsgState.loading){
          return Center(child: Neumorphic(
            style: NeumorphicStyle(
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.circle(),
              depth: -3,
//                lightSource: LightSource.topLeft,
            ),
            child: CircularProgressIndicator(),
          ));
        }else{
          return widget;
        }
      },
    );

  }


}