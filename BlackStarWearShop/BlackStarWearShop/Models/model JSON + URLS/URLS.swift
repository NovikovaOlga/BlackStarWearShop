
import Foundation

struct URLS {
    
    // загрузка первой страницы - категорий
    static func urlCategory() -> URL? {
        return URL(string: "https://blackstarshop.ru/index.php?route=api/v1/categories")
    }
    
    // загрузка картинок для категорий и подкатегорий
    static func urlGeneralIcon(iconName: String) -> URL? {
        return URL(string: "https://blackstarshop.ru/\(iconName)")
    }
    
    // загрузка содержимого подкатегории (список вещей)
    static func urlItem(id:String) -> URL? {
        return URL(string: "https://blackstarshop.ru/index.php?route=api/v1/products&cat_id=\(id)")
    }
}



//let urlCategoryImage = "https://blackstarshop.ru/" // для парсинга картинки нужен составной адрес + iconImage

