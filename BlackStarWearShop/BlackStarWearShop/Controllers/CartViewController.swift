
import UIKit

class CartViewController: UIViewController {
    
    //  var item: Item!
    
    var dismissOutletStatus: Bool = true /// отображаем кнопку "закрыть" если переход от контроллера вещи в магазине, если переход из tabBar кнопки, то кнопку не отображаем, так как пользователь при нажатии в этом случае попадет на логин контроллер со львенком
    
    var cartProducts: [CartProduct] = []
    var wishLists: [WishList] = [] /// для количества вещей в вишлисте в таббаре - шарим сюда
    
    var indexPathDelete = IndexPath(row: 0, section: 0)
    
    var sumTotal: Int = 0 /// здесь тотал покупок
    var moneyStat = Money.shared.userMoney /// здесь сумма денег юзера
    
    @IBOutlet var controllerView: UIView! /// вью всего контроллера
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var blockPromoPriceView: UIView! /// блок для смещения вверх при появлении клавиатуры
    
    @IBOutlet weak var totalPrice: UILabel! /// итого
    @IBOutlet weak var totalPricePromo: UILabel! /// итого с учетом промокода (один из двух - в константах)
    @IBOutlet weak var promo: UITextField! /// поле ввода промокода
    @IBOutlet weak var promoButtonLabel: UIButton! { didSet {
        promoButtonLabel.backgroundColor = blue_d0021b
        promoButtonLabel.layer.cornerRadius = 4
        promoButtonLabel.layer.masksToBounds = true
    }}
    
    @IBAction func promoButton(_ sender: UIButton) { /// расчет скидки по промокоду
        promoPriceCalculation()
        promo.resignFirstResponder()
    }
    
    @IBOutlet weak var buyButtonLabel: UIButton! { didSet {
        buyButtonLabel.backgroundColor = blue_d0021b
        buyButtonLabel.layer.cornerRadius = 4
        buyButtonLabel.layer.masksToBounds = true
    }}
    
