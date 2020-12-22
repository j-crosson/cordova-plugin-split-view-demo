cordova.define("cordova-plugin-splitview.SplitView", function(require, exports, module) {
var exec = require('cordova/exec');

var PLUGIN_NAME = 'SplitView';

var SplitView = function() {};

//
// show modal split view
//
SplitView.prototype.show = function (primaryURL, secondaryURL, animated, success, error) {
    exec(success, error, 'SplitView', 'show', [primaryURL,secondaryURL,animated]);
};

SplitView.prototype.initSplitView = function () {
        exec(null, null, 'SplitView', 'initSplit', []);
};
                   
SplitView.prototype.primaryTitle = function (titleString) {
    exec(null, null, 'SplitView', 'primaryTitle', [titleString]);
};
                              
SplitView.prototype.secondaryTitle = function (titleString) {
    exec(null, null, 'SplitView', 'secondaryTitle', [titleString]);
};

SplitView.prototype.enableLeftButton = function (titleString) {
    exec(null, null, 'SplitView', 'leftButtonTitle', [titleString]);
};
    
SplitView.prototype.enableRightButton = function (titleString) {
    exec(null, null, 'SplitView', 'rightButtonTitle', [titleString]);
};
    
SplitView.prototype.barTintColor = function (red,green,blue) {
        exec(null, null, 'SplitView', 'barTintColor', [red,green,blue]);
};
    
SplitView.prototype.tintColor = function (red,green,blue) {
    exec(null, null, 'SplitView', 'tintColor', [red,green,blue]);
};
    
SplitView.prototype.secondaryBackgroundColor = function (red,green,blue) {
    exec(null, null, 'SplitView', 'secondaryBackgroundColor', [red,green,blue]);
};
    
SplitView.prototype.primaryBackgroundColor = function (red,green,blue) {
    exec(null, null, 'SplitView', 'primaryBackgroundColor', [red,green,blue]);
};
    
SplitView.prototype.maximumPrimaryColumnWidth = function (colWidth) {
    exec(null, null, 'SplitView', 'maximumPrimaryColumnWidth', [colWidth]);
};

SplitView.prototype.minimumPrimaryColumnWidth = function (colWidth) {
    exec(null, null, 'SplitView', 'minimumPrimaryColumnWidth', [colWidth]);
};
               
SplitView.prototype.displayModeButtonItem = function (showItem) {
    exec(null, null, 'SplitView', 'displayModeButtonItem', [showItem]);
};
 
SplitView.prototype.preferredPrimaryColumnWidthFraction = function(width){
    exec(null, null, "SplitView", "primaryColumnWidth",[width]);
};
                
SplitView.prototype.fullscreen = function(screen){
    exec(null, null, "SplitView", "fullscreen",[screen]);
 };

// returns result string
//   status
//    dismissType.swipe -- dismissed by swipe
//    dismissType.left  -- dismissed by left button
//    dismissType.right -- dismissed by right button
//
SplitView.prototype.onClosed = function(results,status){
            splitViewClosed(results,status);
};
                              
//Notifies Secondary View of action in Primary View
SplitView.prototype.primaryItemSelected = function(itemString){
    exec(null, null, "SplitView", "primaryItemSelected",[itemString]);
};

              
//Secondary View
               
//Init Secondary View
// only use for secondary view.  Typically called immediately after "device ready"
SplitView.prototype.initSecondary = function(){
    exec(null, null, "SplitView", "initSecondary",[""]);
};

SplitView.prototype.onSelected = function(item){
    doSelected(item);
};

//Table View
 
SplitView.prototype.useTableView = function(useView){
    exec(null, null, "SplitView", "useTableView",[useView]);
};
    
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
