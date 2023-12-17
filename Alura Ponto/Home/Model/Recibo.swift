//
//  Recibo.swift
//  Alura Ponto
//
//  Created by Ândriu Felipe Coelho on 29/09/21.
//
import CoreData
import Foundation
import UIKit

@objc(Recibo    )
class Recibo: NSManagedObject {
    
    @NSManaged var id: UUID
    @NSManaged var status: Bool
    @NSManaged var data: Date
    @NSManaged var foto: UIImage
    
    convenience init(status: Bool, data: Date, foto: UIImage) {
        let context = UIApplication.shared.delegate as! AppDelegate
        self.init(context: context.persistentContainer.viewContext)
        self.id = UUID()
        self.status = status
        self.data = data
        self.foto = foto
    }
}

extension Recibo {
    // MARK - Core data - DAO
    
    func save(_ context: NSManagedObjectContext) {
        do {
            try context.save()
         
        } catch {
            print(error)
   
        }
    }
    
    class func fetchRequest() -> NSFetchRequest<Recibo> {
        return NSFetchRequest(entityName: "Recibo")
    }
    
    class func load(_ fetchResultController: NSFetchedResultsController<Recibo>) {
        do {
            try fetchResultController.performFetch()
        } catch {
        }
        
        
    }
    
    func delete(_ context: NSManagedObjectContext) {
        context.delete(self)
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    
}
