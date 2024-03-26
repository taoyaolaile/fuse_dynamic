import 'package:flutter/material.dart';


class PopBottomWindow {
  PopBottomWindow({this.contentWidget, this.closeWindow, this.listWidget});

  Widget Function(BuildContext context, StateSetter? setState)? contentWidget;
  Widget Function(BuildContext context, StateSetter setState)? listWidget;
  void Function()? closeWindow;
  void myPop(BuildContext context) {
    Navigator.pop(context);
  }

//  通用底部弹出List框
  void showListWindow(BuildContext context,
      {String title = "",
      String right = "",
      bool isScrollControlled = false}) async {
    if (listWidget == null) {
      return;
    }
    final option = showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: isScrollControlled,
        builder: (BuildContext con) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return Container(
                width: double.maxFinite,
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10))),
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Expanded(
                      flex: 0,
                      child: SizedBox(
                        width: double.maxFinite,
                        height: 45,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Positioned(
                              left: 0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(13, 12, 13, 12),
                                  child: Icon(Icons.close,size: 15,color: Colors.black,),
                                ),
                              ),
                            ),
                            Text(
                              title,
                              style:
                                  const TextStyle(fontSize: 12, color: Colors.white),
                            ),
                            Positioned(
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(13, 12, 13, 12),
                                  child: Text(
                                    right,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                          color: Colors.white,
                          height: double.maxFinite,
                          width: double.maxFinite,
                          child: listWidget!(context, setDialogState)),
                    )
                  ],
                ),
              );
            },
          );
        }).then((value) {
      if (closeWindow != null) {
        closeWindow!();
      }
    });
  }

//  通用底部弹窗
  void showWindow(BuildContext context,
      {String? title,
      Widget? right,
      bool isScrollControlled = false,
      bool isTitleBar = true}) async {
    if (contentWidget == null) {
      return;
    }
    final option = showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: isScrollControlled,
        builder: (BuildContext con) {
          if (!isScrollControlled) {
            return StatefulBuilder(
              builder: (context, setDialogState) {
                return Container(
                  width: double.maxFinite,
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10))),
                  child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      if (isTitleBar)
                        Expanded(
                          flex: 0,
                          child: SizedBox(
                            width: double.maxFinite,
                            height: 45,
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Positioned(
                                  left: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          13, 12, 13, 12),
                                      child: Icon(Icons.close,size: 15,color: Colors.black,),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: right ?? Container(),
                                ),
                                Text(
                                  title ?? "",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      if (!isScrollControlled)
                        Expanded(
                            flex: 1,
                            child: Container(
                              color: Colors.white,
                              height: double.maxFinite,
                              width: double.maxFinite,
                              child: contentWidget!(context,setDialogState),
                            )),
                      if (isScrollControlled) contentWidget!(context,setDialogState)
                    ],
                  ),
                );
              },
            );
          } else {
            return contentWidget!(context,null);
          }
        });
  }
}
