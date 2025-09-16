pragma Singleton

import Quickshell
import QtQuick

import "../config"

// NOTE: using caelestia's code for now

Singleton {
    id: root

    property string loc
    property string icon
    property string description
    property string tempC: "idk"
    property string tempF: "idk"

    property bool loading: false

    function reload(): void {
        if (Config.saved.weatherLocation)
            loc = Config.saved.weatherLocation;
        if (!loc || timer.elapsed() > 900) {
            Requests.get("https://ipinfo.io/json", text => {
                loc = JSON.parse(text).loc ?? "";
                timer.restart();
            });
        }
    }

    onLocChanged: refreshWeather()

    function refreshWeather() {
        loading = true;
        Requests.get(`https://wttr.in/${loc}?format=j1`, text => {
            loading = false;
            const json = JSON.parse(text).current_condition[0];
            icon = getWeatherIcon(json.weatherCode);
            description = json.weatherDesc[0].value;
            tempC = `${parseFloat(json.temp_C)}°C`;
            tempF = `${parseFloat(json.temp_F)}°F`;
        });
    }

    Component.onCompleted: {
        reload();
        refreshWeather();
    }

    readonly property var weatherIcons: ({
            "113": "clear_day",
            "116": "partly_cloudy_day",
            "119": "cloud",
            "122": "cloud",
            "143": "foggy",
            "176": "rainy",
            "179": "rainy",
            "182": "rainy",
            "185": "rainy",
            "200": "thunderstorm",
            "227": "cloudy_snowing",
            "230": "snowing_heavy",
            "248": "foggy",
            "260": "foggy",
            "263": "rainy",
            "266": "rainy",
            "281": "rainy",
            "284": "rainy",
            "293": "rainy",
            "296": "rainy",
            "299": "rainy",
            "302": "weather_hail",
            "305": "rainy",
            "308": "weather_hail",
            "311": "rainy",
            "314": "rainy",
            "317": "rainy",
            "320": "cloudy_snowing",
            "323": "cloudy_snowing",
            "326": "cloudy_snowing",
            "329": "snowing_heavy",
            "332": "snowing_heavy",
            "335": "snowing",
            "338": "snowing_heavy",
            "350": "rainy",
            "353": "rainy",
            "356": "rainy",
            "359": "weather_hail",
            "362": "rainy",
            "365": "rainy",
            "368": "cloudy_snowing",
            "371": "snowing",
            "374": "rainy",
            "377": "rainy",
            "386": "thunderstorm",
            "389": "thunderstorm",
            "392": "thunderstorm",
            "395": "snowing"
        })

    function getWeatherIcon(code: string): string {
        if (weatherIcons.hasOwnProperty(code))
            return weatherIcons[code];
        return "air";
    }

    ElapsedTimer {
        id: timer
    }
}
