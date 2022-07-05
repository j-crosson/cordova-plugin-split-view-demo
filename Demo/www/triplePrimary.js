
document.addEventListener('deviceready', onDeviceReady, false);

function onDeviceReady()
{
    navigator.splashscreen.hide();
    document.getElementById(0).setAttribute("class","itemSelected");
    cordova.plugins.SplitView.message = recievedMessage;
}

function selectItem(item)
{
  for(let i=0;i<2;i++)
  {
      if(item == i)
          document.getElementById(i).setAttribute("class","itemSelected");
      else
          document.getElementById(i).setAttribute("class","itemButtonChild");
  }
  cordova.plugins.SplitView.sendMessage("supplementary",item.toString(),null,null);
  cordova.plugins.SplitView.display("show","supplementary");
}

function recievedMessage(item)
{
    selectItem(item);
}

function goAway()
{
    cordova.plugins.SplitView.viewAction("dismiss");
}

