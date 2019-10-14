/*
/////////////////////////////////////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////////// VIZ SELECTION and PREVIEW ///////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////
 void roofVizSelection(PGraphics subwindow, float dimmer) {
 // variables to use in the construction of each vis[n]
 float stroke, wide, high;
 col1 = color(white);
 col2 = color(white);
 int index = 8;
 
 //// set viz size variables to the size of the roof window
 size.viz.x = size.roofWidth/2;
 size.viz.y = size.roofHeight/2;
 size.vizWidth = size.roofWidth;
 size.vizHeight = size.roofHeight;
/*
 /// set alpha variables to roof alpha
 for ( int i = 0; i < alpha.length; i ++) alpha[i] = roofAlpha[i];
 for ( int i = 0; i < alpha.length; i ++) alpha1[i] = roofAlpha1[i];
 // set function variables to roof functions
 for ( int i = 0; i < function.length; i ++) function[i] = roofFunction[i];
 for ( int i = 0; i < function.length; i ++) function1[i] = roofFunction1[i];
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 /////////////////////////////////////////////////// VIZ SELECTION //////////////////////////////////////////////////////////////////////////
 switch(roofViz) {
 case 0: ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 for (int i = 0; i < 4; i++) {
 stroke = 20;
 wide = 10+(size.rigWidth-(size.rigWidth*function[i]));
 high = wide;
 // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
 star(i+index, 10+(pulz*wide), 10+(beat*high), -30*pulz, col1, stroke, alpha[i]*alf*dimmer);
 }
 subwindow.beginDraw();
 subwindow.background(0);
 subwindow.blendMode(LIGHTEST);
 for (int i = 0; i < 4; i++) {
 subwindow.image( blured[i+index], size.viz.x, size.viz.y-(size.viz.y/1.5), size.vizWidth*2, size.vizHeight*2);
 subwindow.image( blured[i+index], size.viz.x, size.viz.y, size.roofWidth*2, size.roofHeight*2);
 subwindow.image( blured[i+index], size.viz.x, size.viz.y+(size.viz.y/1.5), size.roofWidth*2, size.roofHeight*2);
 }
 break;
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 case 1: ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
 for (int i = 0; i < 4; i++) {
 stroke = 10+(size.vizWidth/10*0.2); //16+(10*func1);
 wide = 10+(size.vizWidth-(size.vizWidth*function[i]-20));
 high = wide;
 squareNut(i+index, col1, stroke, wide, high, alpha[i]*alf*dimmer);
 }
 subwindow.beginDraw();
 subwindow.background(0);
 subwindow.blendMode(LIGHTEST);
 for (int i = 0; i < 4; i++) {
 subwindow.image( blured[i+index], size.viz.x+100, size.viz.y-50);
 subwindow.image( blured[i+index], size.viz.x-75, size.viz.y+150);
 subwindow.image( blured[i+index], size.viz.x-150, size.viz.y-100);
 }
 break;
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 case 2: ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 // donut(int n, color col, float stroke, float wide, float high, float alph) {
 for (int i = 0; i < 4; i++) {
 stroke = 80+(function[i]*100);//14+(20*oskP);
 
 wide = size.vizWidth+10; //wide-(wide*function[i]*(i+1))
 high = size.vizHeight*2+10; //size.rigWidth+10;
 donut(i+4+index, col1, stroke, wide-(wide*function1[i]*(i+1)), high-(high*function1[i]*(i+1)), alpha[i]*alf*dimmer);
 }
 subwindow.beginDraw();
 subwindow.background(0);
 subwindow.blendMode(LIGHTEST);
 for (int i = 0; i < 4; i++) subwindow.image( blured[i+4+index], size.viz.x, size.viz.y*2, size.vizWidth, size.vizHeight*2);
 break;
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 case 3: ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 stroke = size.vizWidth/6; //16+(10*func1);
 for (int i = 0; i <4; i++) {
 wide = 15+((size.vizWidth+20)*function[i]);
 high = wide;
 //donut(int n, color col, float stroke, float sz, float sz1, float alph) {
 donut(i+index, col2, stroke, wide, high, alpha[i]*alf*dimmer);
 donut(i+4+index, col2, stroke, wide, high, alpha1[i]*alf*dimmer);
 }
 subwindow.beginDraw();
 subwindow.background(0); 
 subwindow.blendMode(LIGHTEST);
 for (int i = 0; i <4; i++) { 
 subwindow.image( blured[i+index], size.viz.x, size.viz.y-(50));
 subwindow.image( blured[i+4+index], size.viz.x, size.viz.y+50);
 subwindow.image( blured[i+index], size.viz.x, size.viz.y+(size.viz.y/2));
 }
 break;
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 case 4: ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 // star(int n, float wide, float high, float rotate, color col, float stroke, float alph) {
 for (int i=0; i<4; i+=2) {
 stroke = 10+(20*function[i]);
 wide = 10+(beats[i]*(size.vizWidth*2));
 high = 110-(pulzs[i]*(size.vizHeight*2));
 star(i+index, wide, high, -60*beats[i]+60, col1, stroke, alpha[i]*alf*dimmer);
 }
 for (int i=1; i<4; i+=2) {
 stroke = 30+(30*function1[i]);
 wide = 10+(beats[i]*(size.vizWidth*2));
 high = 110-(pulzs[i]*(size.vizHeight*1.2));
 star(i+index, wide, high, -60*beats[i]+60, col1, stroke, alpha1[i]*alf*dimmer);
 }
 subwindow.beginDraw();
 subwindow.background(0);
 subwindow.blendMode(LIGHTEST);
 for (int i = 0; i < 4; i+=2) {
 subwindow.image(blured[i+index], size.viz.x-35, size.viz.y-200);
 subwindow.image(blured[i+index], size.viz.x+35, size.viz.y-200);
 }
 for (int i = 1; i < 4; i+=2) subwindow.image(blured[i+index], size.viz.x, size.viz.y+160);
 break;
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 case 5: ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 stroke = 20+(40*oskP);
 //for (int i = 0; i < 4; i+=2) {
 wide = 10+((size.vizWidth-60)-((size.vizWidth-60)*function[0]));
 high = wide;
 // donut(int n, color col, float stroke, float sz, float sz1, float alph) {
 donut(0+index, col1, stroke, wide, high, alpha[2]*alf*dimmer);
 wide = 10+((size.vizWidth-60)-((size.vizWidth-60)*function[2]));
 high = wide;
 donut(2+index, col1, stroke, wide, high, alpha[2]*alf*dimmer);
 wide = 10+(size.vizWidth/5-(size.vizWidth/5*function1[1]));
 high = wide;
 donut(1+index, col2, stroke, wide, high, alpha1[1]*alf*dimmer);
 wide = 10+(size.vizWidth/5-(size.vizWidth/5*function1[3]));
 high = wide;
 donut(3+index, col2, stroke, wide, high, alpha1[3]*alf*dimmer);
 
 subwindow.beginDraw();
 subwindow.background(0);
 subwindow.blendMode(LIGHTEST);
 for (int i = 0; i < 4; i+=2) {
 subwindow.image( blured[i+index], size.viz.x, size.viz.y-(size.viz.y/1.5));
 subwindow.image( blured[i+1+index], size.viz.x, size.viz.y-(size.viz.y/3));
 subwindow.image( blured[i+index], size.viz.x, size.viz.y);
 subwindow.image( blured[i+1+index], size.viz.x, size.viz.y+(size.viz.y/3));
 subwindow.image( blured[i+index], size.viz.x, size.viz.y+(size.viz.y/1.5));
 }
 break;
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 case 6: ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 stroke = 90-(85*pulzSlow);
 high = size.vizHeight+20; //wide-(wide*function[i]*(i+1))
 wide = high; 
 //donutBLUR(int n, color col, float stroke, float sz, float sz1, float func, float alph) {
 for (int i = 0; i <4; i++) donut(i+index, col1, stroke, wide-(wide*function[i]*(i+1)), high-(high*function[i]*(i+1)), alpha[i]*alf*dimmer);
 subwindow.beginDraw();
 subwindow.background(0);
 subwindow.blendMode(LIGHTEST);
 for (int i = 0; i <4; i++) {
 subwindow.image( blured[i+index], size.viz.x-65, size.viz.y-250, size.vizWidth*2, size.vizHeight*2);
 subwindow.image( blured[i+index], size.viz.x+65, size.viz.y-150, size.vizWidth*2, size.vizHeight*2);
 subwindow.image( blured[i+index], size.viz.x-100, size.viz.y+150, size.vizWidth*2, size.vizHeight*2);
 subwindow.image( blured[i+index], size.viz.x+100, size.viz.y+250, size.vizWidth*2, size.vizHeight*2);
 }
 break;
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 }
 subwindow.endDraw();
 
 ///////////////////////////////////////////////////// END OF VIZ LIST /////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
 //////////////////////////////////////////////// END OF PLAYWITHYOURSELF /////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////////////////
 }
 */
