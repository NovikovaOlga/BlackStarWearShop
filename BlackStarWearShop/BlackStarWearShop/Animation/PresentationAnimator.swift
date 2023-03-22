
import UIKit

class PresentationAnimator {

    static func presentationAnimatorLive(background: UIView, viewPresentation: UIView) {
        background.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        background.alpha = 0.8 // при презентации фон чуть прозрачный
        viewPresentation.isHidden = false
    }
    
    static func presentationAnimatorClose(background: UIView, viewPresentation: UIView) {
        background.backgroundColor = .clear
        background.alpha = 1 // оставим такую альфу для анимации копилки (фон непрозрачный)
        viewPresentation.isHidden = true
    }
}
