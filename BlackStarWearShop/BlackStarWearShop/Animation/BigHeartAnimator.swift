// анимация большого сердечка при перемещении в вишлист

import UIKit

class BigHeartAnimator {
    
    static func bigHeartLive(heart: UIImageView, heartFull: UIImageView) { // увеличение в два раза
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(0.2))) {
            UIView.animate(withDuration: 1, animations: {
                heart.alpha = 0.7
            })
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            heart.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            heartFull.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) {(isCompeted) in
            UIView.animate(withDuration: 0.2, animations: {
                heart.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                heartFull.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }) {(isCompeted) in
                UIView.animate(withDuration: 0.2, animations: {
                    heart.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    heartFull.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(0.2))) {
                        UIView.animate(withDuration: 0.2, animations: {
                            heartFull.alpha = 0.7
                        })
                    }
                    
                }) {(isCompeted) in
                    UIView.animate(withDuration: 0.3, animations: {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(0.2))) {
                            heart.alpha = 0
                            UIView.animate(withDuration: 0.2, animations: {
                                heartFull.alpha = 0
                            })
                        }
                        
                        heart.transform = CGAffineTransform(scaleX: 1, y: 1)
                        heartFull.transform = CGAffineTransform(scaleX: 1, y: 1)
                    })
                }
            }
        }
    }
}
