
import UIKit

class TabBarUpdate { /// обновляем иконки таббар и количество в корзине
    
    static let shared = TabBarUpdate()
    
    var cartProducts: [CartProduct] = [] /// для количества вещей в корзине в таббаре - шарим сюда
    var wishLists: [WishList] = [] /// для количества вещей в вишлисте в таббаре - шарим сюда
    
    func getTotalQuantityCartProduct(tabBarController: UITabBarController?) { /// таббар корзины
        cartProducts = CoreDataManager.shared.fetchCartProduct().reversed()
        tabBarController?.tabBar.items?[2].badgeValue = "\(getTotalQuantity())" /// количество в иконке таббара
    }
   
    func getTotalQuantityWishList(tabBarController: UITabBarController?) { /// таббар листа желаний
        wishLists = CoreDataManager.shared.fetchWishList().reversed()
        tabBarController?.tabBar.items?[3].badgeValue = String(wishLists.count) /// количество в иконке таббара
    }
    
    func cartTotalIconBox() -> String {
        cartProducts = CoreDataManager.shared.fetchCartProduct().reversed()
        return String(getTotalQuantity())
    }

    private func getTotalQuantity() -> Int { /// количество вещей в корзине (getTotalQuantityCartProduct)
        var totalQuantity: Int = 0
        for product in cartProducts {
            if let quantity = Int(product.quantity ?? "0") {
                totalQuantity += quantity
            }
        }
        return totalQuantity
    }
}
