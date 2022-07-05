
// var isDarkMode = window.matchMedia('(prefers-color-scheme:dark)');
function doViewWeb(option)
{
//new view
   {
       let redBackground = 228;
       let greenBackground = 228;
       let blueBackground = 228;
       if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches)
       {
           // is dark
           redBackground = 30;
           greenBackground = 30;
           blueBackground = 30;
       }
       
       let viewPropJSON;
       let viewPropCompact;
       let viewPropPrimary;
       let viewPropSecondary;
       let viewPropSup;

       //
       // see JSON.js for formatted JSON
       //
       switch (option)
       {
           case 0: //test
               viewPropJSON = '{"primaryTitle":"Primary", "secondaryTitle":"Secondary","fullscreen":true, "Style":"doubleColumn","backgroundColor":[' + redBackground+','+ greenBackground+ ',' + blueBackground+ ',' + '1]}';
               break;
           case 1: //double column
               viewPropJSON = '{"fullscreen":true,"primaryTitle":"Primary","primaryURL":"doublePrimary.html","secondaryTitle":"Secondary","secondaryURL":"doubleSecondary.html", "style":"doubleColumn","topColumnForCollapsingToProposedTopColumn":"primary", "preferredSplitBehavior":"automatic","preferredDisplayMode":"twoBesideSecondary","primaryEdge":"leading","backgroundColor":[' + redBackground+','+ greenBackground+ ',' + blueBackground+ ',' + '1]}';
               viewPropPrimary ='{ "barButtonRight": {"type":"text","title":"Tap Me","identifier": "rightTap"}, "navBarAppearance": {"prefersLargeTitles":true}, }';
               //Demo left button
               //viewPropPrimary ='{ "barButtonRight": {"type":"text","title":"Tap Me","identifier": "rightTap"},"barButtonLeft": {"type":"text","title":"Left"} }';

               viewPropSecondary='{ "barButtonRight": {"type": "image", "menuType": "menu", "identifier": ".0", "image": {"type": "symbol","name": "dice"},"menuTitle": "Menu", "menuElements": [{"title":"Item 1","identifier": ".1","menuImage": {"type": "symbol","name": "dice","symbolConfig":[{"type":"scale","value":"large"}]}},{"title":"Item 2","identifier": ".2","menuImage": {"type": "symbol","name": "dice","symbolConfig":[{"type":"weight","value":"bold"}]}},{"title":"Item 3","identifier": ".3","menuImage": {"type": "symbol","name": "dice","symbolConfig":[{"type":"scale","value":"large"},{"type":"weight","value":"bold"}]}},{"title":"Item 4","identifier": ".4","menuImage": {"type": "symbol","name": "dice"}} ,{"title":"destructive","identifier": ".5","menuImage": {"type": "symbol","name": "flame.fill"}, "attributes": ["destructive"]} ]}}';
               viewPropCompact = null;
               viewPropSup = null;
               break;
           case 2: //triple column
               viewPropJSON = '{"primaryTitle":"Primary","fullscreen":true,"primaryURL":"triplePrimary.html","topColumnForCollapsingToProposedTopColumn":"primary","showsSecondaryOnlyButton":true,"preferredDisplayMode":"twoBesideSecondary","secondaryTitle":"Secondary","secondaryURL":"tripleSecondary.html","style":"tripleColumn","supplementaryTitle":"Supplementary","supplementaryURL":"tripleSupplementary.html","tintColor":[1,255,3,1],"backgroundColor":[' + redBackground+','+ greenBackground+ ',' + blueBackground+ ',' + '1]}';
               viewPropPrimary = null;
               viewPropSecondary = '{"preventHorizScroll":true,"horizScrollBarInvisible":true}';
               viewPropCompact = null;
               viewPropSup = null;
               break;
           case 3: //compact tabView
               viewPropJSON = '{"fullscreen":true,"primaryURL":"tab1.html","primaryTitle":"Primary","secondaryURL":"tab2.html", "secondaryTitle":"Secondary","compactURL":"compact.html", "style":"doubleColumn", "preferredSplitBehavior":"automatic","preferredDisplayMode":"twoBesideSecondary","usesCompact":true, "backgroundColor":[' + redBackground+','+ greenBackground+ ',' + blueBackground+ ',' + '1]}';
              
             //  Demo of tabBar System Items
             //  viewPropCompact = '{"tabBarItems":[{"title":"title1", "tag": 0, "systemItem": "bookmarks"},{"title":"title2", "tag": 1, "systemItem": "contacts"},{"title":"title3", "tag": 2, "systemItem": "downloads"}],"backgroundColor":[' + redBackground+','+ greenBackground+ ',' + blueBackground+ ',' + '1]}';

               viewPropCompact = '{ "tabBar": {"tabBarAppearance": {"background": "transparent", "lockBackground": true } },  "tabBarItems":[{"title":"title1", "tag": 0, "hideNavBar": false,"navBar": {"title":"Item1","appearance": {"prefersLargeTitles":true }}, "image": {"type": "symbol","name": "1.circle"}},{"title":"title2", "tag": 1, "hideNavBar": false,"navBar": {"title":"Item2"},"image": {"type": "symbol","name": "2.circle"}},{"title":"title3", "tag": 2,"hideNavBar": false,"navBar": {"title":"Item3","appearance": {"prefersLargeTitles":true}}, "image": {"type": "symbol","name": "3.circle"}}],"backgroundColor":[' + redBackground+','+ greenBackground+ ',' + blueBackground+ ',' + '1]}';
               viewPropPrimary = '{"navBarAppearance": {"prefersLargeTitles":true}}';
               viewPropSecondary = '{"preventHorizScroll":true,"horizScrollBarInvisible":true}';
               viewPropSup = null;
               break;
           case 4: //native list, double column
               viewPropJSON = '{"fullscreen":true,"primaryTitle":"Not Music", "primaryURL":"doublePrimary.html", "viewConfig": {"primary": "collectionList" }, "secondaryTitle":"Secondary", "secondaryURL":"collectionSecondary.html", "style":"doubleColumn", "preferredSplitBehavior":"automatic", "usesCompact":true, "preferredDisplayMode":"twoBesideSecondary", "primaryEdge":"leading","backgroundColor":[' + redBackground+','+ greenBackground+ ',' + blueBackground+ ',' + '1]}';
               viewPropPrimary ='{ "navBarAppearance": {"prefersLargeTitles":true}, "views": {"primaryCollection": { "config": {"initialSection": 0, "initialRow": 0, "messageTargets": ["compact", "secondary"]}, "sections":[{"listItems":[{"listImage": {"type": "symbol","name": "play.circle"},"listText": "Listen Now" },{"listImage": {"type": "symbol","name": "dot.radiowaves.left.and.right"},"listText": "Radio" },{"listImage": {"type": "symbol","name": "magnifyingglass"},"listText": "Search" }]},{"header": "Library", "listItems":[{"listImage": {"type": "symbol","name": "clock"},"listText": "Recently Added" },{"listImage": {"type": "symbol","name": "music.mic"},"listText": "Artists" },{"listImage": {"type": "symbol","name": "rectangle.stack"},"listText": "Albums" }]},{"header": "Playlists", "listItems":[{"listImage": {"type": "symbol","name": "square.grid.3x3"},"listText": "All Playlists" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 1" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 2" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 3" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 4" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 5" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 6" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 7" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 8" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 9" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 10" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 11" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 12" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 13" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 14" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 15" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 16" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 17" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 18" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 19" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 20" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 21" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 22" },{"listImage": {"type": "symbol","name": "music.note.list"},"listText": "Playlist 23" }]} ]}}}';
               viewPropSecondary='{"navBarAppearance": {"prefersLargeTitles":true}, "barButtonRight": {"type": "image", "menuType": "menu", "identifier": ".0", "image": {"type": "symbol","name": "dice"},"menuTitle": "Menu", "menuElements": [{"title":"none","identifier": "1","menuImage": {"type": "symbol","name": "dice","symbolConfig":[{"type":"scale","value":"large"}]}},{"title":"bottom","identifier": "2","menuImage": {"type": "symbol","name": "dice","symbolConfig":[{"type":"weight","value":"bold"}]}},{"title":"top","identifier": "3","menuImage": {"type": "symbol","name": "dice","symbolConfig":[{"type":"scale","value":"large"},{"type":"weight","value":"bold"}]}},{"title":"centered","identifier": "4","menuImage": {"type": "symbol","name": "dice"}} ,{"title":"Exit","identifier": "5","menuImage": {"type": "symbol","name": "flame.fill"}, "attributes": ["destructive"]} ]}}';
               viewPropSecondarymen='{"navBarAppearance": {"prefersLargeTitles":true}, "barButtonRight": {"type": "text", "menuType": "menu", "identifier": ".0", "title": "111", "menuTitle": "Menu", "menuElements": [{"title":"none","identifier": "1"}]}}';
               viewPropSecondarytst='{"navBarAppearance": {"prefersLargeTitles":true}, "barButtonRight": {"type": "image",  "menuType": "menu", "identifier": ".0", "image": {"type": "symbol","name": "dice"},"menuTitle": "Menu", "menuElements": [{"title":"none","identifier": "1","menuImage": {"type": "symbol","name": "dice"}}]}}';
               viewPropCompact = '{  "compactURL":"compactList.html","tabBar": {"tabBarAppearance": {"background": "transparent", "lockBackground": true } },  "tabBarItems":[{"title":"Listen Now", "tag": 0, "hideNavBar": false,"navBar": {"title":"Listen Now","appearance": {"prefersLargeTitles":true }}, "image": {"type": "symbol","name": "play.circle"}},{"title":"Radio", "tag": 1, "hideNavBar": false,"navBar": {"title":"Radio"},"image": {"type": "symbol","name": "dot.radiowaves.left.and.right"}},{"title":"Library", "tag": 2,"hideNavBar": false,"navBar": {"title":"Recently Added","appearance": {"prefersLargeTitles":true}}, "image": {"type": "symbol","name": "rectangle.stack"}}], "preventHorizScroll":true, "horizScrollBarInvisible":true,   "backgroundColor":[' + redBackground+','+ greenBackground+ ',' + blueBackground+ ',' + '1]}';
               break;

       }
  cordova.plugins.SplitView.showView(viewPropJSON,viewPropPrimary,viewPropSecondary,viewPropSup,viewPropCompact,null,null);
   }
}


