
import UIKit

class PersonalAccountViewController: UIViewController {
    
    var cartProducts: [CartProduct] = [] /// для количества вещей в корзине в таббаре - шарим сюда
    var wishLists: [WishList] = [] /// для количества вещей в вишлисте в таббаре - шарим сюда
    
    var indexStep = 0
    
    let info = ["piggyBank",
                "heartIntroduction",
                "saleIntroduction"]
    
    let message = ["быстрое пополнение счета в личном кабинете",
                   "сохраняй любимые модели в лист желаний",
                   "используй промокоды из личного кабинета"]
    
    @IBOutlet weak var loginHello: UILabel! { didSet { /// покупатель
        loginHello.text = nameStat
    }}
    
    @IBOutlet weak var moneyHello: UILabel! /// денег у покупателя
    
    @IBOutlet weak var moneyTextField: UITextField! /// поле пополнения
    
    @IBAction func moneySaveButton(_ sender: Any) {
        
        if moneyTextField.text == "" { moneyTextField.text = "0" } /// если ничего не ввели, даже 0
        if moneyTextField.text != "0" { /// если ввели 0 и поэтому пропустили верхнюю строчку проверки
            Money.shared.userMoney = Money.shared.userMoney + Int(moneyTextField.text!)! /// сохранение введенных данных в user defolts
            ///      Money.shared.userMoney = Int(moneyTextField.text!)! // когда надо переписать сумму в юзердефолтс, а не просто добавить (чтоб красиво, перед сдачей)
            
            piggyPlus.text = "+ \(String(moneyTextField.text!)) р." // сумму в поле-анимации для копилки
            PiggyBankAnimation.piggyBankLive(icon: piggyBank, background: background, money: piggyPlus)
            moneyTextField.text = ""
            moneyTextField.resignFirstResponder() /// убираем фокус из поля
            moneyHello.text = String(Money.shared.userMoney) /// загрузим/ обновим деньги
        }
    }
    
    @IBOutlet weak var background: UIView!
    
    /// Блок: анимация копилки
    @IBOutlet weak var piggyBank: UIImageView! {  didSet { /// копилка
        let newpiggyBank = piggyBank.image?.withRenderingMode(.alwaysTemplate)
        piggyBank.image = newpiggyBank
        piggyBank.tintColor = .darkGray
    }}
    
    @IBOutlet weak var piggyPlus: UILabel! /// надпись (кастомный цвет - blueberry)
    
    /// БЛОК: Презентация обновленного магазина
    @IBOutlet weak var viewPresentation: UIView! /// view со всеми элементами
    
    @IBAction func closePresentationButton(_ sender: Any) { /// кнопка закрыть
        PresentationAnimator.presentationAnimatorClose(background: background, viewPresentation: viewPresentation)
    }
    
    @IBOutlet weak var closePresentationOutlet: UIButton! /// аутлет кнопки закрыть
    
    @IBOutlet weak var messagePresentation: UILabel! /// сообщение презентации
    
    @IBOutlet weak var imagePresentation: UIImageView! { didSet { /// картинка презентации
        let newImage = imagePresentation.image?.withRenderingMode(.alwaysTemplate)
        imagePresentation.image = newImage
        imagePresentation.tintColor = .darkGray
    }}
    
    @IBAction func backButton(_ sender: Any) { /// кнопка назад бесконечная
        if indexStep == 0 {
            indexStep = info.count - 1
            imagePresentation.image = UIImage.init(named: info[indexStep % info.count])
            messagePresentation.text = message[indexStep % info.count]
            step.text = "Шаг \(info.count) из \(info.count)"
        } else {
            indexStep -= 1
            imagePresentation.image = UIImage.init(named: info[indexStep % info.count])
            messagePresentation.text = message[indexStep % info.count]
            step.text = "Шаг \(indexStep + 1) из \(info.count)"
        }
    }
    
    @IBOutlet weak var backImage: UIImageView! { didSet { /// картинка назад
        let newImage = backImage.image?.withRenderingMode(.alwaysTemplate)
        backImage.image = newImage
        backImage.tintColor = .lightGray
    }}
    
    @IBAction func nextButton(_ sender: Any) { /// кнопка вперед бесконечная
        // Бесконечная прокрутка вперед
        if indexStep < info.count {
            indexStep += 1
            imagePresentation.image = UIImage.init(named: info[indexStep % info.count])
            messagePresentation.text = message[indexStep % info.count]
            if indexStep < info.count { // этот блок корректно считает шаги (без него появляется шаг 4 из 3)
                step.text = "Шаг \(indexStep + 1) из \(info.count)"
                print("блок 1a = \(indexStep + 1 )")
            } else {
                indexStep = 0
                step.text = "Шаг \(indexStep + 1) из \(info.count)"
                print("блок 1b = \(indexStep)")
            }
        } else {
            indexStep = 1
            ///    indexStep += 1
            imagePresentation.image = UIImage.init(named: info[indexStep % info.count])
            messagePresentation.text = message[indexStep % info.count]
            step.text = "Шаг \(indexStep) из \(info.count)"
            print("блок 2 = \(indexStep)")
        }
    }
    
    @IBOutlet weak var nextImage: UIImageView! { didSet { /// картинка вперед
        let newImage = nextImage.image?.withRenderingMode(.alwaysTemplate)
        nextImage.image = newImage
        nextImage.tintColor = .lightGray
    }}
    
    @IBOutlet weak var step: UILabel! /// шаг 1 из
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moneyTextField.clearButtonMode = .always /// Всегда показывать кнопку очистки
        moneyTextField.keyboardType = UIKeyboardType.numberPad /// числовая клавиатура (также делегат следит чтобы не вставили буквы на айпад или копированием)
        
        moneyTextField.delegate = self /// наблюдаем чтобы вводили только числа!!!!
        moneyTextField.text = ""
        PresentationAnimator.presentationAnimatorLive(background: background, viewPresentation: viewPresentation)
        
        imagePresentation.image = UIImage.init(named: info[0])
        messagePresentation.text = message[0]
        step.text = "Шаг 1 из 3"
        
        piggyBank.alpha = 0
        piggyPlus.alpha = 0
        background.isUserInteractionEnabled = false
        
        TabBarUpdate.shared.getTotalQuantityCartProduct(tabBarController: tabBarController)
        TabBarUpdate.shared.getTotalQuantityWishList(tabBarController: tabBarController)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        moneyHello.text = String(Money.shared.userMoney) /// загрузим/ обновим деньги
    }
    
    private func getTotalQuantity() -> Int { /// количество вещей в корзине
        var totalQuantity: Int = 0
        for product in cartProducts {
            if let quantity = Int(product.quantity ?? "0") {
                totalQuantity += quantity
            }
        }
        return totalQuantity
    }
}

extension PersonalAccountViewController: UITextFieldDelegate { /// UITextFieldDelegate - будем следить, чтобы вводили только числа
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == moneyTextField {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}