    @IBAction func buyButton(_ sender: UIButton) { ///   оформить заказ
        promoPriceCalculationBuy() /// запишем сумму с промокодом в переменную
        moneyStat = Money.shared.userMoney // обновим
        if moneyStat >= sumTotal  { /// денег хватает
            
            trashButtonAll() /// удалим и обновим
            
            /// следующие 5 строк можно собрать в функцию (такие же в дидапир)
            tabBarItem.badgeValue = String(cartProducts.count)
            table.reloadData()
            totalPrice.text = "\(Int(getTotalPrice())) руб." // ₽ - при выборе товаров, а руб. уже в корзине - так в фигме
            totalPricePromo.text = "\(Int(getTotalPrice())) руб."
            promo.text = ""
            
            let successAlert = UIAlertController(title: "Состояние транзакции:", message: "Оплата совершена успешно", preferredStyle: .alert)
            successAlert.addAction(UIAlertAction(title: "Отлично", style: .default))
            present(successAlert, animated: true)
            print("sumTotal \(sumTotal), moneyStat \(moneyStat)")
            
            Money.shared.userMoney = moneyStat - sumTotal
            moneyStat = Money.shared.userMoney
        } else { // денег не хватает
            let errorAlert = UIAlertController(title: "Состояние транзакции:", message: "Недостаточно средств на счете", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "Жаль", style: .default))
            present(errorAlert, animated: true)
            print("sumTotal \(sumTotal), moneyStat \(moneyStat)")
        }
    }
    
    @IBOutlet weak var table: UITableView!
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBOutlet weak var tabbarItem: UITabBarItem!
    @IBOutlet weak var dismissOutlet: UIButton!
    @IBOutlet weak var background: UIView!
    
    @IBAction func yesButton(_ sender: Any) { /// ДА - удалить действие
        trashButtonTapped(index: indexPathDelete)
        invisibleWindow(status: true)
        BigIconAnimator.bigIconLive(icon: trashBinBigImage)
        TabBarUpdate.shared.getTotalQuantityCartProduct(tabBarController: tabBarController)
        TabBarUpdate.shared.getTotalQuantityWishList(tabBarController: tabBarController)
    }
    
    @IBAction func noButton(_ sender: Any) { /// НЕТ - отменить действие
        invisibleWindow(status: true)
    }
    
    @IBOutlet weak var deleteView: UIView! /// окно подтверждения удаления
    @IBOutlet weak var yesButtonLabel: UIButton! { didSet { // ДА - удалить надпись
        yesButtonLabel.backgroundColor = blue_d0021b
        yesButtonLabel.layer.cornerRadius = 4
        yesButtonLabel.layer.masksToBounds = true
    }}
    
    @IBOutlet weak var noButtonLabel: UIButton! /// НЕТ - удалить надпись
    @IBOutlet weak var deleteViewLabel: UILabel! /// окно подтверждения удаления надпись
    
    @IBOutlet weak var heartBigImage: UIImageView! { didSet {
        let newheartBigImage = heartBigImage.image?.withRenderingMode(.alwaysTemplate)
        heartBigImage.image = newheartBigImage
        heartBigImage.tintColor = .darkGray
    }}
    
    @IBOutlet weak var trashBinBigImage: UIImageView! { didSet {
        let newtrashBinBigImage = trashBinBigImage.image?.withRenderingMode(.alwaysTemplate)
        trashBinBigImage.image = newtrashBinBigImage
        trashBinBigImage.tintColor = .darkGray
    }}
    
    func invisibleWindow(status: Bool) { /// окно удаления - переключатель элементов (добавить анимацию)
        if status == true {
            background.backgroundColor = .clear
            ///    background.isUserInteractionEnabled = true // Если установлено значение true, события touch, press, keyboard и focus доставляются в представление в обычном режиме.
            deleteView.isHidden = true
            deleteViewLabel.isHidden = true
            yesButtonLabel.isHidden = true
            noButtonLabel.isHidden = true
        } else if status == false { // видимое
            background.backgroundColor = #colorLiteral(red: 0.8316103232, green: 0.8316103232, blue: 0.8316103232, alpha: 0.6971973141) /// background.alpha = 0.8
            ///    background.isUserInteractionEnabled = false // Если установлено значение false, события касания, нажатия, клавиатуры и фокусировки, предназначенные для представления, игнорируются и удаляются из очереди событий.
            deleteView.isHidden = false
            deleteViewLabel.isHidden = false
            yesButtonLabel.isHidden = false
            noButtonLabel.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        promo.clearButtonMode = .always // Всегда показывать кнопку очистки
        heartBigImage.alpha = 0
        trashBinBigImage.alpha = 0
        
        table.allowsSelection = false /// нельзя выбрать строку (подсветить)
        table.delegate = self
        table.dataSource = self
        invisibleWindow(status: true)
        dismissOutlet.isHidden = dismissOutletStatus /// присвоение видимости - невидимости кнопки ( подробнее в описании переменной dismissOutletStatus
        
        registerForKeyboardNotifications() /// подпишемся на уведомления клавиатуры
        
        /// клавиатура
        let hideKeyboardGesture = UITapGestureRecognizer(target: self,action: #selector(hideKeyboard)) 
        controllerView?.addGestureRecognizer(hideKeyboardGesture) //присваиваем жест нажатия
    }
    
    override func viewWillAppear(_ animated: Bool) { 
        super.viewWillAppear(animated)
        
        wishLists = CoreDataManager.shared.fetchWishList().reversed()
        cartProducts = CoreDataManager.shared.fetchCartProduct().reversed()
        table.reloadData() 
        totalPrice.text = "\(Int(getTotalPrice())) руб." /// ₽ - при выборе товаров, а руб. уже в корзине - так в фигме
        totalPricePromo.text = "\(Int(getTotalPrice())) руб."
        promo.text = ""
    }
    
    deinit {
        removeKeyboardNotifications() /// отпишемся от клавиатуры когда уходим
    }
}

// MARK: работа с таблицей
extension CartViewController: UITableViewDelegate, UITableViewDataSource { 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartViewControllerCell
        let cartProduct = cartProducts[indexPath.row]
        
        cell.name.text = cartProduct.name
        cell.color.text = cartProduct.color
        cell.size.text = cartProduct.size
        cell.price.text = cartProduct.price
        cell.quantity.text = cartProduct.quantity
        
        if let image = cartProduct.imageData {
            cell.imageData.image = UIImage(data: image)
        }
        
        cell.pressDownTap = { [unowned self] in  /// отслеживаем нажатие в ячейке на уменьшение количества вещей
            let newName = cell.name.text
            let newColor = cell.color.text
            let newSize = cell.size.text
            let newPrice = cell.price.text
            let newImage = cell.imageData.image
            
            let quantity = cartProduct.value(forKey: "quantity") as? String
            let itemQuantity = Int(quantity!)
            if itemQuantity! > 1 {
                for item in cartProducts {
                    if let nameTemp = item.value(forKey: "name") as? String, nameTemp == newName,
                       let sizeTemp = item.value(forKey: "size") as? String, sizeTemp == newSize,
                       let colorTemp = item.value(forKey: "color") as? String, colorTemp == newColor,
                       let quantity = item.value(forKey: "quantity") as? String,
                       var quantityTemp = Int(quantity) {
                        quantityTemp -= 1
                        
                        item.setValue("\(quantityTemp)", forKey: "quantity")
                        CoreDataManager.shared.changeToCoreDatePlusMinus(color: newColor!, image: newImage!, name: newName!, price: newPrice!, size: newSize!, quantity:  "\(quantityTemp)")

                        reloadTableData(index: indexPath)
                    }
                }
            }
        }
        
        cell.pressUpTap = { [unowned self] in /// отслеживаем нажатие в ячейке на увеличение количества вещей
            
            let newName = cell.name.text
            let newColor = cell.color.text
            let newSize = cell.size.text
            let newPrice = cell.price.text
            let newImage = cell.imageData.image
            
            for item in cartProducts {
                if let nameTemp = item.value(forKey: "name") as? String, nameTemp == newName,
                   let sizeTemp = item.value(forKey: "size") as? String, sizeTemp == newSize,
                   let colorTemp = item.value(forKey: "color") as? String, colorTemp == newColor,
                   let quantity = item.value(forKey: "quantity") as? String,
                   var quantityTemp = Int(quantity) {
                    quantityTemp += 1
                    
                    item.setValue("\(quantityTemp)", forKey: "quantity")
                    CoreDataManager.shared.changeToCoreDatePlusMinus(color: newColor!, image: newImage!, name: newName!, price: newPrice!, size: newSize!, quantity:  "\(quantityTemp)")
        
                    reloadTableData(index: indexPath)
                }
            }
        }
        
        cell.pressDelete = { [unowned self] in /// отслеживаем нажатие в ячейке на корзинку
            
            invisibleWindow(status: false)
            indexPathDelete = indexPath
        }
        
        cell.pressHeart = { [unowned self] in /// отслеживаем нажатие на сердечко
            if wishLists.count != 0 { /// если в корзине нет вещей - сразу сохраним
                for item in wishLists {
                    if let nameWishList = item.value(forKey: "name") as? String, nameWishList == cartProduct.name,
                       let colorWishList = item.value(forKey: "color") as? String, colorWishList == cartProduct.color,
                       let sizeWishList = item.value(forKey: "size") as? String, sizeWishList == cartProduct.size {
                    
                        let alert = UIAlertController(title: "Данная вещь уже добавлена в лист желаний ранее.", message: nil, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Отлично!", style: .default, handler: nil))
                        self.present(alert, animated: true)

                        return
                    }
                }
            }
            CoreDataManager.shared.saveProductToWishList(name: cartProduct.name!, size: cartProduct.size!, color: cartProduct.color!, image: cartProduct.imageData!, price: cartProduct.price!)
            trashButtonTapped(index: indexPath)
            
            TabBarUpdate.shared.getTotalQuantityCartProduct(tabBarController: tabBarController)
            TabBarUpdate.shared.getTotalQuantityWishList(tabBarController: tabBarController)
            BigIconAnimator.bigIconLive(icon: heartBigImage)
            reloadTableData(index: indexPath)
            
            return
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) { /// удаление строки жестом
        
        if (editingStyle == .delete) {
            trashButtonTapped(index: indexPath)
        }
        tabBarItem.badgeValue = String(cartProducts.count)
    }
    
    func trashButtonTapped(index: IndexPath?) { ///  удаление из корзины (самое действие)
        guard let index = index else { return }
        let  productToDelite = cartProducts[index.row] /// для удаления из самой базы
        CoreDataManager.shared.deleteCartProduct(product: productToDelite)
        reloadTableData(index: index)
    }
    
    func reloadTableData(index: IndexPath?)  { ///  обновление данных после изменения данных в таблице
        cartProducts = CoreDataManager.shared.fetchCartProduct().reversed()
        wishLists = CoreDataManager.shared.fetchWishList().reversed()
        table.reloadData()
        totalPrice.text = "\(Int(getTotalPrice())) руб."
        totalPricePromo.text = "\(Int(getTotalPrice())) руб."
        tabBarItem.badgeValue = String("\(getTotalQuantity())")
    }
    
    func trashButtonAll() {
        CoreDataManager.shared.deleteCartProductAll()
        cartProducts = CoreDataManager.shared.fetchCartProduct().reversed()
        table.reloadData()
    }
}

// MARK: работа с расчетными данными
extension CartViewController {
    func getTotalPrice() -> Float { /// сумма товаров в корзине (reduce не работает с типом NSManagedObject (корзина)
        var totalPrice: Float = 0
        for product in cartProducts {
            if let price = Float(product.price ?? "0"), let quantity = Float(product.quantity ?? "0") {
                totalPrice += (price * quantity)
            }
        }
        return totalPrice
    }
    
    func promoPriceCalculation() { /// расчет стоимости с промокодом до оплаты
        let totalPrice10 = Double(getTotalPrice()) - (Double(getTotalPrice()) * 0.1)
        let totalPrice300 = Int(getTotalPrice()) - 300
        
        if  discont10 == promo.text && Int(getTotalPrice()) > 7000 {
            totalPricePromo.text = "\(Int(totalPrice10)) руб."
        } else if discont300 == promo.text && Int(getTotalPrice()) > 5000 {
            totalPricePromo.text = "\(Int(totalPrice300)) руб."
        } else {
            totalPricePromo.text = "\(Int(getTotalPrice())) руб."
        }
    }
    
    func promoPriceCalculationBuy() { /// расчет стоимости с промокодом в переменную во время оплаты
        let totalPrice10 = Double(getTotalPrice()) - (Double(getTotalPrice()) * 0.1)
        let totalPrice300 = Int(getTotalPrice()) - 300
        
        if  discont10 == promo.text && Int(getTotalPrice()) > 7000 {
            sumTotal = Int(totalPrice10)
        } else if discont300 == promo.text && Int(getTotalPrice()) > 5000 {
            sumTotal = Int(totalPrice300)
        } else {
            sumTotal = Int(getTotalPrice())
        }
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

// MARK: работа с клавиатурой
extension CartViewController { /// клавиатура
    func registerForKeyboardNotifications() { ///  подпишемся на уведомления клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil) // появление клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil) // скрытие клавиатуры
    }
    
    func removeKeyboardNotifications() { ///  удаляем наблюдателя из памяти (отпишемся от сообщений с клавиатуры)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func kbWillShow(notification: Notification) { /// метод появления клавиатуры
        let info = notification.userInfo as NSDictionary?
        let kbFrameSize = (info?.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size /// получение значения фрейма клавиатуры
        
        scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height + kbFrameSize.height) /// сместим контент в скроллвью на размер клавиатуры
    }
    
    @objc func kbWillHide() { /// скрытие клавиатуры
        scrollView.contentOffset = CGPoint.zero /// контент вернется обратно
    }
    
    @objc func hideKeyboard() { /// исчезновение клавиатуры при клике по пустому месту на экране
        self.controllerView?.endEditing(true)
        promo.resignFirstResponder() /// нажатие в текстовом поле делает его активным
        
    }
}
