
document.addEventListener('deviceready', onDeviceReady, false);

function onDeviceReady() {
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
  cordova.plugins.SplitView.primaryItemSelected(item.toString());
}

function recievedMessage(item)
{
    selectItem(item);
}
