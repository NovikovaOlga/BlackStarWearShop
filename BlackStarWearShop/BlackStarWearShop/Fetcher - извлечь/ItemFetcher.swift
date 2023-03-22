
import Foundation

class ItemFetcher {  
    static func fetch(_ url:URL?,completion: @escaping ([Item]) -> Void ) {
        if let url = url {
            DispatchQueue.global(qos: .userInitiated).async {
                let session = URLSession(configuration: .default)
                let request = URLRequest(url: url)
                let task = session.dataTask(with: request) { (data, responce, error) in
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                        if let items = json as? [String:Any] {
                            ItemParser.parse(items) { (items) in
                                DispatchQueue.main.async {
                                    completion(items)
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
