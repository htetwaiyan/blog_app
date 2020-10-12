import 'package:blog_tuto_ap/helpers/shared_pref.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'response_ob.dart';

enum RequestType{
  Get,
  Post
}



class BaseNetwork{


  void getReq(String url,{Map<String,String> params,Function onDataCallBack,Function errorCallBack})async{
    requestData(RequestType.Get, url: url,params: params,onDataCallBack: onDataCallBack,errorCallBack: errorCallBack);

  }
  void postReq(String url,{Map<String,String> params,FormData fd,Function onDataCallBack,Function errorCallBack})async{

    requestData(RequestType.Post, url: url,params: params,fd: fd,onDataCallBack: onDataCallBack,errorCallBack: errorCallBack);

  }


  void  requestData(RequestType rt,{@required String url,Map<String,String> params,FormData fd,Function onDataCallBack,Function errorCallBack})async{

    BaseOptions options=BaseOptions();
    options.connectTimeout=10000;
    options.receiveTimeout=10000;

    String token=await SharedPref.getData(key: SharedPref.token);
    options.headers={
      'Authorization': token,
    };


    Dio dio=new Dio(options);

    try {
      Response response;
      if (rt == RequestType.Get) {
        if (params == null) {
          response = await dio.get(url);
        } else {
          response = await dio.get(url, queryParameters: params);
        }
      } else {
        if (params != null || fd != null) {
          response = await dio.post(url, data: fd ?? params);
        } else {
          response = await dio.post(url);
        }
      }

      int statusCode = response.statusCode;

      ResponseOb respOb = new ResponseOb(); //data,message,err
      print('*************\n');
      print(url);
      print(statusCode);
      print(response.data);
      print('*************\n');

      if (statusCode == 200) {
        //data
        if(response.data['success']==true) {
          respOb.data = response.data;
          respOb.message = MsgState.data;
          onDataCallBack(respOb);
        }else{
          respOb.data=response.data['result'];
          respOb.message=MsgState.error;
          respOb.errState=ErrState.userErr;
          errorCallBack(respOb);
        }

      } else {
        //error
        respOb.errState = ErrState.serverError;
        respOb.message = MsgState.error;
        errorCallBack(respOb);
      }
    }catch(e){
      ResponseOb respOb = new ResponseOb(); //data,message,err

      respOb.errState = ErrState.serverError;
      respOb.message = MsgState.error;
      errorCallBack(respOb);
    }

  }









}