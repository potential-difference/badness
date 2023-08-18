all rigs should have these sliders:
dimmer "main brightness"
alphaRate "used by anims to modulate alpha
    should be set as default"
manualAlpha "supposed to be a separate way to modulate alpha specific to manual animations"
functionRate "used by anims to modulate 
blurriness "amount of gaussian blur applied to donuts"
functionChangeRate
alphaChangeRate
backgroundChangeRate
strokeSlider "modulates stroke of anims"
wideSlider "modulates width of anims"
highSlider "modulates height of anims"

these variables are meant to be tweaked, not modulated by envelopes

Anim addition
  when do envelopes get applied?
  when do animations stop drawing?
  //manual: add to the list of anims when keydown
        remove from the list when keyup
        easy with toggle,
        but tricky with momentary
        we can get a different keypress signal
        keyRise:
            if 
        keyFall
        keyPressed
        keyToggled 
            every frame, 