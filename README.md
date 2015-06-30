# AppGyver Native Input Plugin

This plugins adds a native input field at the bottom of the webview allowing for apps with chat views to have a better user experience where the input field at the bottom will not be hidden by the soft keyboard.

## Usage
### cordova.plugins.NativeInput.show(params)

```
params = {
      leftButton:{
        styleCSS: 'text:hellow;color:blue;background-color:green;'
      },
      rightButton: {
        styleClass: 'myRightButtonClass',
        cssId: 'myRightButton'
      },
      panel: {
        styleClass: 'grey-panel'
      },
      input:{
        placeHolder: 'Type your message here',
        type: ['normal'],
        lines: 1,
        styleClass: 'myInputClass'
      }
 }

 cordova.plugins.NativeInput.show(params);
```

#### leftButton / rightButton
There are the buttons that can be displayed at the left and/or right of the input field.
You can specify the native css using a class, id or in-line css.
```
{
  styleId:'',
  styleClass:'',
  styleCSS:''
}
```
When one of the buttons is tapped the event can be handled using:

```
cordova.plugins.NativeInput.onButtonAction(function(side){
  if("left" === side){
    console.log("left button tapped");
  }
  if("right" === side){
    console.log("right button tapped");
  }
});
```

#### panel
This is the panel that goes behind the input field and buttons.
You can use css to configure it's look and feel.
The default style is with white background.


#### input
The actual input field.
You can use css to configure it's look and feel (styleId, styleClass and styleCSS).

You can also configure the following options:

* type - An array that determines the behaviour of the input field and soft keyboard.

```
value: ['uri', 'normal', 'email', 'number']
```

* placeHolder - Text that appears in the input field while it is empty.

* lines - Number of lines that the input field will support. When you specify 1 the input field is confifure as single line.
When lines > 1 the input field is configure as mult-line and will grow in size as the user adds more lines to the text.

### cordova.plugins.NativeInput.hide()
Hide the whole panel including: buttons, input field and etc.
```
cordova.plugins.NativeInput.hide();
```

### cordova.plugins.NativeInput.onKeyboardAction(autoCloseKeyboard, handler);
```
cordova.plugins.NativeInput.onKeyboardAction(true, function(action){
  ...
});

```
* autoCloseKeyboard: When true it will close the keyboard after any keyboard action is triggered.
* handler: The handle function can be called multiple times when a keyboard action has occurred.
The handler function receives a parameter action with the possible values: done, go, next, send, newline

### cordova.plugins.NativeInput.onButtonAction(handler);
```
cordova.plugins.NativeInput.onButtonAction(function(side){
  if("left" === side){
    console.log("left button tapped");
  }
  if("right" === side){
    console.log("right button tapped");
  }
});
```

The handler function can be called multiple fimes when a button is tapped. It receives a parameter side with the possible values: left, right

### cordova.plugins.NativeInput.closeKeyboard()
Close the soft keyboard.
```
cordova.plugins.NativeInput.closeKeyboard();
```

### cordova.plugins.NativeInput.onChange(handler)
```
cordova.plugins.NativeInput.onChange(function(value){
  ... //do something with the new value
});
```
The handler function will be called multiples times when the content of the input field changes.

### cordova.plugins.NativeInput.getValue(handler)
```
cordova.plugins.NativeInput.getValue(function(value){
  ... //do something with the value
});
```
The handler function will be called once with the current value of the input field.


#Next:
 - iOS Version
 - Ability to specify location (top/bottom) - being able to add this to the top of the webview give developer ability to use it as a search box.
