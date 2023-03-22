
import UIKit

protocol ItemChooserCartDelegate { // протокол делегата сохраненния в корзину
    func itemChooserCart(color: String, size: String)
}

protocol ItemChooserWishListDelegate { // протокол делегата сохраненния в виш лист
    func itemChooserWishList(color: String, size: String)
}

class SizeViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView! // цвет, размер
    
    var delegateCart: ItemChooserCartDelegate?
    var delegateWishList: ItemChooserWishListDelegate?
    
    var items = [Item]() // модель вещи
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() // в таблице в контейнере не показывает пустые строки если не все строки заняты размерами (Представление, отображаемое под содержимым таблицы. Используйте это свойство, чтобы указать вид нижнего колонтитула для всей таблицы)
    }
}

extension SizeViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // заполним таблицу данными цвет-размер
        let cell = tableView.dequeueReusableCell(withIdentifier: "sizeCell", for: indexPath)
        if let sizeCell = cell as? SizeTableViewCell {
            sizeCell.color = items[indexPath.section].offers[indexPath.row].color // цвет
            let sizeEur = items[indexPath.section].offers[indexPath.row].size // размер
            let sizeRus = SizeConverter[sizeEur] // конвертер
            
            if let size = sizeRus {
                sizeCell.size = "\(size) RUS \(sizeEur)" // интерпритация конвертера
            } else {
                sizeCell.size = sizeEur
            }
            sizeCell.doneImage.image = nil
            
            sizeCell.pressCart = { [unowned self] in
                sizeCell.doneImage.image = UIImage(named: "Done")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in // выполнение задачи в основном потоке с выполнением указанных атрибутов (deadline - время, на которое планируется выполнение блока и возвращает текущее время + величина
                    
                    let colorCart = items[indexPath.section].offers[indexPath.row].color
                    let sizeCart = items[indexPath.section].offers[indexPath.row].size
                    
                    delegateCart?.itemChooserCart(color: colorCart, size: sizeCart)
                }
            }

            sizeCell.pressHeart = { [unowned self] in
                sizeCell.doneImage.image = UIImage(named: "Done")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
                    let colorWishList = items[indexPath.section].offers[indexPath.row].color // цвет делегату
                    let sizeWishList = items[indexPath.section].offers[indexPath.row].size // размер делегату
                    
                    delegateWishList?.itemChooserWishList(color: colorWishList, size: sizeWishList) // делегат со значениями для вишлиста
                 
                }
            }
            return sizeCell 
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { // Просит источник данных проверить, что данная строка доступна для редактирования (если в таблице размеров кликнуть не по ячейке, например по области внизу, то таблица не должна воспринимать этот  жест)
        return false
    }
}
