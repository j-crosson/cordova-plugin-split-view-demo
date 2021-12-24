
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

       //
       // see JSON.js for formatted JSON
       //
       switch (option)
       {
           case 0:
               viewPropJSON = '{"primaryTitle":"Primary", "secondaryTitle":"Secondary","fullscreen":true, "Style":"doubleColumn","backgroundColor":[' + redBackground+','+ greenBackground+ ',' + blueBackground+ ',' + '1]}';
               break;
           case 1:
               viewPropJSON = '{"primaryTitle":"Primary","primaryURL":"doublePrimary.html","secondaryTitle":"Secondary","secondaryURL":"doubleSecondary.html", "style":"doubleColumn","topColumnForCollapsingToProposedTopColumn":"primary", "preferredSplitBehavior":"automatic","preferredDisplayMode":"twoBesideSecondary","primaryEdge":"leading","backgroundColor":[' + redBackground+','+ greenBackground+ ',' + blueBackground+ ',' + '1]}';
               viewPropPrimary ='{ "barButtonRight": {"type":"text","title":"Tap Me","identifier": "rightTap"} }';
               //Demo left button
               //viewPropPrimary ='{ "barButtonRight": {"type":"text","title":"Tap Me","identifier": "rightTap"},"barButtonLeft": {"type":"text","title":"Left"} }';

               viewPropSecondary='{ "barButtonRight": {"type": "image", "menuType": "menu", "identifier": ".0", "image": {"type": "symbol","name": "dice"},"menuTitle": "Menu", "menuElements": [{"title":"Item 1","identifier": ".1","menuImage": {"type": "symbol","name": "dice","symbolConfig":[{"type":"scale","value":"large"}]}},{"title":"Item 2","identifier": ".2","menuImage": {"type": "symbol","name": "dice","symbolConfig":[{"type":"weight","value":"bold"}]}},{"title":"Item 3","identifier": ".3","menuImage": {"type": "symbol","name": "dice","symbolConfig":[{"type":"scale","value":"large"},{"type":"weight","value":"bold"}]}},{"title":"Item 4","identifier": ".4","menuImage": {"type": "symbol","name": "dice"}} ,{"title":"destructive","identifier": ".5","menuImage": {"type": "symbol","name": "flame.fill"}, "attributes": ["destructive"]} ]}}';
               viewPropCompact = null;
               break;
           case 2:
               viewPropJSON = '{"primaryTitle":"Primary",    "primaryURL":"triplePrimary.html","topColumnForCollapsingToProposedTopColumn":"primary","showsSecondaryOnlyButton":true,"preferredDisplayMode":"twoBesideSecondary","secondaryTitle":"Secondary","secondaryURL":"tripleSecondary.html","style":"tripleColumn","supplementaryTitle":"Supplementary","supplementaryURL":"tripleSupplementary.html","tintColor":[1,255,3,1],"backgroundColor":[' + redBackground+','+ greenBackground+ ',' + blueBackground+ ',' + '1]}';
               viewPropPrimary = null;
               viewPropSecondary = null;
               viewPropCompact = null;
               break;
           case 3:
               viewPropJSON = '{"primaryURL":"tab1.html","primaryTitle":"Primary","secondaryURL":"tab2.html", "secondaryTitle":"Secondary","compactURL":"compact.html", "style":"doubleColumn", "preferredSplitBehavior":"automatic","preferredDisplayMode":"twoBesideSecondary","usesCompact":true, "backgroundColor":[' + redBackground+','+ greenBackground+ ',' + blueBackground+ ',' + '1]}';
              
             //  Demo of tabBar System Items
             //  viewPropCompact = '{"tabBarItems":[{"title":"title1", "tag": 0, "systemItem": "bookmarks"},{"title":"title2", "tag": 1, "systemItem": "contacts"},{"title":"title3", "tag": 2, "systemItem": "downloads"}],"backgroundColor":[' + redBackground+','+ greenBackground+ ',' + blueBackground+ ',' + '1]}';

               viewPropCompact = '{"tabBarItems":[{"title":"title1", "tag": 0, "image": {"type": "symbol","name": "1.circle"}},{"title":"title2", "tag": 1, "image": {"type": "symbol","name": "2.circle"}},{"title":"title3", "tag": 2, "image": {"type": "symbol","name": "3.circle"}}],"backgroundColor":[' + redBackground+','+ greenBackground+ ',' + blueBackground+ ',' + '1]}';
               viewPropPrimary = null;
               viewPropSecondary = null;
               break;
       }

  cordova.plugins.SplitView.showView(viewPropJSON,viewPropPrimary,viewPropSecondary,null,viewPropCompact,null,null);
   }
}


