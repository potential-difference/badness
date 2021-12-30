void setupSpecifics() {
    
    /*
    HashMap<String, Class> classMap = new HashMap<String, Class>();
    Class[] classList= this.getClass().getClasses();
    for (int i=0; i<classList.length; i++) {
    if (classList[i].getSuperclass() == new Anim(rigg).getClass()) {
    String name = classList[i].getName();
    classMap.put(name.substring(name.indexOf('$')+1), classList[i]);
    
    // if (classList[i].getSuperclass() == Class.forName("sketch_name"+"$Anim"));
}
}
    println(classMap);
    */

    
    if (rigg != null) {
        // setup which anims are used on which rig here
        rigg.availableAnims = new int[] {1, 2, 3, 6, 7, 8};      
        //rigg.availableAnims = String[] {"Boxes","StarMesh"...};
        rigg.availableAlphaEnvelopes = new int[] {0, 1, 2, 3, 4, 5, 6};  
        rigg.availableFunctionEnvelopes = new int[] {0, 1, 2};  
        rigg.availableBkgrnds = new int[] {0, 1, 10, 11, 12, 13, 14};
        //rigg.availableColors = new int[] { 0, 1, 2, 3, 4, 13, 10, 11, 12, 2, 3};
        
    }
    
    if (roof != null) {
        // setup which anims are used on which rig here - defualt is 0,1,2,3...
        roof.availableAnims = new int[] {0, 7, 8, 11, 12, 13, 14, 15, 17, 18, 19};       
        roof.availableAlphaEnvelopes = new int[] {0, 1, 2, 3, 4, 5, 6};  
        roof.availableFunctionEnvelopes = new int[] {0, 1, 2};  
        roof.availableBkgrnds = new int[] {0, 1, 3, 4, 5, 8, 10};
        //roof.availableColors = rigg.availableColors; // = new int[] { 0, 1, 2, 3, 4, 13, 10, 11, 12, 2, 3};
        
    }
    
    if (cans!= null) {
        cans.availableAnims = new int[] {0, 7, 8, 11, 12, 13, 14, 15, 17, 18, 19};        // setup which anims are used on which rig here - defualt is 0,1,2,3...
    }
    
    if (pars != null) {
        pars.availableAnims = new int[] {0, 19};      // setup which anims are used on which rig here
        pars.availableAlphaEnvelopes = new int[] {0, 1, 2, 3, 4, 5, 6};  
        pars.availableFunctionEnvelopes = new int[] {0, 1, 2};  
        pars.availableBkgrnds = roof.availableBkgrnds; //new int[] {0, 3, 4, 5};
    }
    
    ///////////////////////////////// UPDATE THE DROPDOWN LISTS WITH AVLIABLE OPTIONS ///////////////////////////////////////////////////////
    for (Rig rig : rigs) {    
        rig.ddVizList.clear();
        rig.ddBgList.clear();
        rig.ddAlphaListA.clear();
        rig.ddAlphaListA.clear();
        rig.ddFuncListB.clear();
        rig.ddFuncListB.clear();
        for (int i = 0; i < rig.availableBkgrnds.length; i++) { 
            int index = rig.availableBkgrnds[i];
            //rig.ddBgList.addItem(rig.backgroundNames[index], index); //add all available anims to VizLists -
            rig.ddBgList.addItem("backround  " + index, index); //add all available anims to VizLists -
        }
        for (int i = 0; i < rig.availableAnims.length; i++) {
            int index = rig.availableAnims[i];
            //rig.ddVizList.addItem(rig.animNames[index], index); //add all available anims to VizLists -
            rig.ddVizList.addItem("viz  " + index, index); //add all available anims to VizLists -
        }
        /*
        for (int i = 0; i<rig.availableAnims.length; i++) {
        String name = rig.availableAnims[i];
        rig.ddVizList.addItem(name,i); 
    }
        */
        for (int i = 0; i < rig.availableAlphaEnvelopes.length; i++) {
            int index = rig.availableAlphaEnvelopes[i];
            rig.ddAlphaListA.addItem("alph" + index, index); //add all available anims to VizLists -
        }
        for (int i = 0; i < rig.availableAlphaEnvelopes.length; i++) {
            int index = rig.availableAlphaEnvelopes[i];
            rig.ddAlphaListB.addItem("alph  " + index, index); //add all available anims to VizLists -
        }
        for (int i = 0; i < rig.availableFunctionEnvelopes.length; i++) {
            int index = rig.availableFunctionEnvelopes[i];
            rig.ddFuncListA.addItem("func  " + index, index); //add all available anims to VizLists -
        }
        for (int i = 0; i < rig.availableFunctionEnvelopes.length; i++) {
            int index = rig.availableFunctionEnvelopes[i];
            rig.ddFuncListB.addItem("func  " + index, index); //add all available anims to VizLists -
        } 
        //need to use the actal numbers from the above aray
    }
    
    //rigg.dimmers.put(3, new Ref(cc, 34));
    
    rigg.vizIndex = 2;
    roof.vizIndex = 1;
    rigg.functionIndexA = 0;
    rigg.functionIndexB = 1;
    rigg.alphaIndexA = 0;
    rigg.alphaIndexB = 1;
    rigg.bgIndex = 0;
    roof.bgIndex = 4;
    
    rigg.colorIndexA = 2;
    rigg.colorIndexB = 1;
    roof.colorIndexA = 1;
    roof.colorIndexB = 0;
    //cans.colorIndexA = 7;
    //cans.colorIndexB = 11;
    //donut.colorIndexA = 
    //donut.colorIndexB =;
    
    //cans.infoX += 100;
    
    
    for (int i = 0; i < cc.length; i++) cc[i] = 0;  // set all midi values to 0;
    for (int i = 0; i < 100; i++) cc[i] = 1;      // set all knobs to 1 ready for shit happen
    cc[1] = 0.75;
    cc[2] = 0.75;
    cc[5] = 0.3;
    cc[6] = 0.75;
    cc[4] = 1;
    cc[8] = 1;
    cc[MASTERFXON] = 0;
    
    
    for (int i = 36; i < 52; i++)cc[i] = 0;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////// COLOR SETUP CHOSE COLOUR VALUES ///////////////////////////////////////////////
color red, pink, yell, grin, bloo, purple, teal,orange, aqua, white, black;
color red1, pink1, yell1, grin1, bloo1, purple1,teal1, aqua1, orange1;
color red2, pink2, yell2, grin2, bloo2, purple2,teal2, aqua2, orange2;
color c, flash;
color act = #07E0D3;
color act1 = #00FC84;
color bac = #370064;
color bac1 = #4D9315;
color slider = #E07F07;
color slider1 = #E0D607;
void colorSetup() {
    
    colorMode(HSB, 360, 100, 100);
    white = color(0, 0, 100);
    black = color(0, 0, 0);
    
    float alt = 0;
    float sat = 100;
    aqua = color(150 + alt, sat, 100);
    pink = color(323 + alt, sat, 90);
    bloo = color(239 + alt, sat, 100);
    yell = color(50 + alt, sat, 100);
    grin = color(115 + alt, sat, 60);
    orange = color(30 + alt, sat, 90);
    purple = color(290 + alt, sat, 70);
    teal = color(170 + alt, sat, 60);
    red = color(7 + alt, sat, 100);
    // colors that aren't affected by color swap
    float sat1 = 100;
    aqua1 = color(190 + alt, 80, 100);
    pink1 = color(323 - alt, sat1, 90);
    bloo1 = color(239 - alt, sat1, 100);
    yell1 = color(50 - alt, sat1, 100);
    grin1 = color(160 - alt, sat1, 60);
    orange1 = color(34.02 - alt, sat1, 90);
    purple1 = color(290 - alt, sat1, 70);
    teal1 = color(170 - alt, sat1, 60);
    red1 = color(15 - alt, sat1, 100);
    /// alternative colour similar to original for 2 colour blends
    float sat2 = 100;
    alt = + 6;
    aqua2 = color(190 - alt, 80, 100);
    pink2 = color(323 - alt, sat2, 90);
    bloo2 = color(239 - alt, sat2, 100);
    yell2 = color(50 - alt, sat2, 100);
    grin2 = color(160 - alt, sat2, 100);
    orange2 = color(34.02 - alt, sat2, 90);
    purple2 = color(290 - alt, sat2, 70);
    teal2 = color(170 - alt, sat2, 85);
    red2 = color(15 - alt, sat2, 100);
}
