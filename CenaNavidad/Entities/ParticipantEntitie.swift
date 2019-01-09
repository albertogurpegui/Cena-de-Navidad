//
//  ParticipantEntitie.swift
//  CenaNavidad
//
//  Created by David gimenez on 6/1/19.
//  Copyright © 2019 David gimenez. All rights reserved.
//

import UIKit
import RealmSwift

class ParticipantEntitie: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var creationDate = Date()
    @objc dynamic var isPaid = false
    
    
    override static func primaryKey() -> String?{
        return "id"
    }
    
    convenience init(participant: Participant) {
        self.init()
        self.id = participant.id
        self.name = participant.name
        self.creationDate = participant.creationDate
        self.isPaid = participant.isPaid
    }
    
    func participantModel() -> Participant {
        let model = Participant()
        model.id = id
        model.name = name
        model.creationDate = creationDate
        model.isPaid = isPaid
        return model
    }

}
