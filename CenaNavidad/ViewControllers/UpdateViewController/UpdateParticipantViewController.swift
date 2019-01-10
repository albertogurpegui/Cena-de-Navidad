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
    
    @IBOutlet weak var viewpop: UIView!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var paid: UISwitch!
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        id.text = participant.id
        name.text = participant.name
        paid.isOn = participant.paid
        viewpop.layer.cornerRadius = 8
        viewpop.layer.masksToBounds = true
        repository = LocalParticipantRepository()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func updateButtonRessed() {
        if (repository.get(name: participant.name)?.name != name.text) || (repository.get(identifier: participant.id)?.id != id.text) || (name.text?.elementsEqual(""))! {
            self.delegate?.errorUpdateParticipantViewController(self)
        }else{
            participant.id = id.text!
            participant.name = name.text!
            participant.paid = paid.isOn
            participant.creationDate = Date()
            UIView.animate(withDuration: 0.25, animations: {
                self.view.backgroundColor = UIColor.clear
            }) { (bool) in
                if self.repository.update(a: self.participant){
                    self.delegate?.updateParticipantViewController(self, didEditParticipant: self.participant)
                }
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