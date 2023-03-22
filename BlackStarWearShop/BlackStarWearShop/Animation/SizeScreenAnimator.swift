// меню выбора размеров

import UIKit

class SizeScreenAnimator { // появление окна выбора размеров с анимацией
    
    static private let duration = 0.3
    
    static func screenUp(_ view: UIView, by value: CGFloat) { // окно появилось
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: duration,
            delay: 0,
            options: .curveLinear) {
            view.frame.origin.y -= value
        } completion: { if $0 == .end {}
        }
    }
    
    static func screenDown(_ view: UIView, by value: CGFloat, completion: @escaping () -> Void) { // окно исчезло
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: duration,
            delay: 0,
            options: .curveLinear) {
            view.frame.origin.y += value
        } completion: { if $0 == .end {
            view.isHidden = true
            completion()
        }
        }
    }
}
