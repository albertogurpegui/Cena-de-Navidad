//
//  UpdateDishViewController.swift
//  CenaNavidad
//
//  Created by ALBERTO GURPEGUI RAMÓN on 10/1/19.
//  Copyright © 2019 David gimenez. All rights reserved.
//

import UIKit

protocol UpdateDishViewControllerDelegate: class {
    func updateDishViewController(_ vc: UpdateDishViewController, didEditDish dish: Dish)
    func errorUpdateDishViewController(_ vc:UpdateDishViewController)
}

class UpdateDishViewController: UIViewController {
    
    @IBOutlet weak var viewpop: UIView!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var name: UITextField!
    internal var repository: LocalDishRepository!
    weak var delegate: UpdateDishViewControllerDelegate?
    var dish = Dish()
    
    convenience init(dish: Dish){
        self.init()
        self.dish = dish
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25){
            self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.75)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        id.text = dish.id
        name.text = dish.name
        viewpop.layer.cornerRadius = 8
        viewpop.layer.masksToBounds = true
        repository = LocalDishRepository()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func updateButtonRessed() {
        if (repository.getCount(name: name.text!)! > 1) || (repository.get(identifier: dish.id)?.name != name.text!) || (name.text?.elementsEqual(""))! {
            self.delegate?.errorUpdateDishViewController(self)
        }else{
            dish.id = id.text!
            dish.name = name.text!
            UIView.animate(withDuration: 0.25, animations: {
                self.view.backgroundColor = UIColor.clear
            }) { (bool) in
                if self.repository.update(a: self.dish){
                    self.delegate?.updateDishViewController(self, didEditDish: self.dish)
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

