
document.addEventListener('deviceready', onDeviceReady, false);
var itemSelected = false;
let newtext = "Zero";

function onDeviceReady()
{
    navigator.splashscreen.hide();
    cordova.plugins.SplitView.initChild();
    cordova.plugins.SplitView.message = recievedMessage;
    cordova.plugins.SplitView.action = handleEvents;
}

function recievedMessage(item)
{
    if (!itemSelected)
    {
        let viewPropJSON = '{"topColumnForCollapsingToProposedTopColumn":"default"}';
        cordova.plugins.SplitView.setSplitViewProperties(viewPropJSON);
        itemSelected = true;
    }

    
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


function handleEvents(event,data)
{
    if (event === cordova.plugins.SplitView.viewEvents.buttonEvent)
    {
        document.getElementById("centertext").textContent=newtext+data;
    }    
}
