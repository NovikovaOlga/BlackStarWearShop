
import Foundation

struct Category {
    
    let name: String
    let sortOrder: Int
    let iconImage: String // для других коллекций картинок в меню меняем CategoryFetcer: iconImage
    var copyIconImage: Data? = nil
    let subCategories: Set<SubCategory>
}

struct SubCategory: Hashable {
    let id: Int
    let iconImage: String
    var copyIconImage: Data? = nil
    let sortOrder: Int
    let name: String
}
