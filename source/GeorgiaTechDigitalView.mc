import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian as Date;
using Toybox.ActivityMonitor as Mon;

class GeorgiaTechDigitalView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);
			
		
		setDateDisplay();

        // Update the view
        var view = View.findDrawableById("TimeLabel") as Text;
        view.setColor(getApp().getProperty("TextColor") as Number);
        view.setText(timeString);

        

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
      //  var steps = Mon.getInfo().steps;
      //  var goal = Mon.getInfo().stepGoal;
   //     var percentage=(Mon.getInfo().steps*100/Mon.getInfo().stepGoal);
       	var percentage = setRing();
      // 	percentage = 0;
        drawRing(percentage, dc);

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

	private function setDateDisplay() {
		var dateView = View.findDrawableById("DateLabel");
		var dateFormat="$1$ $2$";
		var dateDay=Date.info(Time.now(), Time.FORMAT_LONG).day as Number;
		var month=Date.info(Time.now(), Time.FORMAT_LONG).month as Text;
		var dateString = Lang.format(dateFormat, [month, dateDay]);
		dateView.setColor(Application.getApp().getProperty("TextColor"));
		dateView.setText(dateString);	
		}
	
	private function setRing() {
		var pref = Application.getApp().getProperty("OuterRingMeaning");
			if (pref == 1) {
			var percentage=(Mon.getInfo().steps*100/Mon.getInfo().stepGoal);
				return percentage;
				}
			else {
				if (pref == 2) {
						var percentage = System.getSystemStats().battery;
						return percentage;
						}
					
				else {
					if (Mon.getInfo() has :floorsClimbed){
						var percentage = ((Mon.getInfo().floorsClimbed *100 / Mon.getInfo().floorsClimbedGoal));
						return percentage;
					}
					else {
					var percentage = 0;
					return percentage;
					}
					}		
			}
		}
		
	private function drawRing(percentage, dc){
		var centerX=(dc.getWidth())/2;
		var centerY=(dc.getHeight()/2)-1;
		var percentNum=percentage.toFloat();
		var degreeNum=((361*percentNum)/100) + 90;
		dc.setColor(Application.getApp().getProperty("OuterRingColor"), Graphics.COLOR_TRANSPARENT);
		dc.setPenWidth(6);
			if (percentNum>0){
				if (percentNum>=100) {
					dc.drawCircle(centerX,centerY,centerY);
					}
				else {
					dc.drawArc(centerX,centerY, centerX-3, Graphics.ARC_COUNTER_CLOCKWISE, 90, degreeNum);
					}
				}
		}
		
		
		
		

}


