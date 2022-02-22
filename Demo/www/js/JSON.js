/*
//
// Two column split view
//
{
  "fullscreen":true,
  "primaryTitle": "Primary",
  "primaryURL": "doublePrimary.html",
  "secondaryTitle": "Secondary",
  "secondaryURL": "doubleSecondary.html",
  "style": "doubleColumn",
  "topColumnForCollapsingToProposedTopColumn": "primary",
  "preferredSplitBehavior": "automatic",
  "preferredDisplayMode": "twoBesideSecondary",
  "primaryEdge": "leading",
  "backgroundColor": [
    228,
    228,
    228,
    1
  ]
}

//
// Two column primary view
//

{
  "barButtonRight": {
    "type": "text",
    "title": "Tap Me",
    "identifier": "rightTap"
  },
 "navBarAppearance":{
    "prefersLargeTitles":true
 }
}

//
// Two column secondary view
//

{
  "barButtonRight": {
    "type": "image",
    "menuType": "menu",
    "identifier": ".0",
    "image": {
      "type": "symbol",
      "name": "dice"
    },
    "menuTitle": "Menu",
    "menuElements": [
      {
        "title": "Item 1",
        "identifier": ".1",
        "menuImage": {
          "type": "symbol",
          "name": "dice",
          "symbolConfig": [
            {
              "type": "scale",
              "value": "large"
            }
          ]
        }
      },
      {
        "title": "Item 2",
        "identifier": ".2",
        "menuImage": {
          "type": "symbol",
          "name": "dice",
          "symbolConfig": [
            {
              "type": "weight",
              "value": "bold"
            }
          ]
        }
      },
      {
        "title": "Item 3",
        "identifier": ".3",
        "menuImage": {
          "type": "symbol",
          "name": "dice",
          "symbolConfig": [
            {
              "type": "scale",
              "value": "large"
            },
            {
              "type": "weight",
              "value": "bold"
            }
          ]
        }
      },
      {
        "title": "Item 4",
        "identifier": ".4",
        "menuImage": {
          "type": "symbol",
          "name": "dice"
        }
      },
      {
        "title": "destructive",
        "identifier": ".5",
        "menuImage": {
          "type": "symbol",
          "name": "flame.fill"
        },
        "attributes": [
          "destructive"
        ]
      }
    ]
  }
}


//
// Three column split view
//

{
  "fullscreen":true,
  "primaryTitle": "Primary",
  "primaryURL": "triplePrimary.html",
  "topColumnForCollapsingToProposedTopColumn": "primary",
  "showsSecondaryOnlyButton": true,
  "preferredDisplayMode": "twoBesideSecondary",
  "secondaryTitle": "Secondary",
  "secondaryURL": "tripleSecondary.html",
  "style": "tripleColumn",
  "supplementaryTitle": "Supplementary",
  "supplementaryURL": "tripleSupplementary.html",
  "tintColor": [
    1,
    255,
    3,
    1
  ],
  "backgroundColor": [
    228,
    228,
    228,
    1
  ]
}

//
// Compact TabView split view
//

{
  "primaryURL": "tab1.html",
  "primaryTitle": "Primary",
  "secondaryURL": "tab2.html",
  "secondaryTitle": "Secondary",
  "compactURL": "compact.html",
  "style": "doubleColumn",
  "preferredSplitBehavior": "automatic",
  "preferredDisplayMode": "twoBesideSecondary",
  "usesCompact": true,
  "backgroundColor": [
    228,
    228,
    228,
    1
  ]
}

//
// Compact view compact
//

  "tabBar":{
    "tabBarAppearance":{
       "background":"transparent",
       "lockBackground":true
    }
  },
  "tabBarItems": [
   {
     "title":"title1",
     "tag":0,
     "hideNavBar":false,
     "navBar":{
        "title":"Item1",
        "appearance":{
           "prefersLargeTitles":true
        }
     },
     "image":{
        "type":"symbol",
        "name":"1.circle"
     }
   },
    {
      "title": "title2",
      "tag": 1,
      "image": {
        "type": "symbol",
        "name": "2.circle"
      }
    },
  {
      "title":"title3",
      "tag":2,
      "hideNavBar":false,
      "navBar":{
         "title":"Item3",
         "appearance":{
            "prefersLargeTitles":true
         }
      },
      "image":{
         "type":"symbol",
         "name":"3.circle"
      }
   }
 ],
  "backgroundColor": [
    228,
    228,
    228,
    1
  ]
}

*/
