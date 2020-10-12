import 'dart:io';

import 'package:blog_tuto_ap/helpers/base_network.dart';
import 'package:blog_tuto_ap/helpers/response_ob.dart';
import 'package:blog_tuto_ap/helpers/shared_pref.dart';
import 'package:blog_tuto_ap/utils/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path/path.dart';


class RegisterBloc extends BaseNetwork{



  PublishSubject<ResponseOb> registerController=PublishSubject();
  Stream<ResponseOb> registerStream()=>registerController.stream;


  register(Map<String,dynamic> map,File _file)async{




    ResponseOb resp=ResponseOb(message: MsgState.loading);
    registerController.sink.add(resp);





    map.addAll({
        'image': await MultipartFile.fromFile(_file.path,filename: basename(_file.path))
    });
    FormData fd=FormData.fromMap(map);


    postReq(REGISTER_URL,fd: fd,onDataCallBack: (ResponseOb resp){
      print(resp.message);//Map

      SharedPref.setData(key: SharedPref.token,value:"Bearer "+resp.data['token']);
      registerController.sink.add(resp);


    },errorCallBack: (ResponseOb resp){
      registerController.sink.add(resp);
    });



  }






  dispose(){
    registerController.close();
  }


}