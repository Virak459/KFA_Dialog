function printFullScreen() {
    // Set the scaling to 100% or None to print at full size
    var printSettings = {
      "initial-scale": 1,
      "scaling": "100",
        "size": A4,
        "margin-top": "0.8cm",
        "margin-bottom": "0.8cm",
       " margin-left":"0.8cm",
       " margin-right":"0.8cm",
    };
    
    // Set the margins to 0 to print full-screen
    var marginSettings = {
      "top": 0,
      "bottom": 0,
      "left": 0,
      "right": 0
    };
    
    // Set the print settings
    window.printSettings = printSettings;
    // window.marginSettings = marginSettings;
    
    // Open the print dialog
    window.print();
  }