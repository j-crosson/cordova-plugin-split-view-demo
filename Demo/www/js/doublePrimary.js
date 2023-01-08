
document.addEventListener('deviceready', onDeviceReady, false);

function onDeviceReady()
{
    navigator.splashscreen.hide();
    cordova.plugins.SplitView.message = recievedMessage;
    cordova.plugins.SplitView.action = handleEvents;
}

const  testButtonOptions = ["done","cancel","edit","save","add","compose","reply","action","organize","bookmarks","search","refresh","stop","camera","trash","play","pause","rewind","fastForward","undo","redo"];
let testButtonIndex = -1;
let theSize = testButtonOptions.length - 1;

function selectItem(item)
{
  for(let i=0;i<3;i++)
  {
      if(item == i)
          document.getElementById(i).setAttribute("class","itemSelected");
      else
          document.getElementById(i).setAttribute("class","itemButtonChild");
  }
    cordova.plugins.SplitView.sendMessage("secondary",item.toString(),null,null);
    cordova.plugins.SplitView.display("show","secondary");
}

function recievedMessage(item)
{
    selectItem(item);
}
function handleEvents(event,data)
{
    if((event === cordova.plugins.SplitView.viewEvents.buttonEvent) && (data === "rightTap"))
    {
        if (testButtonIndex++ == theSize)
            testButtonIndex = 0;
        let viewProps ='{ "barButtonRight": {"type":"system","identifier": "rightTap","title":"'+testButtonOptions[testButtonIndex]+'"} }';
        cordova.plugins.SplitView.setProperties(viewProps,null,null);//console.log(viewProps)
    }
}

function goAway()
{
    cordova.plugins.SplitView.viewAction("dismiss");
}
