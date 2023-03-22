
import UIKit

class BigIconAnimator {
    
    static func bigIconLive(icon: UIImageView) {
        
        UIView.animate(withDuration: 0.8, animations: {
            icon.alpha = 0.5
        })

        UIView.animate(withDuration: 0.2, animations: {
            icon.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) {(isCompeted) in
            UIView.animate(withDuration: 0.2, animations: {
                icon.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }) {(isCompeted) in
                UIView.animate(withDuration: 0.2, animations: {
                    icon.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                }) {(isCompeted) in
                    UIView.animate(withDuration: 0.3, animations: {
                        icon.transform = CGAffineTransform(scaleX: 1, y: 1)
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        UIView.animate(withDuration: 0.3, animations: {
                            icon.alpha = 0
                        })
                    }
                }
            }
        }
    }
}

