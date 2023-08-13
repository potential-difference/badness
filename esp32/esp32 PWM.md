PWM

The ESP32 LED PWM controller has 16 independent channels that can be configured to generate PWM signals with different properties. All pins that can act as outputs can be used as PWM pins (GPIOs 34 to 39 can’t generate PWM).

To set a PWM signal, you need to define these parameters in the code:

    Signal’s frequency;
    Duty cycle;
    PWM channel;
    GPIO where you want to output the signal.