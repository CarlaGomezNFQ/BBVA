global interface Clib_IQuickAction {
    /*
    * You can return a String with the following format: {ToastFormat}#{Message}
    * Then, if you have the showToast attribute set to true in the component, it will shown a toast with a custom message
    * f.i: Success#Quick action executed successfuly
    */
    String switcher(String method, Id recordId);
}