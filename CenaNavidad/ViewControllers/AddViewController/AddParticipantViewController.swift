//
//  AddViewController.swift
//  CenaNavidad
//
//  Created by Alberto gurpegui on 3/1/19.
//  Copyright © 2019 Alberto gurpegui. All rights reserved.
//

import UIKit

protocol AddParticipantViewControllerDelegate: class {
    func addParticipantViewController(_ vc: AddParticipantViewController, didEditParticipant participant: Participant)
    func errorAddParticipantViewController(_ vc:AddParticipantViewController)
}

class AddParticipantViewController: UIViewController {
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var name: UITextField!
    internal var repository: LocalParticipantRepository!
    weak var delegate: AddParticipantViewControllerDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25){
            self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.75)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPopup.layer.cornerRadius = 8
        viewPopup.layer.masksToBounds = true
        repository = LocalParticipantRepository()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func createButtonPressed() {
        if (repository.get(name: name.text!) != nil) ||
            (name.text?.elementsEqual(""))! {
            self.delegate?.errorAddParticipantViewController(self)
        }else{
            let participant = Participant()
            participant.id = UUID().uuidString
            participant.name = name.text!
            participant.paid = false
            participant.creationDate = Date()
            UIView.animate(withDuration: 0.25, animations: {
                self.view.backgroundColor = UIColor.clear
            }) { (bool) in
                if self.repository.create(a: participant){
                    self.delegate?.addParticipantViewController(self, didEditParticipant: participant)
                }
            }
        }

    }
    
    @IBAction func cancelButtonPressed() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.backgroundColor = UIColor.clear
        }) { (bool) in
            self.dismiss(animated: true)
        }
    }
}

