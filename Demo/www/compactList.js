
document.addEventListener('deviceready', onDeviceReady, false);

var btn = document.getElementById("btnn")
 btn.onclick = doit


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
            document.getElementById("scrolltext").style.display = "none";
            document.getElementById("exitBut").style.display = "block";
            document.body.style.overflowY = "hidden"
            // force bar background to no-scroll appearance
            viewProps ='{ "tabBar": {"tabBarAppearance": {"background": "transparent", "lockBackground": true} }}';
            cordova.plugins.SplitView.setProperties(viewProps,null,null);
            break;
        case 1:
            section = 0;
            row = 1;
            toTop(); //sets navBar scrolledge
            document.getElementById("scrolltext").style.display = "none";
            document.getElementById("exitBut").style.display = "block";

            document.body.style.overflowY = "hidden"
            // force bar background to no-scroll appearance
            viewProps ='{ "tabBar": {"tabBarAppearance": {"background": "transparent", "lockBackground": true} }}';
            cordova.plugins.SplitView.setProperties(viewProps,null,null);
            break;
        case 2:
            section = 1;
            row = 1;
            document.body.style.overflowY = "scroll";
            document.getElementById("scrolltext").style.display = "block";
            document.getElementById("exitBut").style.display = "none";
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

