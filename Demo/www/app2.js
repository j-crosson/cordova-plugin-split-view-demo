

/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
document.addEventListener('deviceready', onDeviceReady, false);

function onDeviceReady() {
    // Cordova is now initialized. Have fun!
    navigator.splashscreen.hide();
    cordova.plugins.SplitView.initSecondary();
    cordova.plugins.SplitView.selected = doSelected;
    console.log('Running cordova-' + cordova.platformId + '@' + cordova.version);
    document.getElementById('deviceready').classList.add('ready');
}


function doSelected(item)
{
    let newtext = "Zero";
    switch(item)
    {
            case '0':
                newtext = "One";
                setTimeout(cordova.plugins.SplitView.sendResults('Selected first item'), 0);
                break;
            case '1':
                newtext = "Two";
                setTimeout(cordova.plugins.SplitView.sendResults('Selected second item'), 0);
                break;
            case '2':
                newtext = "Three";
                setTimeout(cordova.plugins.SplitView.sendResults('Selected third item'), 0);
                break;
            case 'One':
                newtext = "One";
                setTimeout(cordova.plugins.SplitView.sendResults('Selected first table item'), 0);
                break;
            case 'Two':
                newtext = "Two";
                setTimeout(cordova.plugins.SplitView.sendResults('Selected second table item'), 0);
                break;
            case 'Three':
                newtext = "Three";
                setTimeout(cordova.plugins.SplitView.sendResults('Selected third table item'), 0);
                break;
            case 'Four':
                newtext = "Four";
                setTimeout(cordova.plugins.SplitView.sendResults('Selected fourth table item'), 0);
                break;
            case 'Five':
                newtext = "Five";
                setTimeout(cordova.plugins.SplitView.sendResults('Selected fifth table item'), 0);
                break;
    }

    document.getElementById("centertext").textContent=newtext;
}
