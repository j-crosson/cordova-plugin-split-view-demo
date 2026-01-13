
document.addEventListener('deviceready', onDeviceReady, false);

function toTop() {
    window.scrollTo(0,0);
}

function onDeviceReady() {
    navigator.splashscreen.hide();
    cordova.plugins.SplitView.initChild();
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
    let viewProps = "";
    switch(item)
    {
        case 0:
            newtext = "One";
            toTop(); //sets navBar scrolledge
            document.getElementById("scrolltext").style.display = "none";
            document.getElementById("exitButton").style.display = "block";
            document.body.style.overflowY = "hidden"
            // force bar background to no-scroll appearance
            viewProps ='{ "tabBar": {"tabBarAppearance": {"background": "transparent", "lockBackground": true} }';
            viewProps += addlProperties;
            cordova.plugins.SplitView.setProperties(viewProps,null,null);
            break;
        case 1:
            newtext = "Two";
            toTop(); //sets navBar scrolledge
            document.getElementById("scrolltext").style.display = "none";
            document.getElementById("exitButton").style.display = "none";
            document.body.style.overflowY = "hidden"
            // force bar background to no-scroll appearance
            viewProps ='{ "tabBar": {"tabBarAppearance": {"background": "transparent", "lockBackground": true} }';
            viewProps += addlProperties;
            cordova.plugins.SplitView.setProperties(viewProps,null,null);
            break;
        case 2:
            document.body.style.overflowY = "scroll";
            document.getElementById("scrolltext").style.display = "block";
            document.getElementById("exitButton").style.display = "none";
            viewProps ='{ "tabBar": {"tabBarAppearance": {"background": "default", "lockBackground": false} }';
            viewProps += addlProperties;
            cordova.plugins.SplitView.setProperties(viewProps,null,null);
            newtext = "Three";
            break;
    }
    document.getElementById("centertext").textContent=newtext;
}
