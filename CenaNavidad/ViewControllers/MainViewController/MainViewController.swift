//
//  MainViewController.swift
//  CenaNavidad
//
//  Created by Alberto gurpegui on 3/1/19.
//  Copyright © 2019 Alberto gurpegui. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    internal  var repository:LocalParticipantRepository!
    internal var participants:[Participant] = []
    internal var filteredParticipants: [Participant] = []
    let searchController = UISearchController(searchResultsController: nil)
    let realm = try! Realm()
    var participant:Participant?
    
    init(){
        super.init(nibName: "MainViewController", bundle: nil)
        self.title = NSLocalizedString("PARTICIPANTES", comment: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        participants = repository.getAll()
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()

        repository = LocalParticipantRepository()
        participants = repository.getAll()
        print("lol")
        createButtonDish()
        createButtonAdd()
        configSearchBar()
    }
    
    internal func registerCell(){
        let identifier = "ParticipantTableViewCell"
        let cellNib = UINib(nibName: identifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: identifier)
    }
    
    internal func createButtonAdd(){
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
        navigationItem.rightBarButtonItem = addButtonItem
    }
    internal func createButtonDish(){
        let dishButtonItem = UIBarButtonItem(title: "Dishes", style: .plain, target: self, action: #selector(dishPressed))
        navigationItem.setLeftBarButton(dishButtonItem, animated: false)
    }
    
    @objc internal func addPressed (){
        let addVC = AddParticipantViewController()
        addVC.delegate = self
        addVC.modalTransitionStyle = .coverVertical
        addVC.modalPresentationStyle = .overCurrentContext
        present(addVC,animated: true,completion: nil)
    }
    
    @objc internal func dishPressed (){
        let dishVC = DishesViewController()
        dishVC.modalTransitionStyle = .coverVertical
        dishVC.modalPresentationStyle = .overCurrentContext
        navigationController?.pushViewController(dishVC, animated: true)
        //present(dishVC,animated: true,completion: nil)
    }
    
    internal func configSearchBar(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Escribe 'Moroso' o Busca Nombre..."
        searchController.searchBar.backgroundColor = UIColor.white
        navigationItem.searchController = searchController
    }
    
    internal func searchBarIsEmpty() -> Bool{
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    internal func isFiltering() -> Bool{
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    internal func filterContentForSearchText(_ searchText: String){
        if !searchText.elementsEqual("Moroso"){
            filteredParticipants = participants.filter({ (nParticipants: Participant ) -> Bool in
                return (nParticipants.name.lowercased().contains(searchText.lowercased()))
            })
            tableView.reloadData()
        }else{
            filteredParticipants = participants.filter({ (nParticipants: Participant ) -> Bool in
                return !(nParticipants.paid)
            })
            tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MainViewController: UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering(){
            return filteredParticipants.count
        }else{
            return participants.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ParticipantTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ParticipantTableViewCell", for: indexPath) as! ParticipantTableViewCell
        if isFiltering(){
            let participant = filteredParticipants[indexPath.row]
            cell.nameParticipant.text = participant.name
            cell.checkimagenPaid.isHidden = !participant.paid
        }else{
            let participant = participants[indexPath.row]
            cell.nameParticipant.text = participant.name
            cell.checkimagenPaid.isHidden = !participant.paid
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFiltering(){
            let participant = filteredParticipants[indexPath.row]
            let updateVC = UpdateParticipantViewController(participant: participant)
            updateVC.delegate = self
            updateVC.modalTransitionStyle = .coverVertical
            updateVC.modalPresentationStyle = .overCurrentContext
            searchController.dismiss(animated: true, completion: nil)
            present(updateVC, animated: true, completion: nil)
        }else{
            let participant = participants[indexPath.row]
            let updateVC = UpdateParticipantViewController(participant: participant)
            updateVC.delegate = self
            updateVC.modalTransitionStyle = .coverVertical
            updateVC.modalPresentationStyle = .overCurrentContext
            searchController.dismiss(animated: true, completion: nil)
            present(updateVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if isFiltering(){
                let participant = filteredParticipants[indexPath.row]
                if repository.delete(a: participant){
                    participants.remove(at: indexPath.row)
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                }
            }else{
                let participant = participants[indexPath.row]
                if repository.delete(a: participant){
                    participants.remove(at: indexPath.row)
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                }
            }
        }
    }
}

extension MainViewController : AddParticipantViewControllerDelegate{
    func addParticipantViewController(_ vc: AddParticipantViewController, didEditParticipant: Participant) {
        vc.dismiss(animated: true){
                self.participants = self.repository.getAll()
                self.tableView.reloadData()
        }
    }
    
    func errorAddParticipantViewController(_ vc: AddParticipantViewController) {
        vc.dismiss(animated: true, completion: nil)
        let alert = UIAlertController(title: "ERROR", message: "Esta repetido o vacio el nombre", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: UpdateParticipantViewControllerDelegate {
    func updateParticipantViewController(_ vc: UpdateParticipantViewController, didEditParticipant participant: Participant) {
        vc.dismiss(animated: true){
            self.participants = self.repository.getAll()
            self.tableView.reloadData()
        }
    }
    
    func errorUpdateParticipantViewController(_ vc: UpdateParticipantViewController) {
        vc.dismiss(animated: true, completion: nil)
        let alert = UIAlertController(title: "ERROR", message: "Esta repetido o vacio el nombre", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
