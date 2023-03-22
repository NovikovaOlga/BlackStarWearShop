
import UIKit

class Money { 
    
    static let shared = Money()
    
    private let kUserMoneyKey = "Money.kUserMoneyKey"
    
    var userMoney: Int{
        set { UserDefaults.standard.set(newValue, forKey: kUserMoneyKey) }
        get { return UserDefaults.standard.integer(forKey: kUserMoneyKey) }
    }
}

