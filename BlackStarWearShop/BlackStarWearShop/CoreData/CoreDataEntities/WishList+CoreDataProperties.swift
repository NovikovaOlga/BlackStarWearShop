
import Foundation
import CoreData

extension WishList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WishList> {
        return NSFetchRequest<WishList>(entityName: "WishList")
    }

    @NSManaged public var color: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var size: String?

}

extension WishList : Identifiable {

}
