//
//  UpdateViewController.swift
//  CenaNavidad
//
//  Created by Alberto gurpegui on 3/1/19.
//  Copyright © 2019 Alberto gurpegui. All rights reserved.
//

import UIKit

protocol UpdateParticipantViewControllerDelegate: class {
    func updateParticipantViewController(_ vc: UpdateParticipantViewController, didEditParticipant participant: Participant)
    func errorUpdateParticipantViewController(_ vc:UpdateParticipantViewController)
}

class UpdateParticipantViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewpop: UIView!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var paid: UISwitch!
    internal  var dishRepository:LocalDishRepository!
    internal var dishes: [Dish] = []
    internal var favourites: [Dish] = []
    internal var repository: LocalParticipantRepository!
    weak var delegate: UpdateParticipantViewControllerDelegate?
    var participant = Participant()
    
    convenience init(participant: Participant){
        self.init()
        self.participant = participant
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25){
            self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.75)
        }
        dishes = dishRepository.getAll()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        id.text = participant.id
        name.text = participant.name
        paid.isOn = participant.paid
        viewpop.layer.cornerRadius = 8
        viewpop.layer.masksToBounds = true
        registerCell()
        tableView?.allowsMultipleSelection = true
        repository = LocalParticipantRepository()
        dishRepository = LocalDishRepository()
        dishes = dishRepository.getAll()
    }
    
    internal func registerCell(){
        let identifier = "DishTableViewCell"
        let cellNib = UINib(nibName: identifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: identifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func updateButtonRessed() {
        //Me ayudo Pablo Cruz con esto se lo agradezco mucho <3Repositories
        if (repository.getCount(name: name.text!)! > 1) || (repository.get(identifier: participant.id)?.name != name.text!) || (name.text?.elementsEqual(""))!{
            self.delegate?.errorUpdateParticipantViewController(self)
        }else{
            participant.id = id.text!
            participant.name = name.text!
            participant.paid = paid.isOn
            participant.creationDate = Date()
            participant.dishes = favourites
            if self.repository.update(a: self.participant){
                self.delegate?.updateParticipantViewController(self, didEditParticipant: self.participant)
            };            UIView.animate(withDuration: 0.25, animations: {
                self.view.backgroundColor = UIColor.clear
            }) { (bool) in

            }
        }
    }
    
    @IBAction func cancelButtonRessed() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.backgroundColor = UIColor.clear
        }) { (bool) in
            self.dismiss(animated: true)
        }
    }

}
extension UpdateParticipantViewController: UITableViewDelegate ,UITableViewDataSource{
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
            favourites.insert(dishes[indexPath.row], at: indexPath.row)

    }
}

