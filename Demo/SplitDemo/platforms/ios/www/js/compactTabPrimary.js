
document.addEventListener('deviceready', onDeviceReady, false);

function onDeviceReady()
{
    navigator.splashscreen.hide();
    cordova.plugins.SplitView.initChild();
    cordova.plugins.SplitView.message = recievedMessage;
}

function selectItem(item)
{
    selectItemMsg(item,true);
}

function selectItemMsg(item, forwardMsg)
{
  for(let i=0;i<3;i++)
  {
      if(item == i)
          document.getElementById(i).setAttribute("class","itemSelected");
      else
          document.getElementById(i).setAttribute("class","itemButtonChild");
  }
    cordova.plugins.SplitView.sendMessage("secondary",item.toString(),null,null);
    if(forwardMsg)
        cordova.plugins.SplitView.sendMessage("compact",item.toString(),null,null);
}

function recievedMessage(item)
{
    selectItemMsg(item, false);
}

function goAway()
{
    cordova.plugins.SplitView.viewAction("dismiss");
}
