
import Foundation

class ImageFetcher {
    static func fetch(_ url: URL?, completion: @escaping (Data, URL) -> Void ) {
        if let url = url {
            DispatchQueue.global(qos: .userInitiated).async {
                let session = URLSession(configuration: .default)
                let request = URLRequest(url: url)
                let task = session.dataTask(with: request) { (data, response, error) in
                    if let data = data {
                        DispatchQueue.main.async {
                            completion(data,url)
                        }
                    }
                }
                task.resume()
            }
        }
    }
}


