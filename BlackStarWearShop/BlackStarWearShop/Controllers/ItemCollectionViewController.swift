
import UIKit

class ItemCollectionViewController: UICollectionViewController {
  
    var itemID = 0
    var items = [Item]()
    
    var cartProducts: [CartProduct] = [] // для количества вещей в корзине в таббаре - шарим сюда
    var wishLists: [WishList] = [] // для количества вещей в вишлисте в таббаре - шарим сюда
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        TabBarUpdate.shared.getTotalQuantityCartProduct(tabBarController: tabBarController)
        TabBarUpdate.shared.getTotalQuantityWishList(tabBarController: tabBarController)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if items.isEmpty {
            ItemFetcher.fetch(URLS.urlItem(id: "\(itemID)")) { [weak self] in
                self?.items = $0
                self?.collectionView.reloadData()
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath)
        if let itemCell = cell as? ItemCollectionViewCell {
                itemCell.price = items[indexPath.row].price
                itemCell.name = items[indexPath.row].name
            itemCell.fetch(URLS.urlGeneralIcon(iconName: items[indexPath.row].mainImage), backupData: items[indexPath.row].backupImageData) { [weak self] (data, url) in
                self?.items[indexPath.row].backupImageData = data
            }
            return itemCell
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemBox",
           let destination = segue.destination as? ItemBoxViewController,
           let cell = sender as? ItemCollectionViewCell,
           let indexPath = collectionView.indexPath(for: cell) {
            let selectedItem = items[indexPath.row]
            destination.item = selectedItem
            destination.boxItems = items.filter { $0.name == selectedItem.name}
        }
    }
}
