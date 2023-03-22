
import Foundation

class ItemParser {
    
    static func parse(_ json:[String:Any],completion: @escaping ( ([Item]) -> Void)) {
        var items = [Item]()
        json.forEach { (key,_) in
            if let dict = json[key] as? [String:Any],
               let name = dict["name"] as? String,
               let mainImage = dict["mainImage"] as? String,
               let price = dict["price"] as? String ,
               let doublePrice = Double(price),
               let description = dict["description"] as? String,
               let productImages = dict["productImages"] as? [[String:Any]],
               let offersJSON = dict["offers"] as? [[String:Any]],
               let color = dict["colorName"] as? String {
                var images = [String]()
                var offers = [Item.Offer]()
                offersJSON.forEach { (key) in
                    if let quantity = key["quantity"] as? String,
                       let size = key["size"] as? String {
                        offers.append(Item.Offer(size: size, quantity: Int(quantity)!, color: color))
                    }
                }
                if productImages.isEmpty {
                    images.append("")
                } else {
                    productImages.forEach { (key) in
                        if let imageURL = key["imageURL"] as? String {
                            images.append(imageURL)
                        }
                    }
                }
                items.append(Item(name: name, price: Int(doublePrice), mainImage: mainImage, description: description, images: images, offers: offers))     // description: description.noHTML,
            }
        }
        completion(items) // пустые категории женская Ханна
    }
}
