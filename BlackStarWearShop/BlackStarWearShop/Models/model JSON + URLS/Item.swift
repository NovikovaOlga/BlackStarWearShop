import Foundation

struct Item: Codable {
    
    let name: String
    let price: Int
    let mainImage: String
    var backupImageData: Data? = nil // фото товара для иконки в корзину
    let description: String
    let images: [String] // массив фото
    var backup: [Data]? = nil // массив с фото товара
    var offers: [Offer]
    
    struct Offer: Codable {
        let size: String
        let quantity: Int
        let color: String
    }
}
