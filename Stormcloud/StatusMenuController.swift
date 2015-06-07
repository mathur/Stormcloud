import Foundation
import Cocoa

let DEFAULT_CITY = "New York, NY"

class StatusMenuController: NSObject, PreferencesWindowDelegate {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var weatherView: WeatherView!
    var weatherMenuItem: NSMenuItem!
    var preferencesWindow: PreferencesWindow!

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    let weatherAPI = WeatherAPI()

    override func awakeFromNib() {
        statusItem.menu = statusMenu

        weatherMenuItem = statusMenu.itemWithTitle("Weather")
        weatherMenuItem.view = weatherView

        preferencesWindow = PreferencesWindow()
        preferencesWindow.delegate = self

        updateWeather()
    }

    func updateWeather() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let city = defaults.stringForKey("city") ?? DEFAULT_CITY
        weatherAPI.fetchWeather(city) { weather in
            self.weatherView.update(weather)
            self.statusItem.title = "\(Int(weather.currentTemp)) °F"
        }
    }

    @IBAction func updateClicked(sender: NSMenuItem) {
        updateWeather()
    }

    @IBAction func preferencesClicked(sender: NSMenuItem) {
        preferencesWindow.showWindow(self)
    }

    func preferencesDidUpdate() {
        updateWeather()
    }

    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
}