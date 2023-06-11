import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;

class SolarStatusView extends WatchUi.View {
    var sd = null;
    var refreshTimer = null;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        if (System.getDeviceSettings().screenHeight == 360) {
            setLayout(Rez.Layouts.MainLayout(dc));
        } else if (System.getDeviceSettings().screenHeight == 416) {
            setLayout(Rez.Layouts.MainLayout_Epix(dc));
        } else if (System.getDeviceSettings().screenHeight == 454) {
            setLayout(Rez.Layouts.MainLayout_EpixPro51(dc));
        }
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        if (sd != null && sd.getData() != null && !sd.getData().isEmpty()) {
            var soc = sd.getSOC();
            var pv = sd.getPV();
            var consumption = sd.getConsumption();
            var grid = sd.getGrid();
            var batteryuse = sd.getBatteryuse();
            if (System.getDeviceSettings().screenHeight == 360) {
                dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_TRANSPARENT);
                var barheight = (soc.toFloat() / 100.0 * 62.0).toNumber();
                dc.fillRectangle(13, 111+(62-barheight), 42, barheight);
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                dc.drawLine(55, 140, 118, 140);
                dc.drawLine(161, 140, 233, 140);
                dc.drawLine(140, 54, 140, 115);
                dc.drawLine(140, 162, 140, 220);
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                dc.drawText(30, 130, Graphics.FONT_GLANCE_NUMBER, soc+"%", Graphics.TEXT_JUSTIFY_CENTER);
                dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
                dc.drawText(170, 30, Graphics.FONT_SYSTEM_XTINY, pv+"kW", Graphics.TEXT_JUSTIFY_LEFT);
                dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
                dc.drawText(200, 115, Graphics.FONT_SYSTEM_XTINY, grid+"kW", Graphics.TEXT_JUSTIFY_CENTER);
                dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
                dc.drawText(85, 115, Graphics.FONT_SYSTEM_XTINY, batteryuse+"kW", Graphics.TEXT_JUSTIFY_CENTER);
                dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
                dc.drawText(170, 225, Graphics.FONT_SYSTEM_XTINY, consumption+"kW", Graphics.TEXT_JUSTIFY_LEFT);
            } else if (System.getDeviceSettings().screenHeight == 416) {
                dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_TRANSPARENT);
                var barheight = (soc.toFloat() / 100.0 * (252 - 173)).toNumber();
                dc.fillRectangle(17, 174+((252-173)-barheight), 48, barheight);
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                dc.drawLine(75, 210, 184, 210);
                dc.drawLine(240, 210, 366, 210);
                dc.drawLine(210, 63, 210, 180);
                dc.drawLine(210, 236, 210, 348);
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                dc.drawText(42, 195, Graphics.FONT_SYSTEM_XTINY, soc+"%", Graphics.TEXT_JUSTIFY_CENTER);
                dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
                dc.drawText(250, 45, Graphics.FONT_SYSTEM_TINY, pv+"kW", Graphics.TEXT_JUSTIFY_LEFT);
                dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
                dc.drawText(310, 165, Graphics.FONT_SYSTEM_TINY, grid+"kW", Graphics.TEXT_JUSTIFY_CENTER);
                dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
                dc.drawText(128, 165, Graphics.FONT_SYSTEM_TINY, batteryuse+"kW", Graphics.TEXT_JUSTIFY_CENTER);
                dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
                dc.drawText(250, 335, Graphics.FONT_SYSTEM_TINY, consumption+"kW", Graphics.TEXT_JUSTIFY_LEFT);
            } else if (System.getDeviceSettings().screenHeight == 454) {
                dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_TRANSPARENT);
                var barheight = (soc.toFloat() / 100.0 * (252 - 173)).toNumber();
                dc.fillRectangle(17, 190+((252-173)-barheight), 48, barheight);
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                dc.drawLine(75, System.getDeviceSettings().screenHeight/2, 200, System.getDeviceSettings().screenHeight/2);
                dc.drawLine(254, System.getDeviceSettings().screenHeight/2, 380, System.getDeviceSettings().screenHeight/2);
                dc.drawLine(System.getDeviceSettings().screenWidth/2, 63, System.getDeviceSettings().screenWidth/2, 200);
                dc.drawLine(System.getDeviceSettings().screenWidth/2, 252, System.getDeviceSettings().screenWidth/2, 395);
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                dc.drawText(42, 206, Graphics.FONT_SYSTEM_XTINY, soc+"%", Graphics.TEXT_JUSTIFY_CENTER);
                dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
                dc.drawText(255, 45, Graphics.FONT_SYSTEM_TINY, pv+"kW", Graphics.TEXT_JUSTIFY_LEFT);
                dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
                dc.drawText(320, 175, Graphics.FONT_SYSTEM_TINY, grid+"kW", Graphics.TEXT_JUSTIFY_CENTER);
                dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
                dc.drawText(140, 175, Graphics.FONT_SYSTEM_TINY, batteryuse+"kW", Graphics.TEXT_JUSTIFY_CENTER);
                dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
                dc.drawText(255, 360, Graphics.FONT_SYSTEM_TINY, consumption+"kW", Graphics.TEXT_JUSTIFY_LEFT);
            }
        }
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        sd = SolarData.getSolarData();
        refreshTimer = new Timer.Timer();
        refreshTimer.start(method(:timerCallback), 10000, true);
        System.println("Timer started");

    }

    function timerCallback() as Void{
        sd.requestUpdate();
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        System.println("Timer stopping");
        if (refreshTimer != null) {
            refreshTimer.stop();
        }
    }

}
