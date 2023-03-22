
import UIKit

class WishListViewController: UIViewController {
    
    var wishLists: [WishList] = []
    var cartProducts: [CartProduct] = [] // для количества вещей в корзине в таббаре - шарим сюда
    
    @IBOutlet weak var tabBarItemWishList: UITabBarItem!
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var noHeartBigImage: UIImageView! { didSet {
        let newnoHeartBigImage = noHeartBigImage.image?.withRenderingMode(.alwaysTemplate)
        noHeartBigImage.image = newnoHeartBigImage
        noHeartBigImage.tintColor = .darkGray
    }}
    
    @IBOutlet weak var toCartBigImage: UIImageView! { didSet {
        let newtoCartBigImage = toCartBigImage.image?.withRenderingMode(.alwaysTemplate)
        toCartBigImage.image = newtoCartBigImage
        toCartBigImage.tintColor = .darkGray
    }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noHeartBigImage.alpha = 0
        toCartBigImage.alpha = 0
        
        table.allowsSelection = false // нельзя выбрать строку (подсветить)
        table.delegate = self // так как не протянули в storyboard к контроллеру связи delegate и dataSource (альтернативный вариант)
        table.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) { 
        super.viewWillAppear(animated)
        
        wishLists = CoreDataManager.shared.fetchWishList().reversed()
        cartProducts = CoreDataManager.shared.fetchCartProduct().reversed()
        table.reloadData() 
    }
}

// MARK: работа с таблицей
extension WishListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        wishLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table.dequeueReusableCell(withIdentifier: "wishListCell", for: indexPath) as! WishListViewControllerCell
        let wishList = wishLists[indexPath.row]
        cell.name.text = wishList.name
        cell.color.text = wishList.color
        cell.size.text = wishList.size
        cell.price.text = wishList.price
        
        if let image = wishList.imageData {
            cell.imageData.image = UIImage(data: image)
        }
        
        cell.pressNoHeart = { [unowned self] in // отслеживаем нажатие в ячейке на несердечко - удалить из вишлиста
            trashButtonTapped(index: indexPath)
            BigIconAnimator.bigIconLive(icon: noHeartBigImage)
        }
        
        cell.pressToCart = { [unowned self] in // отслеживаем нажатие на перемещение в корзину
            
            let nameWishList = cell.name.text
            let colorWishList = cell.color.text
            let sizeWishList = cell.size.text
            let priceWishList = cell.price.text
            let imageWishList = cell.imageData.image
            
            if cartProducts.count != 0 { /// если в корзине уже ест вещи, то будем проверять совпадения и добавлять +1
                for item in cartProducts {
                    if let nameCart = item.value(forKey: "name") as? String, nameCart == cell.name.text,
                       let sizeCart = item.value(forKey: "size") as? String, sizeCart == cell.size.text,
                       let colorCart = item.value(forKey: "color") as? String, colorCart == cell.color.text,
                       let quantity = item.value(forKey: "quantity") as? String,
                       var quantityTemp = Int(quantity) {
                        quantityTemp += 1
                        item.setValue("\(quantityTemp)", forKey: "quantity")
                        CoreDataManager.shared.changeToCoreDatePlusMinus(color: colorWishList!, image: imageWishList!, name: nameWishList!, price: priceWishList!, size: sizeWishList!, quantity: "\(quantityTemp)")
                        
                        trashButtonTapped(index: indexPath)
                        
                        let alert = UIAlertController(title: "Данная вещь уже добавлена в корзину ранее.", message: "Для вашего удобства мы добавили одну единицу указанного товара в корзину.", preferredStyle: .alert)
                         
                        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        
                        return
                    }
                }
            }
            
            CoreDataManager.shared.saveProductToCart(name: wishList.name!, size: wishList.size!, color: wishList.color!, image: wishList.imageData!, price: wishList.price!, quantity: "1")
            trashButtonTapped(index: indexPath)
            tabBarController?.tabBar.items?[2].badgeValue = "\(getTotalQuantity())" // количество в иконке таббара
            BigIconAnimator.bigIconLive(icon: toCartBigImage)
            
            print("новая вещь")
            return
        }
        TabBarUpdate.shared.getTotalQuantityCartProduct(tabBarController: tabBarController)
        TabBarUpdate.shared.getTotalQuantityWishList(tabBarController: tabBarController)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) { // удаление строки жестом
        
        if (editingStyle == .delete) {
            trashButtonTapped(index: indexPath)
        }
        tabBarItem.badgeValue = String(wishLists.count)
    }
    
    func trashButtonTapped(index: IndexPath?) { // удаление из вишлиста (самое действие)
        guard let index = index else { return }
        let  productToDelite = wishLists[index.row] // для удаления из самой базы
        CoreDataManager.shared.deleteWishList(product: productToDelite)
        reloadTableData(index: index)
    }
    
    func reloadTableData(index: IndexPath?)  { ///  обновление данных после изменения данных в таблице
        cartProducts = CoreDataManager.shared.fetchCartProduct().reversed()
        wishLists = CoreDataManager.shared.fetchWishList().reversed()
        table.reloadData()
        tabBarItem.badgeValue = String(wishLists.count) // количество в листе желаниybq
    
    }
    func getTotalQuantity() -> Int { /// количество вещей
        var totalQuantity: Int = 0
        for product in cartProducts {
            if let quantity = Int(product.quantity ?? "0") {
                totalQuantity += quantity
            }
        }
        return totalQuantity
    }
}
