import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class SolarStatusApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when the application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of the application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new SolarStatusView() ];
    }

    (:glance)
    function getGlanceView() {
        return [ new SolarStatusGlanceView() ];
    }
}

function getApp() as SolarStatusApp {
    return Application.getApp() as SolarStatusApp;
}