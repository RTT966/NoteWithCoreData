//
//  CoreDataManager.swift
//  MyNotes
//
//  Created by Рустам Т on 6/6/23.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager(modelName: "MyNotes")
    
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String){
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (()->Void)? = nil){
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else { fatalError("fatal error in pers cont")}
            completion?()
        }
    }
    
    //MARK: - create new note
    func createNewNote()-> Note {
        let note = Note(context: viewContext)
        note.id = UUID()
        note.lastUpdated = Date()
        note.text = ""
        save()
        return note
    }
    
    //MARK: - delete
    func delete(_ note: Note){
        viewContext.delete(note)
        save()
    }
    
    //MARK: - fetch func
    func fetch(filer: String? = nil)-> [Note]{
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Note.lastUpdated, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        if let filer{
            let predicate = NSPredicate(format: "text contains [cd] %@", filer)
            request.predicate = predicate
        }
    
        return (try? viewContext.fetch(request)) ?? []
    }
    
    //MARK: - save func
    func save(){
        if viewContext.hasChanges{
            do{
               try viewContext.save()
            }catch{
                print("error while saving in core data")
            }
        }
    }
}
