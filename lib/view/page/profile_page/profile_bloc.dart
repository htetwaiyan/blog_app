import 'dart:convert';
import 'dart:io';

import 'package:blog_tuto_ap/helpers/base_network.dart';
import 'package:blog_tuto_ap/helpers/response_ob.dart';
import 'package:blog_tuto_ap/helpers/shared_pref.dart';
import 'package:blog_tuto_ap/utils/app_constants.dart';
import 'package:blog_tuto_ap/view/page/profile_page/profile_ob.dart';
import 'package:blog_tuto_ap/view/page/profile_page/profile_response_post_ob.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path/path.dart';


class ProfileBloc extends BaseNetwork{



  PublishSubject<ResponseOb> profileController=PublishSubject();
  Stream<ResponseOb> profileStream()=>profileController.stream;


  PublishSubject<ResponseOb> blogController=PublishSubject();
  Stream<ResponseOb> blogStream()=>blogController.stream;





  getProfile()async{

    SharedPref.getData(key: SharedPref.profile).then((str){
      if(str!=null&&str.toString()!="null"){
        ResponseOb resp=ResponseOb(message: MsgState.data);
        resp.data=ProfileResponseOb.fromJson(json.decode(str)).result;
        profileController.sink.add(resp);



      }

    });



    getReq(PROFILE_URL,onDataCallBack: (ResponseOb resp){
      print(resp.data);
      if(resp.data['success']==true){

        SharedPref.setData(key: SharedPref.profile,value:json.encode(resp.data));
        resp.data=ProfileResponseOb.fromJson(resp.data).result;
      }
      profileController.sink.add(resp);
    },errorCallBack: (ResponseOb resp){
      profileController.sink.add(resp);
    });

  }


  getPost()async{



    getReq(USER_POST_URL,onDataCallBack: (ResponseOb resp){
      print(resp.data);
      if(resp.data['success']==true){
        resp.data=ProfileResponsePostOb.fromJson(resp.data).result;//List<ProfilePostOb>
      }
      blogController.sink.add(resp);
    },errorCallBack: (ResponseOb resp){
      blogController.sink.add(resp);
    });

  }






  void dispose(){
    blogController.close();
    profileController.close();
  }


}