document.addEventListener('deviceready', onDeviceReady, false);
const viewer = document.querySelector('#json');

let JSONData = [];

function onDeviceReady()
{
    navigator.splashscreen.hide();
    cordova.plugins.SplitView.initChild();
    cordova.plugins.SplitView.message = recievedMessage;
    cordova.plugins.SplitView.action = handleEvents;
    
    JSONData[0] =
        [
        {"fullscreen":true,"primaryTitle":"Primary","primaryURL":"doublePrimary.html","secondaryTitle":"Secondary","secondaryURL":"doubleSecondary.html", "style":"doubleColumn","topColumnForCollapsingToProposedTopColumn":"primary", "preferredSplitBehavior":"automatic","preferredDisplayMode":"twoBesideSecondary","primaryEdge":"leading","backgroundColor":[255,255,255,1]},
    
        { "barButtonRight": {"type":"text","title":"Tap Me","identifier": "rightTap"}, "navBarAppearance": {"prefersLargeTitles":true}},
        
        {"navBarAppearance": {"prefersLargeTitles":true}}
        ];
    JSONData[1] =
        [
        {"primaryTitle":"Primary","fullscreen":true,"primaryURL":"triplePrimary.html","topColumnForCollapsingToProposedTopColumn":"primary","showsSecondaryOnlyButton":true,"preferredDisplayMode":"twoBesideSecondary","secondaryTitle":"Secondary","secondaryURL":"tripleSecondary.html","style":"tripleColumn","supplementaryTitle":"Supplementary","supplementaryURL":"tripleSupplementary.html","tintColor":[1,255,3,1],"backgroundColor":[255,255,255,1]},
        
        {"navBarAppearance": {"prefersLargeTitles":true}},
        
        {"preventHorizScroll":true,"horizScrollBarInvisible":true}
        ];

    JSONData[2] =
        [
        {"fullscreen":true,"primaryTitle":"Not Music", "primaryURL":"doublePrimary.html", "viewConfig": {"primary": "collectionList" }, "secondaryTitle":"Secondary", "secondaryURL":"collectionSecondary.html", "style":"doubleColumn", "preferredSplitBehavior":"automatic", "usesCompact":true, "preferredDisplayMode":"twoBesideSecondary", "primaryEdge":"leading","backgroundColor":[255,255,255,1]},
        
        { "navBarAppearance": {"prefersLargeTitles":true}, "views": {"primaryCollection": { "config": {"initialSection": 0, "initialRow": 0, "messageTargets": ["compact", "secondary"]}, "sections":[{"listItems":[{"listImage": {"type": "symbol","name": "play.circle"},"listText": "Listen Now" },{"listImage": {"type": "symbol","name": "dot.radiowaves.left.and.right"},"listText": "Radio" },{"listImage": {"type": "symbol","name": "magnifyingglass"},"listText": "Search" }]},{"header": "Library", "listItems":[{"listImage": {"type": "symbol","name": "clock"},"listText": "Recently Added" },{"listImage": {"type": "symbol","name": "music.mic"},"listText": "Artists" },{"listImage": {"type": "symbol","name": "rectangle.stack"},"listText": "Albums" }]},{"header": "Playlists", "listItems":[{"listImage": {"type": "symbol","name": "square.grid.3x3"},"listText": "All Playlists" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 1" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 2" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 3" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 4" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 5" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 6" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 7" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 8" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 9" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 10" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 11" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 12" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 13" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 14" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 15" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 16" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 17" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 18" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 19" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 20" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 21" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 22" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 23" }]} ]}}},
        
        {"navBarAppearance": {"prefersLargeTitles":true}, "barButtonRight": {"type": "image", "menuType": "menu", "identifier": ".0", "image": {"type": "symbol","name": "dice"},"menuTitle": "Menu", "menuElements": [{"title":"none","identifier": "1","menuImage": {"type": "symbol","name": "dice","symbolConfig":[{"type":"scale","value":"large"}]}},{"title":"bottom","identifier": "2","menuImage": {"type": "symbol","name": "dice","symbolConfig":[{"type":"weight","value":"bold"}]}},{"title":"top","identifier": "3","menuImage": {"type": "symbol","name": "dice","symbolConfig":[{"type":"scale","value":"large"},{"type":"weight","value":"bold"}]}},{"title":"centered","identifier": "4","menuImage": {"type": "symbol","name": "dice"}} ,{"title":"Exit","identifier": "5","menuImage": {"type": "symbol","name": "flame.fill"}, "attributes": ["destructive"]} ]}},
        
        {"compactURL":"compactList.html", "shouldSelectTab":false, "contentInsetAdjustmentBehavior":"always", "tabBar": {"tabBarAppearance": {"background": "transparent", "lockBackground": true } },  "tabBarItems":[{"title":"Listen Now", "tag": 0, "hideNavBar": false,"navBar": {"title":"Listen Now","appearance": {"prefersLargeTitles":true }}, "image": {"type": "symbol","name": "play.circle"}},{"title":"Radio", "tag": 1, "hideNavBar": false,"navBar": {"title":"Radio"},"image": {"type": "symbol","name": "dot.radiowaves.left.and.right"}},{"title":"Library", "tag": 2,"hideNavBar": false,"navBar": {"title":"Recently Added","appearance": {"prefersLargeTitles":true}}, "image": {"type": "symbol","name": "rectangle.stack"}}], "preventHorizScroll":true, "horizScrollBarInvisible":true,  "backgroundColor":[255,255,255,1]}
        ];

    JSONData[3] =
        [
        {"fullscreen":true,"primaryURL":"compactPrimaryInsetNever.html","primaryTitle":"Primary","secondaryURL":"compactSecondaryInsetNever.html", "secondaryTitle":"Secondary", "style":"doubleColumn", "preferredSplitBehavior":"automatic","preferredDisplayMode":"twoBesideSecondary","usesCompact":true, "backgroundColor":[255,255,255,1]},
        
        {"navBarAppearance": {"prefersLargeTitles":true}},
        
        {"preventHorizScroll":true,"horizScrollBarInvisible":true ,"navBarAppearance": {"prefersLargeTitles":true}},
        
        {"compactURL":"compactInsetNever.html", "tabBar": {"tabBarAppearance": {"background": "transparent", "lockBackground": true } },  "tabBarItems":[{"title":"title1", "tag": 0, "hideNavBar": false,"navBar": {"title":"Item1","appearance": {"prefersLargeTitles":true }}, "image": {"type": "symbol","name": "1.circle"}},{"title":"title2", "tag": 1, "hideNavBar": false,"navBar": {"title":"Item2"},"image": {"type": "symbol","name": "2.circle"}},{"title":"title3", "tag": 2,"hideNavBar": false,"navBar": {"title":"Item3","appearance": {"prefersLargeTitles":true}}, "image": {"type": "symbol","name": "3.circle"}}], "backgroundColor":[255,255,255,1]}
        ];
    
    JSONData[4] =
        [
        {"fullscreen":true, "primaryURL":"compactPrimaryInsetAuto.html", "primaryTitle":"Primary","secondaryURL":"compactSecondaryInsetAuto.html", "secondaryTitle":"Secondary", "style":"doubleColumn", "preferredSplitBehavior":"automatic","preferredDisplayMode":"twoBesideSecondary","usesCompact":true, "backgroundColor":[255,255,255,1]},
        
        {"contentInsetAdjustmentBehavior":"always", "navBarAppearance": {"prefersLargeTitles":true}},
        
        {"contentInsetAdjustmentBehavior":"always", "preventHorizScroll":true,"horizScrollBarInvisible":true ,"navBarAppearance": {"prefersLargeTitles":true}},
        
        {"compactURL":"compactInsetAuto.html", "contentInsetAdjustmentBehavior":"always", "shouldSelectTab":false, "tabBar": {"tabBarAppearance": {"background": "transparent", "lockBackground": false } },   "tabBarItems":[{"title":"title1", "tag": 0, "hideNavBar": false,"navBar": {"title":"Item1","appearance": {"prefersLargeTitles":true }}, "image": {"type": "symbol","name": "1.circle"}},{"title":"title2", "tag": 1, "hideNavBar": false,"navBar": {"title":"Item2"},"image": {"type": "symbol","name": "2.circle"}},{"title":"title3", "tag": 2,"hideNavBar": false,"navBar": {"title":"Item3","appearance": {"prefersLargeTitles":true}}, "image": {"type": "symbol","name": "3.circle"}}], "backgroundColor":[255,255,255,1]}

        ];

    JSONData[5] =
        [
        {"fullscreen":true,"primaryURL":"compactPrimaryInsetNever.html","primaryTitle":"Primary","secondaryURL":"compactSecondaryNoBar.html", "secondaryTitle":"Secondary", "style":"doubleColumn", "preferredSplitBehavior":"automatic","preferredDisplayMode":"twoBesideSecondary","usesCompact":true, "backgroundColor":[255,255,255,1]},

        {"hideNavigationBar":true},
                              
        {"preventHorizScroll":true,"horizScrollBarInvisible":true, "hideNavigationBar":true},

        {"compactURL":"compactInsetNever.html", "preventHorizScroll":true,"horizScrollBarInvisible":true, "tabBar": {"tabBarAppearance": {"background": "transparent", "lockBackground": true } },  "tabBarItems":[{"title":"title1", "tag": 0, "hideNavBar": true,"navBar": {"title":"Item1","appearance": {"prefersLargeTitles":true }}, "image": {"type": "symbol","name": "1.circle"}},{"title":"title2", "tag": 1, "hideNavBar": true,"navBar": {"title":"Item2"},"image": {"type": "symbol","name": "2.circle"}},{"title":"title3", "tag": 2,"hideNavBar": true,"navBar": {"title":"Item3","appearance": {"prefersLargeTitles":true}}, "image": {"type": "symbol","name": "3.circle"}}], "backgroundColor":[255,255,255,1]}

        ];



    JSONData[6] =
        [
        {"fullscreen":true,"primaryURL":"compactPrimaryInsetNever.html","primaryTitle":"Primary","secondaryURL":"compactSecondaryNoBar.html", "secondaryTitle":"Secondary", "style":"doubleColumn", "preferredSplitBehavior":"automatic","preferredDisplayMode":"twoBesideSecondary","usesCompact":true, "backgroundColor":[255,255,255,1]},

        {},
                              
        {"preventHorizScroll":true,"horizScrollBarInvisible":true },

        {"compactURL":"compactInsetNever.html", "preventHorizScroll":true,"horizScrollBarInvisible":true, "tabBar": {"tabBarAppearance": {"background": "transparent", "lockBackground": true } },  "tabBarItems":[{"title":"title1", "tag": 0, "hideNavBar": false,"navBar": {"title":"Item1"}, "image": {"type": "symbol","name": "1.circle"}},{"title":"title2", "tag": 1, "hideNavBar": false,"navBar": {"title":"Item2"},"image": {"type": "symbol","name": "2.circle"}},{"title":"title3", "tag": 2,"hideNavBar": false,"navBar": {"title":"Item3"}, "image": {"type": "symbol","name": "3.circle"}}], "backgroundColor":[255,255,255,1]}
        ];


/*
    JSONData[6] =
        [
        {"fullscreen":true,"primaryURL":"compactPrimaryInsetNever.html","primaryTitle":"Primary","secondaryURL":"compactSecondaryInsetNever.html", "secondaryTitle":"Secondary", "style":"doubleColumn", "preferredSplitBehavior":"automatic","preferredDisplayMode":"twoBesideSecondary","usesCompact":true, "backgroundColor":[255,255,255,1]},
                       
        {},
                                                     
       
               {"compactURL":"compactInsetNever.html", "preventHorizScroll":true,"horizScrollBarInvisible":true, "tabBar": {"tabBarAppearance": {"background": "transparent", "lockBackground": true } },  "tabBarItems":[{"title":"title1", "tag": 0, "hideNavBar": false,"navBar": {"title":"Item1"}, "image": {"type": "symbol","name": "1.circle"}},{"title":"title2", "tag": 1, "hideNavBar": false,"navBar": {"title":"Item2"},"image": {"type": "symbol","name": "2.circle"}},{"title":"title3", "tag": 2,"hideNavBar": false,"navBar": {"title":"Item3"}, "image": {"type": "symbol","name": "3.circle"}}], "backgroundColor":[255,255,255,1]}
        ];

*/
}

function recievedMessage(item)
{
}


//sections without header start at zero otherwise header is zeroth entry
function displaySelection(row,section)
{
    cordova.plugins.SplitView.display("show","secondary");
    let rowNumber = (section == 0)? row + 1 : row
  //  document.getElementById("centertext1").textContent="Row " + rowNumber;
 //   document.getElementById("centertext").textContent="Section "+ (section+1);
  
// viewer.collapseAll();
 //   console.log(viewer);
 
    console.log(row + " " + section);
     console.log(JSONData[section -1][row-1]);

     document.querySelector('#json').data =  JSONData[section - 1][row -1];
     window.scrollTo(0,0);
}


function handleEvents(event,data)
{
    if (event === cordova.plugins.SplitView.viewEvents.buttonEvent)
    {
        
        let row = 0;
        let section = 0;
        let scrollPosition = "none"

        switch (data)
        {
            case "1":
                viewer.expandAll();
                break;
            case "2":
                viewer.collapseAll();
                window.scrollTo(0,0);
                break;
            case "5":
                cordova.plugins.SplitView.viewAction("dismiss");
                break;
        }
        
        let msgJSON = '{"id": "selectListItem", "select": { "section": '+ section +' , "row": '+ row +' ,"scrollPosition": "' + scrollPosition + '" }}';
        
        displaySelection(row,section);
        cordova.plugins.SplitView.viewAction("setCollectionProperty", ["primary"],[msgJSON]);
        
        //collection list doesn't generate a selectListItem event when selected programmatically
        //so we need to update compact view too.
        let msg1JSON = '{"id": "' + cordova.plugins.SplitView.collectionEvents.selectedListItem + '", "select": { "section": '+ section +' , "row": '+ row +' }}';
        cordova.plugins.SplitView.viewAction("fireCollectionEvent", ["compact"],[msg1JSON]);

    }
    else if (event === cordova.plugins.SplitView.viewEvents.collectionEvent) //listItemSelected
    {
        const jsonMsg = JSON.parse(data);
        if(jsonMsg.id ===  cordova.plugins.SplitView.collectionEvents.selectedListItem)
            displaySelection( jsonMsg.select.row,jsonMsg.select.section);
    }
}
