//
//  AddDishViewController.swift
//  CenaNavidad
//
//  Created by ALBERTO GURPEGUI RAMÓN on 10/1/19.
//  Copyright © 2019 David gimenez. All rights reserved.
//

import UIKit

protocol AddDishViewControllerDelegate: class {
    func addDishViewController(_ vc: AddDishViewController, didEditDish dish: Dish)
    func errorAddDishViewController(_ vc:AddDishViewController)
}

class AddDishViewController: UIViewController {
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var name: UITextField!
    internal var repository: LocalDishRepository!
    weak var delegate: AddDishViewControllerDelegate?
    
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
        repository = LocalDishRepository()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func createButtonPressed() {
        if (repository.get(name: name.text!) != nil) ||
            (name.text?.elementsEqual(""))! {
            self.delegate?.errorAddDishViewController(self)
        }else{
            let dish = Dish()
            dish.id = UUID().uuidString
            dish.name = name.text!
            UIView.animate(withDuration: 0.25, animations: {
                self.view.backgroundColor = UIColor.clear
            }) { (bool) in
                if self.repository.create(a: dish){
                    self.delegate?.addDishViewController(self, didEditDish: dish)
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
