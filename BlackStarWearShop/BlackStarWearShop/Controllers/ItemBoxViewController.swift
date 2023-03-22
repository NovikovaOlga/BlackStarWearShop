
import UIKit

class ItemBoxViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    var item: Item!
    var boxItems = [Item]() /// структура вещи (внутри массив с фото вещи)
    
    var cartProducts: [CartProduct] = []
    var wishLists: [WishList] = []
    
    var itemCartProduct = CartProduct() /// вещь, которую проверяем на уникальность
    
    var total = String() /// иконка корзины наверху (сюда будем грузить данные: TabBarUpdate.shared.cartTotalIconBox()
    
    private var sizeVC: SizeViewController? /// контроллер выбора размера
    private let tableViewHeight: CGFloat = 300.0
    
    /// БЛОК 1: коллекция фото вещи
    @IBOutlet weak var collectionView: UICollectionView! /// галерея фото товара
    @IBOutlet weak var pageControl: UIPageControl! { didSet { /// перелистывание (функция ниже листает)
        pageControl.numberOfPages = item.images.count
    }}
    @IBAction func back(_ sender: UIButton) { /// назад к товарам категории
        dismiss(animated: true)
    }
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint! /// высота картинки
    
    /// БЛОК 2: скрол данных о вещи (перекрывается контейнером с размерами при нажатии на кнопку купить)
    @IBOutlet weak var scrollView: UIScrollView! /// скролл (вложены: наименование, стоимость,
    @IBOutlet weak var nameItem: UILabel! /// наименование вещи
    @IBOutlet weak var priceItem: UILabel! /// стоимость вещи
    
    @IBOutlet weak var addToCart: UIButton! { didSet {
        addToCart.backgroundColor = blue_d0021b
        addToCart.layer.cornerRadius = 4
        addToCart.layer.masksToBounds = true
    }}
    
    @IBAction func addToCartButton(_ sender: Any) { /// сега sizeChoiser
        containerView.isHidden = false
        containerView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: tableViewHeight)
        background.backgroundColor = #colorLiteral(red: 0.8316103232, green: 0.8316103232, blue: 0.8316103232, alpha: 0.6971973141) /// background.alpha = 0.8
        background.isUserInteractionEnabled = true /// Если установлено значение true, события touch, press, keyboard и focus доставляются в представление в обычном режиме.
        SizeScreenAnimator.screenUp(containerView, by: tableViewHeight)
    }
    @IBOutlet weak var itemDescription: UILabel! /// описание вещи
    @IBOutlet var intervals: [NSLayoutConstraint]! /// расстояния до верха элеметов в скролле (наименование вещи, стоимость, кнопка купить, описание вещи)
    @IBOutlet var outlets: [UIView]! /// высоты элементов (наименование вещи, стоимость, кнопка купить, описание вещи)
    @IBOutlet weak var cartView: UIView!  /// { didSet { // иконка корзины
 
    @IBAction func cartButton(_ sender: UIButton) { /// сега cartVC
    }
    
    @IBOutlet weak var cartCounterLabel: UILabel! { didSet { /// количество вещей
        cartCounterLabel.backgroundColor = pink_f63c68
        cartCounterLabel.layer.cornerRadius = cartCounterLabel.bounds.width/2
        cartCounterLabel.layer.masksToBounds = true  /// без этого не закругляются углы кнопки когда label
    }}
    
    /// БЛОК 3: таблица с размерами - перекрывает скролл
    @IBOutlet weak var containerView: UIView! /// контейнер с таблицей выбора размеров
    
    /// БЛОК 4: бэкграунд (затемняет фон при выборе размера)
    @IBOutlet weak var background: UIView! { didSet { /// цвет фона (затемнение при выборе размера)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissTable(_:)))
        background.addGestureRecognizer(tap)
    }}
    
    /// БЛОК 5: анимация большое сердечко при выборе вещи
    @IBOutlet weak var heartBigImage: UIImageView! { didSet {  /// контур
        let newheartBigImage = heartBigImage.image?.withRenderingMode(.alwaysTemplate)
        heartBigImage.image = newheartBigImage
        heartBigImage.tintColor = .white
    }}
    @IBOutlet weak var heartFullBigImage: UIImageView! { didSet {  /// фигура
        let newheartFullBigImage = heartFullBigImage.image?.withRenderingMode(.alwaysTemplate)
        heartFullBigImage.image = newheartFullBigImage
        heartFullBigImage.tintColor = .white
    }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heartBigImage.alpha = 0
        heartFullBigImage.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateItem() /// загрузка данных по вещи (название, стоимость и описание)
        
        total = TabBarUpdate.shared.cartTotalIconBox()
        cartCounterLabel.text = total ///количество товара в корзине
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: view.bounds.width, height: totalHeight + 20)
    }
    
    private var totalHeight: CGFloat { /// итоговая высота скролла
        return intervals.reduce(0, {$0 + $1.constant}) + outlets.reduce(0, {$0 + $1.bounds.size.height}) /// reduce - Возвращает результат объединения элементов последовательности с помощью заданного замыкания
    }
    
    private func imageSize(_ cell: ItemBoxCollectionViewCell) { /// размер фото товара
        let size = cell.imageView.image!.size.width/(cell.imageView.image!.size.height * 0.8)  // ширину / высоту
        imageHeightConstraint.constant = view.bounds.width/size  /// лэйауту высоты установим новую высоту
        collectionView.collectionViewLayout.invalidateLayout() /// invalidateLayout - Делает недействительным текущий макет и запускает обновление макета.
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { /// размер ячейки указанного элемента
        return CGSize(width: view.bounds.width, height: imageHeightConstraint.constant)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x)/Int(scrollView.bounds.width)
        pageControl.currentPage = page /// currentPage - Текущая страница, показанная приемником в виде точки.
    }
    
    private func updateTableView() { /// обновить таблицу размера
        background.backgroundColor = .clear
        background.isUserInteractionEnabled = false /// При установке значения false события touch, press, keyboard и focus, предназначенные для представления, игнорируются и удаляются из очереди событий.
        sizeVC?.tableView.reloadData()
    }
}

