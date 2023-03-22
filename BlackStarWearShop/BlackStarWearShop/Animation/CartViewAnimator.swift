// анимация иконки корзинки в боксе при добавления вещи +1

import UIKit

class CartViewAnimator {
    
    static func animate(_ view: UIView ) {
        UIView.animate(withDuration: 0.3, animations: {
            view.transform = CGAffineTransform(scaleX: 3, y: 3)
            
        }) {(isCompeted) in
            UIView.animate(withDuration: 0.25, animations: {
                view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                
            }) {(isCompeted) in
                UIView.animate(withDuration: 0.2, animations: {
                    view.transform = CGAffineTransform(scaleX: 2, y: 2)
                    
                }) {(isCompeted) in
                    UIView.animate(withDuration: 0.15, animations: {
                        view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    }) {(isCompeted) in
                        UIView.animate(withDuration: 0.10, animations: {
                            view.transform = CGAffineTransform(scaleX: 1, y: 1)
                        })
                    }
                }
            }
        }
    }
}


//class CartViewAnimator {
//
//    static func animate(_ view:UIView ) {
//        UIView.animate(withDuration: 0.3, animations: {
//            view.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
//
//        }) {(isCompeted) in
//            UIView.animate(withDuration: 0.35, animations: {
//                view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
//
//            }) {(isCompeted) in
//                UIView.animate(withDuration: 0.4, animations: {
//                    view.transform = CGAffineTransform(scaleX: 2, y: 2)
//
//                }) {(isCompeted) in
//                    UIView.animate(withDuration: 0.45, animations: {
//                        view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
//
//                    }) {(isCompeted) in
//                        UIView.animate(withDuration: 0.5, animations: {
//                            view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//                        }) {(isCompeted) in
//                            UIView.animate(withDuration: 0.55, animations: {
//                                view.transform = CGAffineTransform(scaleX: 1, y: 1)
//                            })
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//


//    static private let duration = 0.4
//
//    static func animate1(_ view:UIView, completion: ( () -> Void )? = nil  ) {
//        UIViewPropertyAnimator.runningPropertyAnimator(
//            withDuration: duration,
//            delay: 0,
//            options: .curveLinear,
//            animations: { view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)},
//            completion: { if $0 == .end {
//                UIViewPropertyAnimator.runningPropertyAnimator(
//                    withDuration: duration,
//                    delay: 0,
//                    options: .curveLinear, // равномерно
//                    animations: { view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)},
//                    completion: { if $0 == .end {
//                        UIViewPropertyAnimator.runningPropertyAnimator(
//                            withDuration: duration,
//                            delay: 0,
//                            options: .curveLinear,
//                            animations: {view.transform = .identity },
//                            completion: { if $0 == .end { completion?()}})
//                    }})
//            }})
//    }

