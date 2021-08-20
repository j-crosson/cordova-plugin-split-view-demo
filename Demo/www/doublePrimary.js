
document.addEventListener('deviceready', onDeviceReady, false);

function onDeviceReady()
{
    navigator.splashscreen.hide();
    cordova.plugins.SplitView.message = recievedMessage;
}


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
