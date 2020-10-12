import 'dart:convert';
import 'dart:io';
import 'package:blog_tuto_ap/helpers/response_ob.dart';
import 'package:blog_tuto_ap/helpers/shared_pref.dart';
import 'package:blog_tuto_ap/utils/app_utils.dart';
import 'package:blog_tuto_ap/view/page/home_page/category_response_ob.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';

import 'upload_post_bloc.dart';


class UploadPostPage extends StatefulWidget {
  @override
  _UploadPostPageState createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {

  var selectedCategoryId;

  File _file;//null

  List<CategoryOb> list=[];

  var titleTec=TextEditingController();
  var descTec=TextEditingController();

  var _scaffoldKey=GlobalKey<ScaffoldState>();

  final _bloc=UploadPostBloc();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCategory();

    _bloc.uploadStream().listen((ResponseOb resp){
      if(resp.message==MsgState.data){
        Navigator.of(context).pop(true);
//        print("success");
      }
      if(resp.message==MsgState.error){
        AppUtils.showSnackBar(resp.data, _scaffoldKey.currentState);
      }

    });
  }

  loadCategory(){
    SharedPref.getData(key:SharedPref.category).then((str){
      if(str!=null&&str.toString()!="null"){

        setState(() {
          list=CategoryResponseOb.fromJson(json.decode(str)).result;//List<CategoryOb>
        });



      }

    });
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      appBar: NeumorphicAppBar(
        title: Text("New Post"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(height: 20,),
          NeumorphicButton(
            onPressed:pickImage,
            style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
              depth: 8,
              lightSource: LightSource.topLeft,
            ),
            child: Container(
              height: 200,
              child: _file!=null?Image.file(_file,fit: BoxFit.cover,):Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo),
                  SizedBox(height: 20,),
                  Text("Upload\nPhoto",textAlign: TextAlign.center,),
                ],
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
              controller: titleTec,
              decoration: InputDecoration(
                  hintText: "Enter title",
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
              controller: descTec,
              decoration: InputDecoration(
                  hintText: "Enter Description",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left:10,top: 10,bottom: 10)

              ),
              minLines: 4,
              maxLines: 4,
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
            child: DropdownButtonFormField<int>(
              onChanged: (i){
                selectedCategoryId=i;


              },
              items: list.map((ob){
                return DropdownMenuItem(child: Text(ob.name),value: ob.id,);
              }).toList(),

              decoration: InputDecoration(
                  hintText: "Select Category",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left:10)
              ),

            ),
          ),

          SizedBox(height: 20,),
          AppUtils.loadingWidget(
            stream:_bloc.uploadStream(),
            widget:NeumorphicButton(
              onPressed: uploadData,
              child: Center(
                child: Text("Upload",style: TextStyle(
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
          )






        ],
      ),
    );
  }


  uploadData(){

    if(titleTec.text.isEmpty||descTec.text.isEmpty){
      AppUtils.showSnackBar("Fill Required Fields", _scaffoldKey.currentState);
      return;
    }
    if(selectedCategoryId==null){
      AppUtils.showSnackBar("Select Category", _scaffoldKey.currentState);
      return;
    }
    if(_file==null){
      AppUtils.showSnackBar("Select Image", _scaffoldKey.currentState);
      return;
    }

    Map<String,dynamic> map={
      'title':titleTec.text,
      'description':descTec.text,
      'category_id':selectedCategoryId
    };

    _bloc.uploadPost(map, _file);





  }


  final picker = ImagePicker();


  pickImage()async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 10);

    setState(() {
      if (pickedFile != null) {
        _file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });

  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }


}
