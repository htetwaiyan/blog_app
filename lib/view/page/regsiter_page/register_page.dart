import 'dart:io';

import 'package:blog_tuto_ap/helpers/response_ob.dart';
import 'package:blog_tuto_ap/utils/app_utils.dart';
import 'package:blog_tuto_ap/view/page/home_page/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';


import 'register_bloc.dart';



class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {


  File _file;//null
  var emailTec=TextEditingController();
  var nameTec=TextEditingController();
  var passwordTec=TextEditingController();

  var _scaffoldKey=GlobalKey<ScaffoldState>();

  final _bloc=RegisterBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.registerStream().listen((ResponseOb resp){
      if(resp.message==MsgState.data){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) {
          return HomePage();
        }), (route) => false);

      }
      if(resp.message==MsgState.error){
        AppUtils.showSnackBar("Something Wrong!", _scaffoldKey.currentState);
      }

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      appBar: NeumorphicAppBar(
        title: Text("Register"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20,),
            NeumorphicButton(
              onPressed: pickImage,
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape: NeumorphicBoxShape.circle(),
                depth: 8,
                lightSource: LightSource.topLeft,
              ),
              child: Container(
                width: 100,
                height: 100,
                child: _file!=null? Image.file(_file,fit: BoxFit.cover,): Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person),
                    Text("Upload\nPhoto",textAlign: TextAlign.center,),
                  ],
                ),
              ),
            ),

            SizedBox(height: 50,),
            Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: -4,
                lightSource: LightSource.topLeft,
//                    color: Colors.grey
              ),
              child: TextField(
                controller: nameTec,
                decoration: InputDecoration(
                    hintText: "Enter Name",
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

            SizedBox(height: 20,),
            AppUtils.loadingWidget(
              stream:_bloc.registerStream(),
              widget:NeumorphicButton(
                onPressed: checkRegister,
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
              ),
            )
          ],
        ),
      ),
    );
  }

  final picker = ImagePicker();


  pickImage()async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });

  }


  checkRegister()async{
    if(emailTec.text.isEmpty||passwordTec.text.isEmpty||nameTec.text.isEmpty){
      AppUtils.showSnackBar("Fill Data", _scaffoldKey.currentState);
      return;
    }
    if(_file==null){
      AppUtils.showSnackBar("Select Image", _scaffoldKey.currentState);
      return;
    }

    Map<String,dynamic> map={
      'email':emailTec.text,
      'password':passwordTec.text,
      'name':nameTec.text,

    };

    _bloc.register(map,_file);
  }


  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

}
