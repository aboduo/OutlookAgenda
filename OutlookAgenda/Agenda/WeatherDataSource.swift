import Foundation

enum WeatherType: String {
    case sunny, cloudy, windy, snow
    
    func weatherIco() -> String {
        return "weather_\(self.rawValue)"
    }
}

class WeatherDataSource {
    
    private static let allWeatherTypes: [WeatherType] = [.sunny, .cloudy, .windy, .snow]
    
    static func weather(at date: Date) -> WeatherType {
        let randomIndex = arc4random_uniform(UInt32(WeatherDataSource.allWeatherTypes.count))
        return WeatherDataSource.allWeatherTypes[Int(randomIndex)]
    }
}
