//
//  AddViewController.swift
//  CenaNavidad
//
//  Created by Alberto gurpegui on 3/1/19.
//  Copyright © 2019 Alberto gurpegui. All rights reserved.
//

import UIKit

protocol AddViewControllerDelegate: class {
    func addViewController(_ vc: AddViewController, didEditParticipant participant: Participant)
    func errorAddViewController(_ vc:AddViewController)
}

class AddViewController: UIViewController {
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var name: UITextField!
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
        if (repository.get(name: name.text!) != nil) ||
            (name.text?.elementsEqual(""))! {
            self.delegate?.errorAddViewController(self)
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

