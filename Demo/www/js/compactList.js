
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
        tabSelect1(newTab);
    }
    else {
    }
}, {root: null});

function onDeviceReady() {
    navigator.splashscreen.hide();
    cordova.plugins.SplitView.initChild();
    cordova.plugins.SplitView.message = recievedMessage;
    cordova.plugins.SplitView.action = handleEvents;
    
    doSelected(0,false);
}

function recievedMessage(item)
{
}

function switchTab(barItem)
{
        document.getElementById("scrolltext").style.display = "none";
        document.getElementById("exitBut").style.display = "none";
        document.getElementById("radioText").style.display = "none";

    
        // If we're scrolling and we switch tabs, the scrollbar will show briefly
        // in the new tab, so we hide the bar to prevent this
        if (barItem == 2)
            cordova.plugins.SplitView.viewAction("scrollBar", ["self"],["showVert"]);
        else
            cordova.plugins.SplitView.viewAction("scrollBar", ["self"],["hideVert"]);

        switch (currentTab) {
            case 0:
                newTab = barItem;
                observer.observe(document.getElementById("xit"));
                break;
            case 2:
                cordova.plugins.SplitView.viewAction("scrollBar", ["self"],["hideVert"]);
                newTab = barItem;
                observer.observe(document.getElementById("scrolltext"));
                break;
            case 1:
                newTab = barItem;
                observer.observe(document.getElementById("radioText"));
                break
        }
}

function tabSelect1(barItem)
{
    setTimeout(() => {
        cordova.plugins.SplitView.selectTab(barItem);
        currentTab = barItem;
        doSelected(barItem,true);
        observer.unobserve();
     }, "0");
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
    // User selected an item. We can prepare for transition or prevent or delay item selection.
    // In this case, we clear content.  We are not using the "viewport-fit=cover" meta tag
    // so if title size changes in the tab we're switching to, content will shift before displaying the next tab,
    // sometimes causing an ugly display artifact. This isn't an issue when the meta tag is present:
    // the content doesn't shift.
    else if(event === cordova.plugins.SplitView.viewEvents.barItemSelected)
    {
        let barItem = parseInt(data,10);
        if(currentTab != barItem)
            switchTab(barItem);
    }
    else if (event === cordova.plugins.SplitView.viewEvents.collectionEvent)
    {
        //
        // Keep  TabBar in sync
        //
           
        const jsonMsg = JSON.parse(data);
        if(jsonMsg.id ===  cordova.plugins.SplitView.collectionEvents.selectedListItem)
        {
            let isSectionOne = jsonMsg.select.section < 1;
            let tabItem = 2;
            if (isSectionOne)
            {
                tabItem = 1;
                if (jsonMsg.select.row == 0)
                    tabItem = 0;
            }

            cordova.plugins.SplitView.selectTab(tabItem);
            currentTab = tabItem;
            doSelected(tabItem,false); //don't forward message; message is from destination views
        }
    }
}

function doSelected(item, forward)
{
    let newtext = "Zero";
    let viewProps = "";
    let section = 0;
    let row = 0;
    let scrollPosition = "centeredVertically"

    switch(item)
    {
        case 0:
            section = 0;
            row = 0;
            toTop(); //sets navBar scrolledge
            document.body.style.overflowY = "hidden"
            
            // force bar background to no-scroll appearance
            viewProps ='{ "tabBar": {"tabBarAppearance": {"background": "transparent", "lockBackground": true} }}';
            cordova.plugins.SplitView.setProperties(viewProps,null,null);
            document.getElementById("radioText").style.display = "none";
            document.getElementById("exitBut").style.display = "block";
            document.getElementById("scrolltext").style.display = "none";
            break;
        case 1:
            section = 0;
            row = 1;
            toTop(); //sets navBar scrolledge
            document.getElementById("radioText").style.display = "block";
            document.getElementById("exitBut").style.display = "none";
            document.getElementById("scrolltext").style.display = "none";
            document.body.style.overflowY = "hidden";
            // force bar background to no-scroll appearance
            viewProps ='{ "tabBar": {"tabBarAppearance": {"background": "transparent", "lockBackground": true} }}';
            cordova.plugins.SplitView.setProperties(viewProps,null,null);
            break;
        case 2:
            section = 1;
            row = 1;
            toTop(); //sets navBar scrolledge
            document.body.style.overflowY = "scroll";
            document.getElementById("scrolltext").style.display = "block";
            document.getElementById("exitBut").style.display = "none";
            document.getElementById("radioText").style.display = "none";
            viewProps ='{ "tabBar": {"tabBarAppearance": {"background": "default", "lockBackground": false} }}';
            cordova.plugins.SplitView.setProperties(viewProps,null,null);
            break;
    }
    if(forward)
    {
        let msgJSON = '{"id": "selectListItem", "select": { "section": '+ section +' , "row": '+ row +' ,"scrollPosition": "' + scrollPosition + '" }}';
        cordova.plugins.SplitView.viewAction("setCollectionProperty", ["primary"],[msgJSON]);
        //collection list doesn't generate a selectListItem event when selected programmatically
        //so we need to update secondary view too.
        let msg1JSON = '{"id": "' + cordova.plugins.SplitView.collectionEvents.selectedListItem + '", "select": { "section": '+ section +' , "row": '+ row +' }}';
        cordova.plugins.SplitView.viewAction("fireCollectionEvent", ["secondary"],[msg1JSON]);
    }
}
