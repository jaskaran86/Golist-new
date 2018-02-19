
import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none

     
    }
    
    // MARK: - TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         return categories?.count ?? 1
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row]{
            
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
        
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
                
            cell.backgroundColor = categoryColor
            
            }
            
        
        return cell 
    
    }
    
// MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ShowListSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! GoListViewController
    
        if let indexPath = tableView.indexPathForSelectedRow {
            
        destinationVC.selectedCategory = categories?[indexPath.row]
  
        }
}
//    MARK: - Tableview Manipulation Methods
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
            
        } catch {
                
             print("Error saving category \(error)")
        
            }
            tableView.reloadData()
        }
        
    
    
    func loadCategories() {
    
       categories = realm.objects(Category.self)
    
        tableView.reloadData()
  
    }

    
//MARK:- Delete Data from Swipe

    override func updateModel(at indexPath: IndexPath) {
        
        if let CategoryForDeletion = self.categories?[indexPath.row] {
            
            do { try self.realm.write {
                self.realm.delete(CategoryForDeletion)
                }
                
            } catch {
                print("Error Deleting, \(error)")
                
            }
            
        }
        
    }
    
    
    
//MARK: - Add New Category

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
     
            var textField = UITextField()

            let alert = UIAlertController(title: "Add new Golist Item", message: "", preferredStyle: .alert)

            let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                
                        let newCategory = Category()
                        newCategory.name = textField.text!
                        newCategory.color = UIColor.randomFlat.hexValue()
                
                        self.save(category: newCategory)
                
                
                    }

                    alert.addTextField { (alertTextField) in
                        alertTextField.placeholder = "Create New Item"
                        
                        textField = alertTextField
                    }

                    alert.addAction(action)

                    present(alert, animated: true, completion: nil)

                    }


                    }


    


    
    




