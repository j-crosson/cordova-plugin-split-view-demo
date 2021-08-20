
document.addEventListener('deviceready', onDeviceReady, false);
document.addEventListener('touchmove', function(e) {
    e.preventDefault();
}, { passive: false });

function onDeviceReady() {
    navigator.splashscreen.hide();
    // For classic "root" demo, use one of the following lines:
    //doViewWeb();
    //doViewTable();
}
