
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
                break;
            case '1':
                newtext = "Two";
                break;
            case '2':
                newtext = "Three";
                break;
    }
    document.getElementById("centertext").textContent=newtext;
}
