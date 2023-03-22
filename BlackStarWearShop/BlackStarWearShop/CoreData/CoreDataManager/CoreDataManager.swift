
import Foundation
import UIKit
import CoreData

class CoreDataManager { // менеджер и для корзины и для вишлиста
    
    static let shared = CoreDataManager()
    var cartCoreData: [NSManagedObject] = []
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    
    // MARK: - Core Data stack - вынесла из AppDelegate
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "BlackStarWearShop")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support - вынесла из AppDelegate
    private func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: извлечение
    func fetchCartProduct() -> [CartProduct] { //корзина
        
        let fetchRequest : NSFetchRequest<CartProduct> = CartProduct.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch let error {
            print(error)
            return []
        }
    }
    
    func fetchWishList() -> [WishList] { // вишлист
        
        let fetchRequest : NSFetchRequest<WishList> = WishList.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch let error {
            print(error)
            return []
        }
    }
    
    // MARK: - корректировка записи в базе - изменение количества (функции отличаются типом данных image - Data, UIImage)
    func changeToCoreDate (color: String, image: Data, name: String, price: String, size: String, quantity: String) {

        saveContext()
        do {
            try! context.save()
        }
    }
    
    func changeToCoreDatePlusMinus (color: String, image: UIImage, name: String, price: String, size: String, quantity: String) { 
        
        saveContext()
        do {
            try! context.save()
        }
    }
    
    // MARK: функии сохранения в корзину и вишлист из бокса выбора вещи
    func saveProductCart(item: Item, size: String, color: String, image: Data, quantity: String) { // в корзину
        
        guard let entity = NSEntityDescription.entity(forEntityName: "CartProduct", in: context) else {return}
     
        let cartProduct = CartProduct(entity: entity, insertInto: context)
    
        cartProduct.imageData = image
        cartProduct.name = item.name
        cartProduct.price = String(item.price)
        cartProduct.size = size
        cartProduct.color = color
        cartProduct.quantity = quantity

        saveContext()
    }
 
    func saveProductWishList(item: Item, size: String, color: String, image: Data) { // в вишлист
        guard let entity = NSEntityDescription.entity(forEntityName: "WishList", in: context) else {return}
        
        let wishList = WishList(entity: entity, insertInto: context)
        
        wishList.imageData = image//jpgCompression
        wishList.name = item.name
        wishList.price = String(item.price)
        wishList.size = size
        wishList.color = color
        
        saveContext()
    }
    
    // MARK: функии сохранения между корзиной и вишлистом туда сюда
    func saveProductToCart(name: String, size: String, color: String, image: Data, price: String, quantity: String) { //  quantity: String из вишлиста в корзину
        guard let entity = NSEntityDescription.entity(forEntityName: "CartProduct", in: context) else {return}
        
        let cartProduct = CartProduct(entity: entity, insertInto: context)
        
        cartProduct.imageData = image
        cartProduct.name = name
        cartProduct.price = String(price)
        cartProduct.size = size
        cartProduct.color = color
        cartProduct.quantity = quantity
        
        saveContext()
    }
    
    func saveProductToWishList(name: String, size: String, color: String, image: Data, price: String) { // из корзины в вишлист
        guard let entity = NSEntityDescription.entity(forEntityName: "WishList", in: context) else {return}
        
        let wishList = WishList(entity: entity, insertInto: context)
        
        wishList.imageData = image
        wishList.name = name
        wishList.price = String(price)
        wishList.size = size
        wishList.color = color
        
        saveContext()
    }
    
    // MARK: удаление
    func deleteCartProduct(product: CartProduct) {  // корзина - удалить строку
        context.delete(product)
        saveContext()
    }
    
    func deleteCartProductAll() { // корзина - удалить ВСЕ
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CartProduct")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try context.execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteWishList(product: WishList) { // вишлист - удалить строку
        context.delete(product)
        saveContext()
    }
}
