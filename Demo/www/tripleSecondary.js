
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
    doSelected(item);
}

function doSelected(item)
{
    let newtext = "Zero";
    
    if (!itemSelected)
    {
        let viewPropJSON = '{"topColumnForCollapsingToProposedTopColumn":"default","preferredDisplayMode":"secondaryOnly"}';
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
        case '3':
            newtext = "Four";
            break;
        case '4':
            newtext = "Five";
            break;
        case '5':
            newtext = "Six";
            break;
      }
    document.getElementById("centertext").textContent=newtext;
}
