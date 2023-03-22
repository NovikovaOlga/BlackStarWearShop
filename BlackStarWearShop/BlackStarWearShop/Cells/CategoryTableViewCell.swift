// Здесь переиспользуемая ячейка категорий и подкатегорий (после комментария преподавателя 09.06.21). все ссылки на категории (category) переиспользуются и для подкатегорий.


import UIKit

protocol ReloadCellDelegate {
    func reloadCell(at index: IndexPath?)
}

class CategoryTableViewCell: UITableViewCell {
    
    var index: IndexPath?
    var delegate: ReloadCellDelegate?
    
    @IBOutlet weak var categoryImage: UIImageView!
    
    @IBOutlet weak var categoryLabel: UILabel!

    func configureCell(with object: Category) { // конфигурация ячейки категорий
        categoryLabel.text = object.name
    }
    
    func configureSubcategoryCell(with object: SubCategory) { // конфигурация ячейки подкатегорий
        categoryLabel.text = object.name
    }
    
    func fetchImage(_ url: URL?, backupData: Data?, completion: @escaping (Data, URL) -> Void) {
        
        if let imageData = backupData {
            categoryImage.image = UIImage(data: imageData)
        } else {
            ImageFetcher.fetch(url) { (data, foundURL) in
                if let image = UIImage(data: data), foundURL == url {
                    self.categoryImage.image = image
                    completion(data, foundURL)
                }
            }
        }
    }
}
