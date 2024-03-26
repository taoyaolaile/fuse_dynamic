import 'package:flutter/material.dart';


///
///                      /^--^\     /^--^\     /^--^\
///                      \____/     \____/     \____/
///                     /      \   /      \   /      \
///                    |        | |        | |        |
///                     \__  __/   \__  __/   \__  __/
///|^|^|^|^|^|^|^|^|^|^|^|^\ \^|^|^|^/ /^|^|^|^|^\ \^|^|^|^|^|^|^|^|^|^|^|^|
///| | | | | | | | | | | | |\ \| | |/ /| | | | | |\ \| | | | | | | | | | | |
///| | | | | | | | | | | | |/ /| |  \ \| | | | | |/ /| | | | | | | | | | | |
///| | | | | | | | | | | | |\/ | | | \/| | | | | |\/ | | | | | | | | | | | |
///|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|
///
///
///               代码无BUG!
///         写字楼里写字间，写字间里程序员；
///         程序人员写程序，又拿程序换酒钱。
///         酒醒只在网上坐，酒醉还来网下眠；
///         酒醉酒醒日复日，网上网下年复年。
///         但愿老死电脑间，不愿鞠躬老板前；
///         奔驰宝马贵者趣，公交自行程序员。
///         别人笑我忒疯癫，我笑自己命太贱；
///         不见满街漂亮妹，哪个归得程序员？
///
///
///文件作者 ：陈涛
///创建日期 ：2023/3/2
///文件描述 ：
///修改的人 :
///修改时间 ：
///修改备注 ：

class AccountFilterWidget<T> extends StatefulWidget {
  Offset origin;
  List<T> filters = [];
  int currentIndex;
  void Function(int)? onSelected;
  AccountFilterWidget({   required this.origin,required this.filters,this.onSelected,this.currentIndex=0,Key? key}) : super(key: key);

  @override
  State<AccountFilterWidget> createState() => _AccountFilterWidgetState();
}

class _AccountFilterWidgetState extends State<AccountFilterWidget>  {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              // 设置一个容器组件，是整屏幕的。
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent, // 它的颜色为透明色
            ),
          ),
          // Positioned(
          //     top: widget.origin.dy ,
          //     left: 0,
          //     right: 0,
          //     child: GestureDetector(
          //       onTap: () {
          //         Navigator.pop(context);
          //       },
          //       child: Container(
          //           width: MediaQuery.of(context).size.width,
          //           height: MediaQuery.of(context).size.height,
          //           color: Colors.black.withOpacity(0.3)),
          //     )),
          Positioned(
              top: widget.origin.dy,
              right: 5,
              child: Container(
                  width:200,

                  height:(55*widget.filters.length).toDouble(),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(width: 1, color: const Color(0xffe8e8e8))),
                  child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {

                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            if (widget.onSelected != null) {
                              widget.onSelected!(index);
                            }
                          },
                          child: Container(
                              color: Colors.transparent,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              height: 55,
                              child: Flex(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Expanded(flex: 0,child:  widget.currentIndex == widget.filters[index].value
                                      ? Container(
                                    width: 30,
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 0, 5, 0),
                                    child: const Icon(Icons.check,color: Colors.red,),
                                  )
                                      : Container(
                                    width: 30,
                                  ),),
                                  Expanded(flex: 1,child: Text(
                                    widget.filters[index].title,
                                    style: TextStyle(
                                        fontSize:14,
                                        color:  widget.currentIndex == widget.filters[index].value
                                            ?Colors.red
                                            : Colors.black),
                                  ),)
                                ],
                              )),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Container(
                          height: 1,
                          color: Colors.grey,
                        );
                      },
                      itemCount: widget.filters.length)))
        ],
      ),
    );
  }
}
