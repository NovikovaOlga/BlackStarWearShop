
import Foundation
import CoreData

extension CartProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartProduct> {
        return NSFetchRequest<CartProduct>(entityName: "CartProduct")
    }

    @NSManaged public var color: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var size: String?
    @NSManaged public var quantity: String?

}

extension CartProduct : Identifiable {

}
