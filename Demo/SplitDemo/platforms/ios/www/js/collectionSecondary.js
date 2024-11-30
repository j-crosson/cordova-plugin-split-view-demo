
document.addEventListener('deviceready', onDeviceReady, false);
let newtext = "Zero";

function onDeviceReady()
{
    navigator.splashscreen.hide();
    cordova.plugins.SplitView.initChild();
    cordova.plugins.SplitView.message = recievedMessage;
    cordova.plugins.SplitView.action = handleEvents;
}

function recievedMessage(item)
{
}


//sections without header start at zero otherwise header is zeroth entry
function displaySelection(row,section)
{
    let rowNumber = (section == 0)? row + 1 : row
    document.getElementById("centertext1").textContent="Row " + rowNumber;
    document.getElementById("centertext").textContent="Section "+ (section+1);
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
              break;
              
          case "2":
              row = 5;
              section = 2;
              scrollPosition = "bottom"
              break;
              
          case "3":
              row = 8;
              section = 2;
              scrollPosition = "top"
              break;

          case "4":
              row = 9;
              section = 2;
              scrollPosition = "centeredVertically"
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
