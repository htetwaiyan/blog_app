import 'dart:io';

import 'package:blog_tuto_ap/helpers/base_network.dart';
import 'package:blog_tuto_ap/helpers/response_ob.dart';
import 'package:blog_tuto_ap/helpers/shared_pref.dart';
import 'package:blog_tuto_ap/utils/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path/path.dart';


class UploadPostBloc extends BaseNetwork{



  PublishSubject<ResponseOb> uploadController=PublishSubject();
  Stream<ResponseOb> uploadStream()=>uploadController.stream;


  uploadPost(Map<String,dynamic> map,File _file)async{
    ResponseOb resp=ResponseOb(message: MsgState.loading);
    uploadController.sink.add(resp);


    map.addAll({
      'image': await MultipartFile.fromFile(_file.path,filename: basename(_file.path))
    });
    FormData fd=FormData.fromMap(map);


    postReq(CREATE_URL,fd: fd,onDataCallBack: (ResponseOb resp){
      print(resp.message);//Map

      uploadController.sink.add(resp);


    },errorCallBack: (ResponseOb resp){
      uploadController.sink.add(resp);
    });



  }






  dispose(){
    uploadController.close();
  }


}