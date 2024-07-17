//
//  Core Data Helper.swift
//  contactsApp3
//
//  Created by t2023-m0119 on 7/17/24.
//
//
//import Foundation
//import CoreData
//import UIKit
//
//class CoreDataHelper {
//    
//    static let shared = CoreDataHelper()
//    
//    let persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "ContactModel")
//        container.loadPersistentStores { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        }
//        return container
//    }()
//    
//    func saveContext() {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
//    
//    func saveContact(name: String, phoneNumber: String, profileImageData: Data?) {
//        let context = persistentContainer.viewContext
//        let contact = ContactEntity(context: context)
//        contact.name = name
//        contact.phoneNumber = phoneNumber
//        contact.profileImageData = profileImageData
//        saveContext()
//    }
//    
//    func fetchContacts() -> [ContactEntity] {
//        let context = persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<ContactEntity> = ContactEntity.fetchRequest()
//        
//        do {
//            return try context.fetch(fetchRequest)
//        } catch {
//            print("Fetch failed")
//            return []
//        }
//    }
//}
