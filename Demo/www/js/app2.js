
document.addEventListener('deviceready', onDeviceReady, false);

function onDeviceReady() {
    navigator.splashscreen.hide();
    cordova.plugins.SplitView.initSecondary();
    cordova.plugins.SplitView.selected = doSelected;
}

function doSelected(item)
{
    let newtext = "Zero";
    switch(item)
    {
            case '0':
                newtext = "One";
                cordova.plugins.SplitView.sendResults('Selected first item');
                break;
            case '1':
                newtext = "Two";
                cordova.plugins.SplitView.sendResults('Selected second item');
                break;
            case '2':
                newtext = "Three";
                cordova.plugins.SplitView.sendResults('Selected third item');
                break;
            case 'One':
                newtext = "One";
                cordova.plugins.SplitView.sendResults('Selected first table item');
                break;
            case 'Two':
                newtext = "Two";
                cordova.plugins.SplitView.sendResults('Selected second table item');
                break;
            case 'Three':
                newtext = "Three";
                cordova.plugins.SplitView.sendResults('Selected third table item');
                break;
            case 'Four':
                newtext = "Four";
                setTimeout(cordova.plugins.SplitView.sendResults('Selected fourth table item'), 0);
                break;
            case 'Five':
                newtext = "Five";
                setTimeout(cordova.plugins.SplitView.sendResults('Selected fifth table item'), 0);
                break;
    }
    document.getElementById("centertext").textContent=newtext;
}
