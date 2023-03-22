
import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var buyLabel: UILabel! { didSet {
        buyLabel.backgroundColor = pink_f63c68
        buyLabel.layer.cornerRadius = 4
        buyLabel.layer.masksToBounds = true  // закругляем углы когда label
    }}

    var price = 0 { didSet {
        priceLabel.attributedText = NSMutableAttributedString(string: "\(price)")
    }}
    
    var name = "" { didSet {
        descriptionLabel.attributedText = NSMutableAttributedString(string: name)
    }}
    
    func fetch(_ url:URL?,backupData:Data?, competion: @escaping (Data,URL) -> Void) {
        if let imageData = backupData {
            itemImage.image = UIImage(data: imageData)
        } else {
            ImageFetcher.fetch(url) { (data, foundURL) in
                if let image = UIImage(data: data), foundURL == url {
                    self.itemImage.image = image
                    competion(data,foundURL)
                }
            }
        }
    }
}
