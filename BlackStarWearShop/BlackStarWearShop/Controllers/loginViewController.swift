/* Алгоритм:
 1) загрузка - львенок спит
 2) через 2 секунды открывает глаза - добрый
 3) вход в поле логин - восторг
 4) вход в поле пароль - сон
 5) кнопка забыли пароль или логин - испуг
 6) авторизация  - добрый
 */

import UIKit

class loginViewController: UIViewController {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func loginButton(_ sender: Any) {
    }
    @IBOutlet weak var loginButtonOutlet: UIButton! { didSet {
        loginButtonOutlet.layer.cornerRadius = 4
    }}
    
    @IBAction func forgotButton(_ sender: UIButton) {
        lionAfraid()
        loginPasswordHelp()
        loginTextField.resignFirstResponder() // потеряем фокус логина - чтобы лев корректно работал
        passwordTextField.resignFirstResponder() // потеряем фокус пароля - чтобы лев корректно работал
    }
    
    @IBOutlet weak var loginHelp: UILabel! { didSet { 
        loginHelp.text = nameStat
    }}
    @IBOutlet weak var passwordHelp: UILabel! { didSet {
        passwordHelp.text = passwordStat
    }}
    
    // голова льва - все привязки запчастей внутри
    @IBOutlet weak var lionView: UIView!
    @IBOutlet weak var lionImage: UIImageView! // голова
    @IBOutlet weak var nose: UIImageView! // нос
    @IBOutlet weak var eyeLeft: UIView!  // хранилище левого глаза
    @IBOutlet weak var eyeRight: UIView!  // хранилище правого глаза
    
    // спящий
    @IBOutlet weak var sleepEyeLeft: UIImageView!
    @IBOutlet weak var sleepEyeRight: UIImageView!
    @IBOutlet weak var sleepMouth: UIImageView!
    
    // хороший
    @IBOutlet weak var goodMouth: UIImageView!
    @IBOutlet weak var goodEyeLeft: UIImageView!
    @IBOutlet weak var goodEyeRight: UIImageView!
    
    // смешной
    @IBOutlet weak var joyEyeLeft: UIImageView!
    @IBOutlet weak var joyEyeRight: UIImageView!
    @IBOutlet weak var joyMouth: UIImageView!
    
    // испуган
    @IBOutlet weak var afraidMouth: UIImageView!
    @IBOutlet weak var afraidEyeLeftWhite: UIView! { didSet {
        afraidEyeLeftWhite.layer.cornerRadius = afraidEyeLeftWhite.bounds.width/2
    }}
    @IBOutlet weak var afraidEyeRightWhite: UIView! { didSet {
        afraidEyeRightWhite.layer.cornerRadius = afraidEyeRightWhite.bounds.width/2
    }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginHelp.alpha = 0.0
        passwordHelp.alpha = 0.0
        lionGood()
        
        // селекторы полей ввода (наблюдатели событий)
        loginTextField.addTarget(self, action: #selector(editingBegan(_:)), for: .editingDidBegin)
        passwordTextField.addTarget(self, action: #selector(editingBegan(_:)), for: .editingDidBegin)
        
        // клавиатура
        let hideKeyboardGesture = UITapGestureRecognizer(target: self,action: #selector(hideKeyboard)) // жест нажатия в любом месте экрана для исчезновения клавиатуры
        backgroundView?.addGestureRecognizer(hideKeyboardGesture) //присваиваем жест нажатия
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil) // подписываемся на уведомления при появлении клавиатуры
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)  //подписываемся на уведомления при исчезновении клавиатуры
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil) // отписываемся от сообщений с клавиатуры при исчезновении контроллера с экрана
    }
    
    func loginPasswordHelp() { // подсазка
        UIView.animate(withDuration: 2, animations: {
            self.loginHelp.alpha = 1.0
            self.passwordHelp.alpha = 1.0
        }) {(isCompeted) in
            UIView.animate(withDuration: 2, animations: {
                self.loginHelp.alpha = 0.0
                self.passwordHelp.alpha = 0.0
            })
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {  // сега в магазин
        let checkResult = checkUserData()
        if !checkResult { // если данные не верны, покажем ошибку
            showLoginError()
        }
        return checkResult
    }
    
    func checkUserData() -> Bool {
        guard let login = loginTextField.text, let password = passwordTextField.text else { return false }
        
        if login == nameStat && password == passwordStat {
            lionGood()
            return true
        } else {
            lionAfraid()
            return false
        }
    }
    
    func showLoginError() {
        let alter = UIAlertController(title: "Ошибка", message: "Введены не верные данные пользователя", preferredStyle: .alert)  // Создаем контроллер
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil) // Создаем кнопку для UIAlertController
        alter.addAction(action) // Добавляем кнопку на UIAlertController
        present(alter, animated: true, completion: nil) // Показываем UIAlertController
    }
}

extension loginViewController { // клавиатура
    
    @objc func keyboardWasShow(notification: Notification) { // когда клавиатура появляется
        
        //    let info = notification.userInfo as NSDictionary? // получаем размер клавиатуры
        //   let keyboardSize = (info?.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        //   let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        
        
        //        self.scrollView?.contentInset = contentInsets // Добавляем отступ внизу , равный размеру клавиатуры
        //        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) { //Когда клавиатура исчезает 
        //  let contentInsets = UIEdgeInsets.zero // Устанавливаем отступ внизу UIScrollView, равный 0
        // scrollView?.contentInset = contentInsets
    }
    
    @objc func hideKeyboard() { // исчезновение клавиатуры при клике по пустому месту на экране
        self.backgroundView?.endEditing(true)
    }
}

extension loginViewController { // состояние льва
    
    @objc func editingBegan(_ textField: UITextField) {  // обработка действий логина (joy) и пароля (sleep)
        //пользователь попал в поле, но еще ничего не ввел
        if textField == loginTextField {
            lionJoy()
        } else if textField == passwordTextField {
            lionSleep()
        }
    }
    
    func lionGood() { // обработка действия joy
        joy(joy: true)
        afraid(afraid: true)
        good(good: false)
        sleep(sleep: true)
    }
    
    func lionJoy() { // обработка действия joy
        joy(joy: false)
        afraid(afraid: true)
        good(good: true)
        sleep(sleep: true)
    }
    
    func lionSleep() { // обработка действия sleep
        sleep(sleep: false)
        good(good: true)
        afraid(afraid: true)
        joy(joy: true)
    }
    
    func lionAfraid() { // обработка действия afraid
        joy(joy: true)
        afraid(afraid: false)
        good(good: true)
        sleep(sleep: true)
    }
    
    // возможности льва
    func sleep(sleep: Bool) { // спит
        sleepEyeLeft.isHidden = sleep
        sleepEyeRight.isHidden = sleep
        sleepMouth.isHidden = sleep
    }
    
    func good(good: Bool) { // добрый
        goodEyeLeft.isHidden = good
        goodEyeRight.isHidden = good
        goodMouth.isHidden = good
    }
    
    func joy(joy: Bool) { // счастливый
        joyEyeLeft.isHidden = joy
        joyEyeRight.isHidden = joy
        joyMouth.isHidden = joy
    }
    
    func afraid(afraid: Bool) { // испуган
        afraidEyeRightWhite.isHidden = afraid
        afraidEyeLeftWhite.isHidden = afraid
        afraidMouth.isHidden = afraid
    }
}
