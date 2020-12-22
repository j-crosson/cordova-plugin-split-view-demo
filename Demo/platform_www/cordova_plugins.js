cordova.define('cordova/plugin_list', function(require, exports, module) {
  module.exports = [
    {
      "id": "cordova-plugin-splitview.SplitView",
      "file": "plugins/cordova-plugin-splitview/www/SplitView.js",
      "pluginId": "cordova-plugin-splitview",
      "clobbers": [
        "cordova.plugins.SplitView"
      ]
    }
  ];
  module.exports.metadata = {
    "cordova-plugin-whitelist": "1.3.4",
    "cordova-plugin-add-swift-support": "2.0.2",
    "cordova-plugin-splitview": "0.9.0"
  };
});