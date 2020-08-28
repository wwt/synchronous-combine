import Foundation

public struct WeatherResponse {
    public let weather: [Weather]
    public let title: String
    public let woeid: Int
}

extension WeatherResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case weather = "consolidated_weather"
        case title, woeid
    }
}
