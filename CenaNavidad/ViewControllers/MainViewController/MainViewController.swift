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
    
    @objc internal func addPressed (){
        let addVC = AddViewController()
        addVC.delegate = self
        addVC.modalTransitionStyle = .coverVertical
        addVC.modalPresentationStyle = .overCurrentContext
        present(addVC,animated: true,completion: nil)
    }
    
    internal func configSearchBar(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar..."
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
        filteredParticipants = participants.filter({ (nParticipants: Participant ) -> Bool in
            return (nParticipants.name.lowercased().contains(searchText.lowercased()))
        })
        tableView.reloadData()
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
            let updateVC = UpdateViewController(participant: participant)
            updateVC.delegate = self
            updateVC.modalTransitionStyle = .coverVertical
            updateVC.modalPresentationStyle = .overCurrentContext
            searchController.dismiss(animated: true, completion: nil)
            present(updateVC, animated: true, completion: nil)
        }else{
            let participant = participants[indexPath.row]
            let updateVC = UpdateViewController(participant: participant)
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

extension MainViewController : AddViewControllerDelegate{
    func addViewController(_ vc: AddViewController, didEditParticipant: Participant) {
        vc.dismiss(animated: true){
                self.participants = self.repository.getAll()
                self.tableView.reloadData()
        }
    }
    
    func errorAddViewController(_ vc: AddViewController) {
        vc.dismiss(animated: true, completion: nil)
        print("Error, no se pudo añadir, por que esta repetido o por que esta vacio.")
    }
}

extension MainViewController: UpdateViewControllerDelegate {
    func updateViewController(_ vc: UpdateViewController, didEditParticipant participant: Participant) {
        vc.dismiss(animated: true){
            self.participants = self.repository.getAll()
            self.tableView.reloadData()
        }
    }
    
    func errorUpdateViewController(_ vc: UpdateViewController) {
        vc.dismiss(animated: true, completion: nil)
        print("Error, no se pudo añadir, por que esta repetido o por que esta vacio.")
    }
}

extension MainViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