extension ItemBoxViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { /// количество фото
        return item.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemBox", for: indexPath)
        if let itemBoxCell = cell as? ItemBoxCollectionViewCell {
            if item.images[indexPath.row].isEmpty {
                itemBoxCell.imageView.image = UIImage(named: "placeholder")
                imageSize(itemBoxCell)
            } else {
                itemBoxCell.fetch(URLS.urlGeneralIcon(iconName: item.images[indexPath.row]), backupData: item.backup?[indexPath.row]) { [weak self] (data, url) in
                    self?.item.backup?[indexPath.row] = data
                    self?.imageSize(itemBoxCell)
                }
            }
            return itemBoxCell
        }
        return cell
    }
}

extension ItemBoxViewController: ItemChooserCartDelegate {
    
    func itemChooserCart(color: String, size: String) {
        
        SizeScreenAnimator.screenDown(containerView, by: tableViewHeight) { [unowned self] in
            self.updateTableView()
            CartViewAnimator.animate(self.cartView)
            let img = item.backupImageData ?? Data()
            
            let newName = item.name
            let newColor = color
            let newSize = size
            let newPrice = String(item.price)
            
            cartProducts = CoreDataManager.shared.fetchCartProduct().reversed()
            
            if cartProducts.count != 0 { /// если в корзине уже есть вещи, то будем проверять совпадения и добавлять +1
                for item in cartProducts {
                    if let nameTemp = item.value(forKey: "name") as? String, nameTemp == newName,
                       let sizeTemp = item.value(forKey: "size") as? String, sizeTemp == newSize,
                       let colorTemp = item.value(forKey: "color") as? String, colorTemp == newColor,
                       let quantity = item.value(forKey: "quantity") as? String,
                       var quantityTemp = Int(quantity) {
                        quantityTemp += 1
                        item.setValue("\(quantityTemp)", forKey: "quantity")
                        CoreDataManager.shared.changeToCoreDate(color: color, image: img, name: newName, price: newPrice, size: size, quantity: "\(quantityTemp)")
                        total = TabBarUpdate.shared.cartTotalIconBox()
                        cartCounterLabel.text = total
                        return
                    }
                }
            }
            CoreDataManager.shared.saveProductCart(item: item, size: size, color: color, image: img, quantity: "1") /// если корзина пустая то ничего не проверяем
            total = TabBarUpdate.shared.cartTotalIconBox()
            cartCounterLabel.text = total
            return
        }
    }
}

extension ItemBoxViewController: ItemChooserWishListDelegate {
    
    func itemChooserWishList(color: String, size: String) {
        
        SizeScreenAnimator.screenDown(containerView, by: tableViewHeight) { [unowned self] in
            self.updateTableView()
            let img = item.backupImageData ?? Data()
            
            let newName = item.name
            let newColor = color
            let newSize = size
            
            wishLists = CoreDataManager.shared.fetchWishList().reversed()
          
            if wishLists.count != 0 {
                for item in wishLists {
                    if let nameTemp = item.value(forKey: "name") as? String, nameTemp == newName,
                       let colorTemp = item.value(forKey: "color") as? String, colorTemp == newColor,
                       let sizeTemp = item.value(forKey: "size") as? String, sizeTemp == newSize {
                        
                        let alert = UIAlertController(title: "Данная вещь уже добавлена в лист желаний ранее.", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Отлично!", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        return
                    }
                }
            }
            CoreDataManager.shared.saveProductWishList(item: item, size: size, color: color, image: img)
            BigHeartAnimator.bigHeartLive(heart: heartBigImage, heartFull: heartFullBigImage) 
        return
        }
    }
}

extension ItemBoxViewController {
    fileprivate func updateItem() { /// установка значений при загрузке
        nameItem.text = item.name /// название вещи
        priceItem.text = String(item.price) /// цена
        itemDescription.text = item.description /// описание
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { /// сега к размерам
        if segue.identifier == "sizeChooser", let destination = segue.destination as? SizeViewController {
            destination.delegateCart = self
            destination.delegateWishList = self
            destination.items = boxItems
            self.sizeVC = destination
        }
        
        if segue.identifier == "cartVC", let destination = segue.destination as? CartViewController {
            destination.dismissOutletStatus = false
        }
    }
    
    @objc fileprivate func dismissTable(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            SizeScreenAnimator.screenDown(containerView, by: tableViewHeight) { [unowned self] in
                self.updateTableView()
            }
        }
    }
}
