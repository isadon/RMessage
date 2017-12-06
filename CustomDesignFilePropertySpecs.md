## RMessage Custom Design File Properties

* **backgroundColor**: Background color for the RMessage. String: [#000000, #FFFFFF].
* **backgroundColorAlpha**: Apply a transparency to the background color. Must be less than 1.0 but not 0 for blurring to work
  when blurBackground key is set to enabled. Numeric: [0, 1.0].
* **opacity**: Opacity of the RMessage. Numeric: [0, 1.0].
* **iconImage**: Filename of image (in app bundle) to use as an icon on the left side of the RMessage. String.
* **iconImageRelativeCornerRadius**: Corner radius percentage relative to icon image to apply to icon image. For example 0.5 (use 50% of icon image width as corner radius) would mask the icon image to always be a circle. Numeric: [0, 1.0].
* **backgroundImage**: Filename of image (in app bundle) to use as a background image for the RMessage. String.
* **titleFontName**: Name of font to use for title text. String.
* **titleFontSize**: Size of the title font. Numeric: [0, Max depending on font used]
* **titleTextAlignment**: Alignment to apply to title label. String: {"left", "right", "center", "justified", "normal"}.
* **titleTextColor**: Color of the title text. String: [#000000, #FFFFFF].
* **titleShadowColor**: Color of the title shadow. String: [#000000, #FFFFFF].
* **titleShadowOffsetX**: Amount of pt to offset in x direction title shadow from title text. Numeric.
* **titleShadowOffsetY**: Amount of pt to offset in y direction title shadow from title text. Numeric.
* **subTitleFontName**: Name of font to use for subtitle text. String.
* **subTitleFontSize**: Size of the subtitle font. Numeric: [0, Max depending on font used].
* **subtitleTextAlignment**: Alignment to apply to subtitle label. String: {"left", "right", "center", "justified", "normal"}.
* **subTitleTextColor**: Color of the subtitle shadow. String: [#000000, #FFFFFF].
* **subTitleShadowColor**: Color of the subtitle shadow. String: [#000000, #FFFFFF].
* **subTitleShadowOffsetX**: Amount of pt to offset in x direction subtitle shadow from subtitle text. Numeric.
* **subTitleShadowOffsetY**: Amount of pt to offset in y direction subtitle shadow from subtitle text. Numeric.
* **buttonTitleFontName**: Name of font to use for the button title text. String.
* **buttonTitleFontSize**: Size of the button title font. Numeric: [0, Max depending on font used]
* **buttonResizeableBackgroundImage**: Filename of image (in app bundle) to use as a resizeable background image for the button. String.
* **buttonTitleTextColor**: Color of the button title text. String: [#000000, #FFFFFF].
* **buttonTitleShadowColor**: Color of the button title shadow. String: [#000000, #FFFFFF].
* **buttonTitleShadowOffsetX**: Amount of pt to offset in x direction the button title text shadow. Numeric.
* **buttonTitleShadowOffsetY**: Amount of pt to offset in y direction the button title text shadow. Numeric.
* **blurBackground**: Enable/disable blurring of the background behind the RMessage. Use in conjunction with
  backgroundColorAlpha. Numeric boolean [0, 1].

Property keys are always strings, values can be string or numeric. If specifying a numeric value don't encapsulate the numeric value in a string.
[x,y] Signifies the range of values x to y that are allowed for the field.

For example:

```
"backgroundColor": "#FFFFFF",
"opacity": 1.0
```

**Note**: Design file button properties (properties starting with button*) will not take effect when a UIButton is passed in programmatically such as in customizeMessageView:.

