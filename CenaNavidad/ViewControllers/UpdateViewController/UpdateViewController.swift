//
//  UpdateViewController.swift
//  CenaNavidad
//
//  Created by David gimenez on 6/1/19.
//  Copyright © 2019 David gimenez. All rights reserved.
//

import UIKit

protocol UpdateViewControllerDelegate: class {
    func updateViewController(_ vc: UpdateViewController, didEditParticipant participant: Participant)
}

class UpdateViewController: UIViewController {
    
    @IBOutlet weak var viewpop: UIView!
    @IBOutlet weak var idParticipant: UILabel!
    @IBOutlet weak var nameParticipant: UITextField!
    @IBOutlet weak var isPaid: UISwitch!
    internal var repository: LocalParticipantRepository!
    weak var delegate: UpdateViewControllerDelegate?
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idParticipant.text = participant.id
        nameParticipant.text = participant.name
        isPaid.isOn = participant.isPaid
        viewpop.layer.cornerRadius = 8
        viewpop.layer.masksToBounds = true
        repository = LocalParticipantRepository()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /*
        Actualizo el nombre y el estado de si a pagado el participante o no. Normalmente el nombre no se deberia actualizar y se deberia solo mostrar.
     */
    @IBAction func updateButtonRessed() {
            participant.id = idParticipant.text!
            participant.name = nameParticipant.text!
            participant.isPaid = isPaid.isOn
            participant.creationDate = Date()
            UIView.animate(withDuration: 0.25, animations: {
                self.view.backgroundColor = UIColor.clear
            }) { (bool) in
                if self.repository.update(a: self.participant){
                    self.delegate?.updateViewController(self, didEditParticipant: self.participant)
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
