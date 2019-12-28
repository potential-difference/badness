# badness
processing lighting code

NEW YEARS LIGHTING BRANCH 

2019/2020 - using shields rig in spiral config - code a mix of PICKLE_dec_2019 and FM_2019


************* changes to make ************
In rig.draw()

Don't alphaA = alphaA.mul... 
Instead 
alphaA = alphaEnvelopeA.mul...

In anim.drawAnim() add 

alphaA*=rig.dimmer

