# 通过flutter 生成一个JSON ，在通过flutter根据JSON 去生成UI界面
##  Flutter View => JSON Tree => Flutter View
# 逻辑交互线路 通过UI操作js，在通过js操作预制的部分逻辑，例如网络请求、访问设备信息、访问本地存储等
##  Flutter ViewModel <= jsModel <= Flutter View
##  第一：先定义一套 Flutter to JS  和 JS to Flutter 的通信规则
##  第二：定义调用基础功能的接口，例如网络请求、访问设备信息、访问本地存储等
##  第三：定义UI界面和逻辑交互的接口，例如修改界面显示的值、修改界面显示的值等
##  第四：定义UI逻辑交互的接口，例如点击事件、输入事件等
