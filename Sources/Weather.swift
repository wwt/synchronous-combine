import Foundation

public struct Weather {
    public let date: String
    public let minTemp: Double
    public let maxTemp: Double
    public let currentTemp: Double
}

extension Weather: Decodable {
    enum CodingKeys: String, CodingKey {
        case date = "applicable_date"
        case minTemp = "min_temp"
        case maxTemp = "max_temp"
        case currentTemp = "the_temp"
    }
}
