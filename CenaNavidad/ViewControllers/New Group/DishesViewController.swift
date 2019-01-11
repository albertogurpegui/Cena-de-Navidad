//
//  DishesViewController.swift
//  CenaNavidad
//
//  Created by ALBERTO GURPEGUI RAMÓN on 10/1/19.
//  Copyright © 2019 David gimenez. All rights reserved.
//

import UIKit
import RealmSwift

class DishesViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    internal  var repository:LocalDishRepository!
    internal var dishes: [Dish] = []
    internal var filteredDishes: [Dish] = []
    let realm = try! Realm()
    var dish:Dish?
    
    init(){
        super.init(nibName: "DishesViewController", bundle: nil)
        self.title = NSLocalizedString("PLATOS", comment: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dishes = repository.getAll()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        
        repository = LocalDishRepository()
        dishes = repository.getAll()
        
        createButtonAdd()
    }
    
    internal func registerCell(){
        let identifier = "DishTableViewCell"
        let cellNib = UINib(nibName: identifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: identifier)
    }
    
    internal func createButtonAdd(){
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
        navigationItem.rightBarButtonItem = addButtonItem
    }
    
    @objc internal func addPressed (){
        let addVC = AddDishViewController()
        addVC.delegate = self
        addVC.modalTransitionStyle = .coverVertical
        addVC.modalPresentationStyle = .overCurrentContext
        present(addVC,animated: true,completion: nil)
    }
    
    internal func filterContentForSearchText(_ searchText: String){
        filteredDishes = dishes.filter({ (nParticipants: Dish ) -> Bool in
            return (nParticipants.name.lowercased().contains(searchText.lowercased()))
        })
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DishesViewController: UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DishTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DishTableViewCell", for: indexPath) as! DishTableViewCell
        let dish = dishes[indexPath.row]
        cell.nameDish.text = dish.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            let dish = dishes[indexPath.row]
            let updateVC = UpdateDishViewController(dish: dish)
            updateVC.delegate = self
            updateVC.modalTransitionStyle = .coverVertical
            updateVC.modalPresentationStyle = .overCurrentContext
            present(updateVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let dish = dishes[indexPath.row]
            if repository.delete(a: dish){
                dishes.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        }
    }
}

extension DishesViewController : AddDishViewControllerDelegate{
    func addDishViewController(_ vc: AddDishViewController, didEditDish: Dish) {
        vc.dismiss(animated: true){
            self.dishes = self.repository.getAll()
            self.tableView.reloadData()
        }
    }
    
    func errorAddDishViewController(_ vc: AddDishViewController) {
        vc.dismiss(animated: true, completion: nil)
        let alert = UIAlertController(title: "ERROR", message: "Esta repetido o vacio el nombre", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension DishesViewController: UpdateDishViewControllerDelegate {
    func updateDishViewController(_ vc: UpdateDishViewController, didEditDish dish: Dish) {
        vc.dismiss(animated: true){
            self.dishes = self.repository.getAll()
            self.tableView.reloadData()
        }
    }
    
    func errorUpdateDishViewController(_ vc: UpdateDishViewController) {
        vc.dismiss(animated: true, completion: nil)
        let alert = UIAlertController(title: "ERROR", message: "Esta repetido o vacio el nombre", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension DishesViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
