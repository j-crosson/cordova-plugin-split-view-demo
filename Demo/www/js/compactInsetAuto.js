document.addEventListener('deviceready', onDeviceReady, false);

var currentTab = 0; 
var newTab = 0;


function toTop() { 
    window.scrollTo(0,0);
}

// we observe when tab-related elements go away during a tab change and act to prevent display artifacts
// caused by inset changes when switching between large-title and small-title tabs.
// This is unnecessary if title size never changes or if the never-adjust-inset option is selected.
const observer = new IntersectionObserver(function(entries) {
    if (entries[0]['intersectionRatio'] == 0) {
        tabSelect(newTab);
    }
    else {
    }
});

function onDeviceReady() {
    navigator.splashscreen.hide();
    cordova.plugins.SplitView.initChild();
    cordova.plugins.SplitView.message = recievedMessage;
    cordova.plugins.SplitView.action = handleEvents;
    
    doSelected(0,false);
}

function recievedMessage(item)
{
    //
    // Keep  TabBar in sync with two column layout
    //
    let tabItem = parseInt(item,10);
    cordova.plugins.SplitView.selectTab(tabItem);
    currentTab = tabItem;
    doSelected(tabItem,false);
    //don't forward message; message is from destination views
}

function handleEvents(event,data)
{
    //
    // The TabBar sends a string representation of the tag number
    //
    // User selected an item. We can prepare for transition or prevent or delay item selection.
    // This event is fired only if the property "shouldSelectTab" is false.  Otherwise notification
    // occurs after the selected tab is displayed.
    // In this case, we clear content to prevent display artifacts.  We are not using the "viewport-fit=cover" meta tag
    // so if title size changes in the tab we're switching to, content will shift when displaying the next tab,
    // because the inset has changed. This isn't an issue when the meta tag is present:
    // the content doesn't shift.

    if((event === cordova.plugins.SplitView.viewEvents.barItemSelected))
    {
        let barItem = parseInt(data,10);
        if(currentTab != barItem)
            switchTab(barItem);
    }
}

function tabSelect(barItem) {
    setTimeout(() => {
        cordova.plugins.SplitView.selectTab(barItem);
        currentTab = barItem;
        doSelected(barItem,true);
        observer.unobserve();
     }, "0");
}

function switchTab(barItem)
{
        switch (currentTab) {
            case 0:
                newTab = barItem;
                observer.observe(document.getElementById("exitButton"));
                break;
            case 1:
                newTab = barItem;
                observer.observe(document.getElementById("titleText"));
                break
            case 2:
                newTab = barItem;
                observer.observe(document.getElementById("scrolltext"));
                break;
        }
        
        document.getElementById("exitBut").style.display = "none";
        document.getElementById("titleText").style.display = "none";
        document.getElementById("scrolltext").style.display = "none";
}

function doSelected(item, forward)
{
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
            toTop(); //sets navBar scrolledge
            document.getElementById("scrolltext").style.display = "none";
            document.getElementById("titleText").style.display = "none";
            document.getElementById("exitBut").style.display = "block";
            document.body.style.overflowY = "hidden"
            // force bar background to no-scroll appearance
            viewProps ='{ "tabBar": {"tabBarAppearance": {"background": "transparent", "lockBackground": true} }}';
            cordova.plugins.SplitView.setProperties(viewProps,null,null);
            break;
        case 1:
            toTop(); //sets navBar scrolledge
            document.getElementById("scrolltext").style.display = "none";
            document.getElementById("titleText").style.display = "block";
            document.getElementById("exitBut").style.display = "none";

            document.body.style.overflowY = "hidden"
            // force bar background to no-scroll appearance
            viewProps ='{ "tabBar": {"tabBarAppearance": {"background": "transparent", "lockBackground": true} }}';
            cordova.plugins.SplitView.setProperties(viewProps,null,null);
            break;
        case 2:
            document.body.style.overflowY = "scroll";
            document.getElementById("scrolltext").style.display = "block";
            document.getElementById("titleText").style.display = "none";
            document.getElementById("exitBut").style.display = "none";

            viewProps ='{ "tabBar": {"tabBarAppearance": {"background": "default", "lockBackground": false} }}';
            cordova.plugins.SplitView.setProperties(viewProps,null,null);
            break;
    }
}
