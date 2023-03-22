// анимация иконок в меню выбора размеров, вишлисте, корзине

import UIKit

class IconAnimator { // анимация иконок в меня выбора цвет-размер
 
    static func iconStart(icon: UIImageView) { // стартовый цвет - серый
        let newImage = icon.image?.withRenderingMode(.alwaysTemplate) // withRenderingMode - возвращает новую версию изображения, использующего указанный режим визуализации.  alwaysTemplate - игнорируя информацию о его цвете
        icon.image = newImage
        icon.tintColor = .lightGray
    }

    static func iconShow(icon: UIImageView, color: UIColor) { // смена цвета иконки и анимация
        icon.tintColor = color
        UIImageView.animate(withDuration: 0.2, animations: {
            icon.transform = CGAffineTransform(scaleX: 2, y: 2)
        }) {(isCompeted) in
            UIView.animate(withDuration: 0.1, animations: {
                icon.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
}
