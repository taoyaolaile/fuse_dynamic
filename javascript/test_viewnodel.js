
import {TextWidgetAttribute} from './widget_strategy.js'
 var textWidgetAttribute;
function changeText(key,type,value){
    var textWidgetAttribute =new TextWidgetAttribute(key,type,true,0,value);
    textWidgetAttribute.setText(value);
}
function getText(){
    return textWidgetAttribute.getText();
}