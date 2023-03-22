// Здесь переиспользуемый контроллер категорий и подкатегорий (после комментария преподавателя 09.06.21). все ссылки на категории (category) переиспользуются и для подкатегорий.

import UIKit

class CategoryTableViewController: UITableViewController {
    
    var categories = [Category]()
    var subcategories = [SubCategory]()
    
    var twinScreen = false // переключатель экранов
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBAction func backButtonTaped(_ sender: Any) {
        twinScreen = false
        subcategories = []
        backButton.isEnabled = false
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.isEnabled = false
        if categories.isEmpty { 
            CategoryFetcher.fetch { [weak self] in // берем класс CategoriesFetcher, а в нем функцию fetch
                self?.categories = $0 // содержит хотябы один элемент
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) { 
        twinScreen = false
        tableView.reloadData()
        backButton.isEnabled = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if twinScreen { // переключатель
            print(subcategories) // УДАЛИТЬ
            return subcategories.count
        } else {
            print(categories) // УДАЛИТЬ
            return categories.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! CategoryTableViewCell
        cell.index = indexPath
        cell.delegate = self
        cell.categoryImage.image = nil
        
        if twinScreen {
            let subcategory = subcategories[indexPath.row]
            cell.categoryLabel.text = subcategory.name
            cell.fetchImage(URLS.urlGeneralIcon(iconName: subcategories[indexPath.row].iconImage), backupData: subcategories[indexPath.row].copyIconImage) { [weak self]
                (data, url) in
                self?.subcategories[indexPath.row].copyIconImage = data
            }
        } else {
            let category = categories[indexPath.row]
            cell.categoryLabel.text = category.name
            cell.fetchImage(URLS.urlGeneralIcon(iconName: categories[indexPath.row].iconImage), backupData: categories[indexPath.row].copyIconImage) { [weak self]
                (data, url) in
                self?.categories[indexPath.row].copyIconImage = data
            }
        }
        if cell.categoryImage.image == nil { cell.categoryImage.image = UIImage(named: "placeholder")} // КОД: "не нравится 1"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        backButton.isEnabled = true
        if twinScreen{
            performSegue(withIdentifier: "items", sender: indexPath.row)
        } else {
            twinScreen = true
            subcategories = categories[indexPath.row].subCategories.sorted(by: {$0.sortOrder > $1.sortOrder})
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "items", let index = sender as? Int {
            let subcategory = subcategories[index]
            let newVC = segue.destination as! ItemCollectionViewController
            newVC.itemID = subcategory.id
        }
    }
}

extension CategoryTableViewController : ReloadCellDelegate {
    
    func reloadCell(at index: IndexPath?) {
    
        if let index = index{
            tableView.reloadRows(at: [index], with: .automatic)
        }
    }
}
