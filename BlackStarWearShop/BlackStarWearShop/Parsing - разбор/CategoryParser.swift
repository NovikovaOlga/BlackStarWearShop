
import Foundation

class CategoryParser {
    
    static func parse(_ json:[String: Any], completion: @escaping ( ([Category]) -> Void)) {
        var categories = [Category] ()
        json.forEach { (key, _) in
            if let category = json[key] as? [String: Any] {
                if let name = category["name"] as? String,
                   let sortOrder = category["sortOrder"] as? String,
                   let order = Int(sortOrder),
                   let iconImage = category["iconImage"] as? String, // другие коллекции картинок: image, iconImageActive, iconImage
                   let subcategories = category["subcategories"] as? [[String: Any]] { 
                    var sCategories = Set<SubCategory>()
                    subcategories.forEach {
                        let dict = $0
                        dict.forEach { subKey,subValue in
                            if let id = dict["id"] as? String,
                               let iconImage = dict["iconImage"] as? String,
                               let sortOrder = dict["sortOrder"] as? String,
                               let name = dict["name"] as? String {
                                sCategories.insert(SubCategory(id: Int(id)!, iconImage: iconImage, sortOrder: Int(sortOrder)!, name: name))
                            }
                        }
                    }
                    categories.append(Category(name: name, sortOrder: order,  iconImage: iconImage, subCategories: sCategories))
                }
            }
        }
        completion(categories.sorted(by: { $0.sortOrder < $1.sortOrder}) // сортируем по возрастанию
                    .filter { $0.subCategories.count > 0}) // есть пустые категории
    }
}
