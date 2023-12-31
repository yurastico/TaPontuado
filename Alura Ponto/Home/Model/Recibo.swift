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
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    
    convenience init(id: UUID? = UUID(),status: Bool, data: Date, foto: UIImage, latidude: Double,longitude: Double) {
        let context = UIApplication.shared.delegate as! AppDelegate
        self.init(context: context.persistentContainer.viewContext)
        self.id = id ?? UUID()
        self.status = status
        self.data = data
        self.foto = foto
        self.latitude = latidude
        self.longitude = longitude
    }
    
    class func serialize(_ json: [String: Any]) -> Recibo? {
        guard let dateString = json["data"] as? String,
              let date = FormatadorDeData().getDate(dateString),
              let status = json["status"] as? Bool else { return nil}
        
        guard let id = json["id"] as? String, let uuid = UUID(uuidString: id) else { return nil }
        
        guard let localization = json["localizacao"] as? [String: Any] else { return nil}
        let latitude = localization["latitude"] as? Double ?? 0.0
        let longitude = localization["longitude"] as? Double ?? 0.0
        
        let receipt = Recibo(id: uuid, status: status, data: date, foto: UIImage(), latidude: latitude, longitude: longitude)
        
        return receipt
        
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
