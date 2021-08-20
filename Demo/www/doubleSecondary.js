
document.addEventListener('deviceready', onDeviceReady, false);
var itemSelected = false;

function onDeviceReady()
{
    navigator.splashscreen.hide();
    cordova.plugins.SplitView.initChild();
    cordova.plugins.SplitView.message = recievedMessage;
}

function recievedMessage(item)
{
    if (!itemSelected)
    {
        let viewPropJSON = '{"topColumnForCollapsingToProposedTopColumn":"default"}';
        cordova.plugins.SplitView.setSplitViewProperties(viewPropJSON);
        itemSelected = true;
    }

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
