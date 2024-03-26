import 'package:flutter/material.dart';

class PopMiddleWindow{
   BuildContext context;
   bool barrierDismissible;
   PopMiddleWindow(this.context,this.builder,{this.barrierDismissible =true});
   Widget Function(BuildContext context) builder;
  Future showMiddleWindow(){
    return  showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }

}