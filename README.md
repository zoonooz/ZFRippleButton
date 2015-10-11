ZFRippleButton
==============

iOS Custom UIButton effect inspired by Google Material Design written in Swift

<p align="center"><img src="Screenshot/colored-button.gif"/></p>

## Usage

Set the UIButton class in Nib to ```ZFRippleButton``` or create it programmatically.

### Options
```rippleOverBounds``` indicate that ripple should draw outsise the bounds or not

<img src="Screenshot/outbounds-button.gif"/>

```trackTouchLocation``` indicate that ripple should show from the touch location or not

<img src="Screenshot/track-button.gif"/>

```shadowRippleEnable``` indicate that it will show additional shadow when you click or not

<img src="Screenshot/shadow-button.gif"/>

and you can set the color of ripple using ```rippleColor``` and ```rippleBackgroundColor```

```touchUpAnimationTime``` is time interval of touch up animation. Default value is 0.6 second and causes slow response to fast consecutive button press as follows:

<img src="Screenshot/longer-touchup-animation-time.gif"/>

Shorten this value (the following is 0.1 second) to make the response fast.

<img src="Screenshot/shorter-touchup-animation-time.gif"/>

## Requirements
- iOS >= 7.0

## Author

Amornchai Kanokpullwad, amornchai.zoon@gmail.com

## License

ZFRippleButton is available under the MIT license. See the LICENSE file for more info.
