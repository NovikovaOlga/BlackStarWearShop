
import UIKit

class CartViewControllerCell: UITableViewCell {

    var pressDelete: (() -> Void)?  // отслеживаем нажатие кнопки удаления их корзины без делегата

    var pressHeart: (() -> Void)?  // в вишлист

    var pressUpTap: (() -> Void)? // уменьшить количество
    var pressDownTap: (() -> Void)? // увеличить количество

    @IBOutlet weak var imageData: UIImageView! 
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var color: UILabel! // не выводит данные цвета
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var quantity: UILabel! // количество
    
    @IBOutlet weak var upImage: UIImageView! { didSet {
        let newUpImage = upImage.image?.withRenderingMode(.alwaysTemplate)
        upImage.image = newUpImage
        upImage.tintColor = .lightGray
    }}
    
    @IBOutlet weak var downImage: UIImageView! { didSet {
        let newDownImage = downImage.image?.withRenderingMode(.alwaysTemplate)
        downImage.image = newDownImage
        downImage.tintColor = .lightGray
    }}
    
    @IBAction func minusTap(_ sender: UIButton) { // на одну вещь меньше
        pressUpTap?()
    }
    
    @IBAction func plusTap(_ sender: Any) { // на одну вещь больше
        pressDownTap?()
    }
    
    @IBOutlet weak var toWishList: UIImageView! { didSet {
        let newtoWishList = toWishList.image?.withRenderingMode(.alwaysTemplate)
        toWishList.image = newtoWishList
        toWishList.tintColor = .lightGray
    }}
    
    @IBOutlet weak var toDelete: UIImageView! { didSet {
        let newtoDelete = toDelete.image?.withRenderingMode(.alwaysTemplate)
        toDelete.image = newtoDelete
        toDelete.tintColor = .lightGray
    }}
    
    @IBAction func deleteButton(_ sender: UIButton) { // удаление строки
        pressDelete?()
    }
    
    @IBAction func heartButton(_ sender: UIButton) { // переместить в вишлист
        pressHeart?()
    }
}
    

