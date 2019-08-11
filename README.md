# Power Panel
Select widget in the normal way.
Options are Sensor, BattSize and Color
  You can choose any sensor or input.
  The widget will divide that by the total (BattSize) and report the remaining percentage.
  I.E: 1 - used/total
  But, it was intended for battery use.
  
  BattSize is the total.
  it must be multiplied by 100 (35 = 3500mAh)
  Sorry. I know it's wonky. I can set the default to 3500, but scrolling to set a different value is limited to 0 - 100 by OpenTX.
  
  Color is the text color. Use the RGB fields to set the color of the widget.
  I changed the gauge to be user color until it hits 10% when it turns yellow, then red at 5%.
  So, if you use pure red or pure yellow for text, it will switch or not switch based on your base color selection.
  
Voice calls are at 10% intervals above 10% remaining and then 5% intervals below.

All widget sizes are working except XL. It isn't finished yet.

Right now, if you have multiple instances of the widget running, it will do a voice call for each one. So, if you have the top bar widget, a small on one screen,and a large on another, it will call "90% 90% 90%" instead of "90%". I am working on that.

Lastly, let me know if there are things you think might work better.
  I ignore most anything that isn't accompanied by a pint of Guiness...just saying! ;)
