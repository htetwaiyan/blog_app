import 'package:blog_tuto_ap/helpers/base_network.dart';
import 'package:blog_tuto_ap/helpers/response_ob.dart';
import 'package:blog_tuto_ap/helpers/shared_pref.dart';
import 'package:blog_tuto_ap/utils/app_constants.dart';
import 'package:rxdart/rxdart.dart';


class LoginBloc extends BaseNetwork{



  PublishSubject<ResponseOb> loginController=PublishSubject();
  Stream<ResponseOb> loginStream()=>loginController.stream;


  login(Map<String,String> map){

    ResponseOb resp=ResponseOb(message: MsgState.loading);
    loginController.sink.add(resp);



    postReq(LOGIN_URL,params: map,onDataCallBack: (ResponseOb resp){
      print(resp.message);//Map

      SharedPref.setData(key: SharedPref.token,value:"Bearer "+resp.data['token']);
      loginController.sink.add(resp);


    },errorCallBack: (ResponseOb resp){
      loginController.sink.add(resp);
    });



  }






  dispose(){
    loginController.close();
  }


}