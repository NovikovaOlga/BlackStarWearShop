
import UIKit

class PiggyBankAnimation {
    
    static func piggyBankLive(icon: UIImageView, background: UIView, money: UILabel) {
        
        money.alpha = 1
        
        background.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        UIView.animate(withDuration: 0.2, animations: {
            icon.alpha = 1
          
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(0.2))) {
            UIView.animate(withDuration: 0.8, animations: {
                money.alpha = 0
            })
        }
        
        UIView.animate(withDuration: 1, animations: {
            money.transform = CGAffineTransform(translationX: 0, y: 390)
        }) {(isCompeted) in
        UIView.animate(withDuration: 0.3, animations: {
            icon.transform = CGAffineTransform(scaleX: 1.5, y: 0.8)
        }) {(isCompeted) in
            UIView.animate(withDuration: 0.2, animations: {
                icon.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
            }) {(isCompeted) in
                UIView.animate(withDuration: 0.1, animations: {
                    icon.transform = CGAffineTransform(scaleX: 1.2, y: 0.9)
                }) {(isCompeted) in
                    UIView.animate(withDuration: 0.1, animations: {
                        icon.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }) {(isCompeted) in
                        
                 //       DispatchQueue.main.asyncAfter(deadline: .now()) {
                            UIView.animate(withDuration: 0.1, animations: {
                                icon.alpha = 0
                            }) {(isCompeted) in
                                money.transform = CGAffineTransform(translationX: 0, y: 0)
                                background.backgroundColor = .clear
                                
                            }
                        }
                    }
                }
            }
        }
    }
}
