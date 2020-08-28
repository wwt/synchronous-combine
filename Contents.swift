import Combine
import Foundation

struct ApiClient {
    func make<T: Decodable>(
        _ request: URLRequest,
        _ decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<T, Error> {
        URLSession.shared
            .dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct WeatherProvider {
    let apiClient: ApiClient
    private let base = URL(string: "https://www.metaweather.com/api/")!

    func woeid(
        latitude: Double,
        longitude: Double
    ) -> AnyPublisher<[Location], Error> {
        let url = base.appendingPathComponent("location/search/")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(
                name: "lattlong",
                value: "\(latitude),\(longitude)"
            )
        ]

        let request = URLRequest(url: components.url!)

        return apiClient.make(request)
    }
    
    func weather(woeid: Int) -> AnyPublisher<WeatherResponse, Error> {
        let request = URLRequest(url: base.appendingPathComponent("location/\(woeid)"))
        
        return apiClient.make(request)
    }
}

let weatherProvider = WeatherProvider(apiClient: ApiClient())
let woeidSubscriber = weatherProvider.woeid(latitude: 38.6255, longitude: -90.1861)

let firstLocation = woeidSubscriber.compactMap({ $0.first })

let weatherResponse = firstLocation.flatMap { location in
    weatherProvider.weather(woeid: location.woeid)
}

let cancellationToken = weatherResponse.sink(
    receiveCompletion: { _ in },
    receiveValue: { print($0.weather) }
)
