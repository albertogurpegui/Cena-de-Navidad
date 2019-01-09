//
//  AddViewController.swift
//  CenaNavidad
//
//  Created by David gimenez on 6/1/19.
//  Copyright © 2019 David gimenez. All rights reserved.
//

import UIKit

protocol AddViewControllerDelegate: class {
    func addViewController(_ vc: AddViewController, didEditParticipant participant: Participant)
    func errorAddViewController(_ vc:AddViewController)
}

class AddViewController: UIViewController {
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var nameParticipant: UITextField!
    internal var repository: LocalParticipantRepository!
    weak var delegate: AddViewControllerDelegate?
    
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
        if (repository.get(name: nameParticipant.text!) != nil) ||
            (nameParticipant.text?.elementsEqual(""))! {
            self.delegate?.errorAddViewController(self)
        }else{
            let participant = Participant()
            participant.id = UUID().uuidString
            participant.name = nameParticipant.text!
            participant.creationDate = Date()
            participant.isPaid = false
            UIView.animate(withDuration: 0.25, animations: {
                self.view.backgroundColor = UIColor.clear
            }) { (bool) in
                if self.repository.create(a: participant){
                    self.delegate?.addViewController(self, didEditParticipant: participant)
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

