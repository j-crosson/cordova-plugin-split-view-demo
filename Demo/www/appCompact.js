
document.addEventListener('deviceready', onDeviceReady, false);

function onDeviceReady() {
    navigator.splashscreen.hide();
    cordova.plugins.SplitView.initChild();
   // cordova.plugins.SplitView.selected = doSelected;
    cordova.plugins.SplitView.message = recievedMessage;
    cordova.plugins.SplitView.action = handleEvents;
}

function recievedMessage(item)
{ 
    //
    // Keep  TabBar in sync with two column layout
    //
    let tabItem = parseInt(item,10);
    cordova.plugins.SplitView.selectTab(tabItem);
    doSelected(tabItem,false);
    //don't forward message; message is from destination views

}

function handleEvents(event,data)
{
    //
    // The TabBar sends a string representation of the tag number
    //
    if((event === cordova.plugins.SplitView.viewEvents.tabBarEvent))
    {
        //forward item to keep other views in sync
        doSelected(parseInt(data,10),true);
    }
}





function doSelected(item, forward)
{
    let newtext = "Zero";
    itemString = item.toString();
    if(forward)
    {
        cordova.plugins.SplitView.sendMessage('secondary',itemString,null,null);
        cordova.plugins.SplitView.sendMessage('primary',itemString,null,null);
    }
    switch(item)
    {
        case 0:
            newtext = "One";
            break;
        case 1:
            newtext = "Two";
            break;
        case 2:
            newtext = "Three";
            break;
    }
    document.getElementById("centertext").textContent=newtext;
}
