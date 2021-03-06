
/**
 * Native Input Plugin
 */
(function() {
  var exec = require("cordova/exec") ,
      SERVICE_NAME = "NativeInput" ,
      NativeInput = {};

  NativeInput.setup = function(params, cb, err) {

    params = params || {};

    exec(cb, err, SERVICE_NAME, "setup", [params.panel,
                                            params.input,
                                            params.leftButton,
                                            params.rightButton]);
  };
  
  NativeInput.showKeyboard = function(cb, err) {
    exec(cb, err, SERVICE_NAME, "showKeyboard", []);
  };
  
  NativeInput.show = function(text, cb, err) {
    exec(cb, err, SERVICE_NAME, "show", [text]);
  };

  NativeInput.closeKeyboard = function(cb, err) {
    exec(cb, err, SERVICE_NAME, "closeKeyboard", []);
  };

  NativeInput.onButtonAction = function(cb, err) {
    exec(cb, err, SERVICE_NAME, "onButtonAction", []);
  };

  NativeInput.onKeyboardAction = function(autoClose, cb, err) {
    autoClose = autoClose || true;    
    exec(cb, err, SERVICE_NAME, "onKeyboardAction", [autoClose]);
  };

  NativeInput.hide = function(cb, err) {
    exec(cb, err, SERVICE_NAME, "hide", []);
  };

  NativeInput.onChange = function(cb, err) {
    exec(cb, err, SERVICE_NAME, "onChange", []);
  };
  
  NativeInput.onFocus = function(cb, err) {
    exec(cb, err, SERVICE_NAME, "onFocus", []);
  };
  
  NativeInput.onBlur = function(cb, err) {
    exec(cb, err, SERVICE_NAME, "onBlur", []);
  };
  
  NativeInput.onShow = function(cb, err) {
    exec(cb, err, SERVICE_NAME, "onShow", []);
  };
  
  NativeInput.onHide = function(cb, err) {
    exec(cb, err, SERVICE_NAME, "onHide", []);
  };

  NativeInput.getValue = function(cb, err) {
    exec(cb, err, SERVICE_NAME, "getValue", []);
  };

  NativeInput.setValue = function(strText, cb, err) {
    strText = strText || '';
    exec(cb, err, SERVICE_NAME, "setValue", [strText]);
  };

  module.exports = NativeInput;

})();
