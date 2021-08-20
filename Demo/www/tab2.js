
document.addEventListener('deviceready', onDeviceReady, false);

function onDeviceReady()
{
    navigator.splashscreen.hide();
    cordova.plugins.SplitView.initChild();
    cordova.plugins.SplitView.message = doSelected;
}

function doSelected(item)
{
    let newtext = "Zero";
    switch(item)
    {
            case '0':
                newtext = "One";
                setTimeout(cordova.plugins.SplitView.sendResults('Selected first item'), 0);
                break;
            case '1':
                newtext = "Two";
                setTimeout(cordova.plugins.SplitView.sendResults('Selected second item'), 0);
                break;
            case '2':
                newtext = "Three";
                setTimeout(cordova.plugins.SplitView.sendResults('Selected third item'), 0);
                break;
            case 'One':
                newtext = "One";
                setTimeout(cordova.plugins.SplitView.sendResults('Selected first table item'), 0);
                break;
            case 'Two':
                newtext = "Two";
                setTimeout(cordova.plugins.SplitView.sendResults('Selected second table item'), 0);
                break;
            case 'Three':
                newtext = "Three";
                setTimeout(cordova.plugins.SplitView.sendResults('Selected third table item'), 0);
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
