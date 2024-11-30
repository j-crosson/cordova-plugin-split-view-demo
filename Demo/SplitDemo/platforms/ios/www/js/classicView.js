

        function doClassicViewWeb()
         {
                cordova.plugins.SplitView.initSplitView();

                if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches)
                {
                    // is dark
                    cordova.plugins.SplitView.setPrimaryBackgroundColor(30,30,30);
                    cordova.plugins.SplitView.setSecondaryBackgroundColor(30,30,30);
                }
                else
                {
                    // not dark
                    cordova.plugins.SplitView.setPrimaryBackgroundColor(228,228,228);
                    cordova.plugins.SplitView.setSecondaryBackgroundColor(228,228,228);
                }
                cordova.plugins.SplitView.preferredPrimaryColumnWidthFraction = 0.5;
                cordova.plugins.SplitView.primaryTitle = "Primary";
                cordova.plugins.SplitView.secondaryTitle = "Secondary";
                cordova.plugins.SplitView.leftButtonTitle = "Cancel";
                cordova.plugins.SplitView.rightButtonTitle = "Done";
                cordova.plugins.SplitView.closed = splitViewClosed;
           
                // Classic split view tests
                //
                //test color set
                //cordova.plugins.SplitView.setBarTintColor(255,0,0);
                //cordova.plugins.SplitView.setTintColor(0,255,0);

                //test fullscreen
                //cordova.plugins.SplitView.fullscreen = true;
            
                //test maximumPrimaryColumnWidth
                //cordova.plugins.SplitView.maximumPrimaryColumnWidth = 100.0
            
                //test minimumPrimaryColumnWidth
                //cordova.plugins.SplitView.minimumPrimaryColumnWidth = 100.0
                
                cordova.plugins.SplitView.show(null,null,true,null,null);
        }


        function doClassicViewTable()
        {
            cordova.plugins.SplitView.initSplitView();
            cordova.plugins.SplitView.preferredPrimaryColumnWidthFraction = 0.5;
            cordova.plugins.SplitView.displayModeButtonItem = false;
            cordova.plugins.SplitView.primaryTitle = "Primary";
            cordova.plugins.SplitView.secondaryTitle = "Secondary";
            cordova.plugins.SplitView.rightButtonTitle = "Done";
            cordova.plugins.SplitView.useTableView = true;
            cordova.plugins.SplitView.closed = splitViewClosed;
            for(const item of tableItems)
            {
                cordova.plugins.SplitView.addTableItem(item.itemText,item.itemImage);
            }
            if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches)
            {
                // is dark
                cordova.plugins.SplitView.setSecondaryBackgroundColor(30,30,30);
            }
            else
            {
                // not dark
                cordova.plugins.SplitView.setSecondaryBackgroundColor(228,228,228);
            }
            cordova.plugins.SplitView.show(null,null,true,null,null);
        }
            
            const tableItems = [
              {
                itemText: "One",
                itemImage: "tv.png"
              },
              {
                itemText: "Two",
                itemImage: "tv.png"
              },
              {
                itemText: "Three",
                itemImage: "tv.png"
              },
              {
                itemText: "Four",
                itemImage: "tv.png"
              },
              {
                itemText: "Five",
                itemImage: "tv.png"
              }
            ];

            function splitViewClosed( results,status)
            {
                if(status == cordova.plugins.SplitView.dismissType.left)
                    document.getElementById("result").textContent="Cancelled";
                else
                    document.getElementById("result").textContent=results;
            }
