//
//  LocalParticipantRepository.swift
//  CenaNavidad
//
//  Created by Alberto gurpegui on 6/1/19.
//  Copyright © 2019 Alberto gurpegui. All rights reserved.
//

import Foundation
import RealmSwift

class LocalParticipantRepository: Repository {
    
    func getAll() -> [Participant] {
        var participants: [Participant] = []
        do {
            let entities = try Realm().objects(ParticipantEntity.self).sorted(byKeyPath: "creationDate", ascending: false)
            for entity in entities {
                let model = entity.participantModel()
                participants.append(model)
            }
        }
        catch let error as NSError {
            print("ERROR getAll Participants: ", error.description)
        }
        return participants
    }
    
    func get(identifier: String) -> Participant? {
        do{
            let realm = try Realm()
            if let entity = realm.objects(ParticipantEntity.self).filter("id == %@", identifier).first{
                let model = entity.participantModel()
                return model
            }
        }
        catch {
            return nil
        }
        return nil
    }
    
    func get(name: String) -> Participant? {
        do{
            let realm = try Realm()
            if let entity = realm.objects(ParticipantEntity.self).filter("name == %@", name).first{
                let model = entity.participantModel()
                return model
            }
        }
        catch {
            return nil
        }
        return nil
    }
    
    func create(a: Participant) -> Bool {
        do{
            let realm = try Realm()
            let entity = ParticipantEntity(participant: a)
            try realm.write{
                realm.add(entity,update: true)
            }
        }
        catch{
            return false
        }
        return true
    }
    
    func delete(a: Participant) -> Bool {
        do{
            let realm = try Realm()
            try realm.write {
                let entityToDelete = realm.objects(ParticipantEntity.self).filter("id == %@", a.id)
                realm.delete(entityToDelete)
            }
        }
        catch{
            return false
        }
        return true
    }
    
    func update(a: Participant) -> Bool {
        return create(a:a)
    }
}
