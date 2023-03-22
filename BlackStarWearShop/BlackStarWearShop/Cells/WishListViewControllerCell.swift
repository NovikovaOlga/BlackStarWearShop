
import UIKit

class WishListViewControllerCell: UITableViewCell {

    var pressToCart: (() -> Void)?  // отслеживаем нажатие кнопки в корзину

    var pressNoHeart: (() -> Void)? // отслеживаем нажатие кнопки - удалить из виш листа
    
    @IBOutlet weak var imageData: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var price: UILabel!
    
    
    
    @IBOutlet weak var toCartImage: UIImageView! { didSet {
        let newtoCartOutlet = toCartImage.image?.withRenderingMode(.alwaysTemplate)
        toCartImage.image = newtoCartOutlet
        toCartImage.tintColor = .lightGray
    }}
    
    @IBOutlet weak var noHeartImage: UIImageView! { didSet {
        let newnoHeartOutlet = noHeartImage.image?.withRenderingMode(.alwaysTemplate)
        noHeartImage.image = newnoHeartOutlet
        noHeartImage.tintColor = .lightGray
        
    }}
    
    @IBAction func toCartButton(_ sender: UIButton) {
        pressToCart?()
    }
    
    @IBAction func noHeartButton(_ sender: UIButton) {
        pressNoHeart?()
    }
}
