class WidgetAttribute {
    constructor(key,widgetType,selected,loadNum){
        this.key = key;
        this.widgetType = widgetType;
        this.selected = selected;
        this.loadNum = loadNum;
    }
}

export class TextWidgetAttribute extends WidgetAttribute{
    constructor(key,widgetType,selected,loadNum,text){
        super(key,widgetType,selected,loadNum);
    }
    //设置文本
    setText(value) {
    //通信设置文本值
        this.text = value;
        loadNum+=1;
    }
    //获取文本
    getText(){
        var text = "";
        //通信拿到对应控件的值
        return this.text;
    }
}