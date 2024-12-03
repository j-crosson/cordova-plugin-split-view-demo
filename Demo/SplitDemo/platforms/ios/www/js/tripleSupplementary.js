
document.addEventListener('deviceready', onDeviceReady, false);
var itemOffset = 0;

function onDeviceReady()
{
    navigator.splashscreen.hide();
    cordova.plugins.SplitView.initChild();
    cordova.plugins.SplitView.message = recievedMessage;
}

function recievedMessage(item)
{
    doSelected(item);
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
  cordova.plugins.SplitView.sendMessage("secondary",(item + itemOffset).toString(),null,null);
  cordova.plugins.SplitView.display("show","secondary");

}

function doSelected(item)
{
    itemOffset = item * 3;
    for(let i=0;i<3;i++)
    {      
        let itmNum = (i+1) + (3 * item)
        let itm = document.getElementById(i);
        itm.textContent = "Item " + itmNum;
        itm.setAttribute("class","itemButtonChild");
    }
}
