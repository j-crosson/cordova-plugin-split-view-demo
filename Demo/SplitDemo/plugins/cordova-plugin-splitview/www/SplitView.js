
var exec = require('cordova/exec');

var PLUGIN_NAME = 'SplitView';

var SplitView = function() {};


//
// create and show split view
//

SplitView.prototype.showView = function (viewProps, primaryProps, secondaryProps, supProps,compactProps, success, error) {
exec(success, error, 'SplitView', 'showView', [viewProps, primaryProps, secondaryProps, supProps,compactProps]);
};

//
// show or hide view
//

SplitView.prototype.display = function (show_hide, view, success, error) {
        exec(success, error, 'SplitView', 'display', [show_hide,view]);
};

//
// send message to view
//

SplitView.prototype.sendMessage = function (destination, message, success, error) {
        exec(success, error, 'SplitView', 'sendMessage', [destination,message]);
};

//
// set properties of child view
//

SplitView.prototype.setProperties = function ( properties, success, error) {
        exec(success, error, 'SplitView', 'setProperties', [properties]);
};

//
// set properties of split view
//

SplitView.prototype.setSplitViewProperties = function ( properties, success, error) {
            exec(success, error, 'SplitView', 'setSplitViewProperties', [properties]);
};
 
//
//Init Child View
//Call for all views.  Typically called immediately after "device ready"
//
SplitView.prototype.initChild = function(){
            exec(null, null, "SplitView", "initChild",[""]);
};

//
// select tab
//

SplitView.prototype.selectTab = function ( tab, success, error) {
    exec(success, error, 'SplitView', 'selectTab', [tab]);
};

//
// viewAction
//

SplitView.prototype.viewAction = function ( action, targets = ["self"], data = [""],success = null, error = null) {
    exec(success, error, 'SplitView', 'viewAction', [action,targets,data]);
};

//
// recieve string from sendMessage
//

SplitView.prototype.onMessage = function(item) {
        this.message(item);
};


//
// view event handler
//
SplitView.prototype.onAction = function(event,data){
        this.action(event,data);
};


SplitView.prototype.viewEvents ={
    buttonEvent:    "0",
    tabBarEvent:    "1",
    collectionEvent:  "2",
    barItemSelected:  "3"
};

SplitView.prototype.collectionEvents ={
    selectedListItem:    "0",
    };


// The following is Classic View Only


//
// show modal split view  ***deprecated, Classic View Only***
//
SplitView.prototype.show = function (primaryURL, secondaryURL, animated, success, error) {
    
    for (let [a,b] of Object.entries(this)) {
        exec(null, null, 'SplitView', a, [b]);
    }
    exec(success, error, 'SplitView', 'show', [primaryURL,secondaryURL,animated]);
};


SplitView.prototype.initSplitView = function () {
    
    for (let key of Object.keys(this)) {
        delete this[key];
    }
    exec(null, null, 'SplitView', 'initSplit', []);
};


SplitView.prototype.setBarTintColor = function (red,green,blue) {
        exec(null, null, 'SplitView', 'barTintColor', [red,green,blue]);
};
    
SplitView.prototype.setTintColor = function (red,green,blue) {
    exec(null, null, 'SplitView', 'tintColor', [red,green,blue]);
};
    
SplitView.prototype.setSecondaryBackgroundColor = function (red,green,blue) {
    exec(null, null, 'SplitView', 'secondaryBackgroundColor', [red,green,blue]);
};
    
SplitView.prototype.setPrimaryBackgroundColor = function (red,green,blue) {
    exec(null, null, 'SplitView', 'primaryBackgroundColor', [red,green,blue]);
};
    
// returns result string
//   status
//    dismissType.swipe -- dismissed by swipe
//    dismissType.left  -- dismissed by left button
//    dismissType.right -- dismissed by right button
//
SplitView.prototype.onClosed = function(results,status){
            this.closed(results,status);
};
                              
//Notifies Secondary View of action in Primary View
SplitView.prototype.primaryItemSelected = function(itemString){
    exec(null, null, "SplitView", "primaryItemSelected",[itemString]);
};

              
//Secondary
    
//Init Secondary View
// only use for secondary view.  Typically called immediately after "device ready"
SplitView.prototype.initSecondary = function(){
    exec(null, null, "SplitView", "initSecondary",[""]);
};

SplitView.prototype.onSelected = function(item){
    this.selected(item);
};

//Table View
     
SplitView.prototype.addTableItem = function(itemString,image){
    exec(null, null, "SplitView", "addTableItem",[itemString,image]);
};

SplitView.prototype.sendResults = function(resultsString){
    exec(null, null, "SplitView", "setResults",[resultsString]);
};
  
SplitView.prototype.dismissType ={
      swipe: "0",
      left:  "1",
      right: "2"
};

module.exports = new SplitView();

