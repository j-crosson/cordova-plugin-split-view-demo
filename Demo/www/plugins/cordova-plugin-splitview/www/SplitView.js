cordova.define("cordova-plugin-splitview.SplitView", function(require, exports, module) {
var exec = require('cordova/exec');

var PLUGIN_NAME = 'SplitView';

var SplitView = function() {};

//
// show modal split view
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

});
