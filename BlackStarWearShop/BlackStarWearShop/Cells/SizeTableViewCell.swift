
import UIKit

class SizeTableViewCell: UITableViewCell {
    
    var pressCart: (() -> Void)?
    
    var pressHeart: (() -> Void)?
    
    var color = "" { didSet {
        colorItem.text = color
    }}
    
    var size = "" { didSet {
        sizeItem.text = size
    }}
    
    @IBOutlet private(set) weak var colorItem: UILabel! // цвет - надпись
    @IBOutlet private(set) weak var sizeItem: UILabel! // размер - надпись
    @IBOutlet weak var doneImage: UIImageView! // галочка
    
    @IBOutlet weak var heartImage: UIImageView! { didSet {
        IconAnimator.iconStart(icon: heartImage) // установим стартовый цвет
    }}
    
    @IBOutlet weak var cartImage: UIImageView! { didSet {
        IconAnimator.iconStart(icon: cartImage) // установим стартовый цвет
    }}
    
    @IBAction func cartButton(_ sender: UIButton) { // сохраняем в корзину
        IconAnimator.iconShow(icon: cartImage, color: green_11b31d)
        pressCart?()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in // отсрочка screenDown в SizeViewController 0.5
            IconAnimator.iconStart(icon: cartImage)
        }
    }
    
    @IBAction func heartButton(_ sender: UIButton) { // сохраняем в вишлист
        
        IconAnimator.iconShow(icon: heartImage, color: green_11b31d)
        pressHeart?()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in // отсрочка screenDown в SizeViewController 0.5
            IconAnimator.iconStart(icon: heartImage)
        }
    }
}
