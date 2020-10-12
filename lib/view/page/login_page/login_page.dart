import 'package:blog_tuto_ap/helpers/response_ob.dart';
import 'package:blog_tuto_ap/utils/app_utils.dart';
import 'package:blog_tuto_ap/view/page/home_page/home_page.dart';
import 'package:blog_tuto_ap/view/page/regsiter_page/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'login_bloc.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  var emailTec=TextEditingController();
  var passwordTec=TextEditingController();
  var _scaffoldKey=GlobalKey<ScaffoldState>();

  final _bloc=LoginBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc.loginStream().listen((ResponseOb resp) {
      if(resp.message==MsgState.data){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) {
          return HomePage();
        }), (route) => false);

      }
      if(resp.message==MsgState.error){
        if(resp.errState==ErrState.userErr){
          AppUtils.showSnackBar(resp.data.toString(), _scaffoldKey.currentState);
        }else {
          AppUtils.showSnackBar("Something Wrong!", _scaffoldKey.currentState);
        }
      }
    });


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 80,),
            FlutterLogo(
              size: 100,
            ),
            SizedBox(height: 80,),

            Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: -4,
                lightSource: LightSource.topLeft,
//                    color: Colors.grey
              ),
              child: TextField(
                controller: emailTec,
                decoration: InputDecoration(
                    hintText: "Enter Email",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left:10)
                ),
              ),
            ),


            SizedBox(height: 20,),


            Neumorphic(
                style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                    depth: -4,
                    lightSource: LightSource.topLeft,
//                    color: Colors.grey
                ),
                child: TextField(
                  controller: passwordTec,
                  decoration: InputDecoration(
                      hintText: "Enter Password",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left:10)
                  ),
                  obscureText: true,
                ),
            ),


            SizedBox(height: 30,),
           AppUtils.loadingWidget(stream:_bloc.loginStream(),
               widget:NeumorphicButton(
              onPressed:checkLogin,
              child: Center(
                child: Text("Login",style: TextStyle(
                    fontWeight: FontWeight.bold
                ),),
              ),
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: 8,
//                lightSource: LightSource.topLeft,
              ),
            )),
             SizedBox(height: 20,),
             NeumorphicButton(
               onPressed: (){
                 Navigator.of(context).push(MaterialPageRoute(builder: (context){
                   return RegisterPage();
                 }));
               },
              child: Center(
                child: Text("Register",style: TextStyle(
                  fontWeight: FontWeight.bold
                ),),
              ),
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: 8,
//                lightSource: LightSource.topLeft,
              ),
            )



          ],
        ),
      ),


    );
  }





  checkLogin (){
    if(emailTec.text.isEmpty||passwordTec.text.isEmpty){
      AppUtils.showSnackBar("Fill Data", _scaffoldKey.currentState);
      return;
    }

    Map<String,String> map={
      'email':emailTec.text,
      'password':passwordTec.text,
    };

    _bloc.login(map);

  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();

  }

}
