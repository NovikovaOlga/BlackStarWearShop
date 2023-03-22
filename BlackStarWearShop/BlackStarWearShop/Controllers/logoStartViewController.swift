
import UIKit

class logoStartViewController: UIViewController {
    
    @IBOutlet var skyView: UIView!
    
    @IBOutlet weak var starShadow: UIView!
    @IBOutlet weak var lionImage: UIImageView!
    @IBOutlet weak var starView: UIView! //{ didSet {
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonTap(_ sender: UIButton) {
        lionAnimate()
        lionBigAnimate()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(1.5))) {
            self.dismiss(animated: true)
            self.performSegue(withIdentifier: "loginVC", sender: self)
        }
    }

    @IBOutlet weak var blackStarWearLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startSky()
        showSky()
        textAnimate()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            self.starShadowAnimate(shadow: self.starShadow)
        }
    }
    
    func startSky() { // первичная загрузка
        
        skyView.layer.backgroundColor = UIColor.white.cgColor
        starShadow.layer.backgroundColor = UIColor.black.cgColor
        starShadow.layer.cornerRadius = starShadow.bounds.width/2
        starShadow.layer.shadowOpacity = 1
        starShadow.layer.shadowRadius = 25
        starShadow.layer.masksToBounds = false
        starView.layer.backgroundColor = UIColor.white.cgColor
        starView.layer.cornerRadius = starView.bounds.width/2
        blackStarWearLogo.alpha = 0
        lionImage.alpha = 0
        lionImage.layer.cornerRadius = lionImage.bounds.width/2
    }
    
    func showSky() { // анимация после загрузки - установка цветов
        UIView.animate(withDuration: 3, animations: {
            self.skyView.backgroundColor = UIColor.black
            self.starShadow.layer.shadowColor = UIColor.white.cgColor
            self.starView.backgroundColor = UIColor.black
        })
    }
    
    func textAnimate() { // анимация текста
        UIView.animate(withDuration: 3, delay: 3, options: [], animations: {
            self.blackStarWearLogo.alpha = 0.7
        })
    }
    
    func starShadowAnimate(shadow: UIView) { // кнопка пульсирует
        UIView.animate(withDuration: 1.6, delay: 0, options: [.repeat, .autoreverse], animations: {
            shadow.transform = CGAffineTransform(scaleX: 1.2, y: 1.2) // был 1.1
        })
    }
    
    func starShadowAnimate1(shadow: UIView) {  // тень мерцает (сейчас не используется - хранится как альтернатива)
        UIView.animate(withDuration: 1.2, delay: 0, options: [.repeat, .autoreverse], animations: {
            shadow.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            
        })
    }
    
    func lionAnimate() { // анимация льва - появление
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.lionImage.alpha = 1
            self.blackStarWearLogo.alpha = 0
        })
    }
    
    func lionBigAnimate() { // анимация льва - увеличение
        UIView.animate(withDuration: 1.5, animations: {
            self.lionImage.transform = CGAffineTransform(scaleX: 3, y: 3)
        })
    }
}

