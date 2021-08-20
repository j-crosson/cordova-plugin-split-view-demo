
document.addEventListener('deviceready', onDeviceReady, false);

function onDeviceReady() {
    navigator.splashscreen.hide();
    cordova.plugins.SplitView.initChild();
    cordova.plugins.SplitView.selected = doSelected;
    cordova.plugins.SplitView.message = recievedMessage;
}

function recievedMessage(item)
{ 
    //
    // The TabBar sends a "decorated" selected item index:
    // there are user-specified strings prepended and appended to the index  string
    // For this example, a "1" is prepended to the index so a
    // value greater than "10" indicates message is from Tab View
    // less than 10 is from split view
    let tabItem = parseInt(item,10);
    if(tabItem < 10) //from other view
    {
        cordova.plugins.SplitView.selectTab(tabItem);
        doSelected(tabItem,false);
        //don't forward message; message is from destination views
    }
    else
    {
        tabItem -= 10
        doSelected(tabItem,true);
        //forward item to keep other views in sync
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
