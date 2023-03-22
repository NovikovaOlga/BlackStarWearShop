
import Foundation

class CategoryFetcher {
    static func fetch(_ completion: @escaping ( ([Category]) -> Void)) {
        if let url = URLS.urlCategory() {
            DispatchQueue.global(qos: .userInitiated).async { // notes 1
                let session = URLSession(configuration: .default)
                let request = URLRequest(url: url)
                let task = session.dataTask(with: request) { (data, response, error) in
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                        if let dict = json as? [String: Any] {
                            CategoryParser.parse(dict) { (categories) in
                                DispatchQueue.main.async {
                                    completion(categories)
                                }
                            }
                        }
                    }
                }
                task.resume()
            }
        }
    }
}
