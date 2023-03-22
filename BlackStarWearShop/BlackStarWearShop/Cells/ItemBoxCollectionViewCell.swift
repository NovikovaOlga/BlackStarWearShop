
import UIKit

class ItemBoxCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!  {
        didSet {
            imageView.contentMode = .scaleAspectFill
        }
    }
    
    func fetch(_ url:URL?,backupData:Data?, competion: @escaping (Data,URL) -> Void) {
        if let imageData = backupData { // извлечем картинку
            imageView.image = UIImage(data: imageData)
        } else {
            ImageFetcher.fetch(url) { (data, foundURL) in
                if let image = UIImage(data: data), foundURL == url {
                    self.imageView.image = image
                    competion(data,foundURL)
                }
            }
        }
    }
}
