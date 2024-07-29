//
//  DataPersistenceManager.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/10/25.
//

import Foundation
import UIKit
import CoreData

protocol DataPersistenceRepositoryProtocol {
    func downloadTitleWith(model: Title) async throws
    func fetchingTitleFromDataBase() async throws -> [Title]
    func deleteTitle(with title: Title) async throws
}
 
class DataPersistenceRepository: DataPersistenceRepositoryProtocol {    
    @MainActor
    func downloadTitleWith(model: Title) async throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw DatabaseError.failedToGetAppDelegate
        }
        let context = appDelegate.persistentContainer.viewContext
        _ = TitleItem(context: context, title: model)
        
        do {
            try context.save()
        } 
        catch {
            throw DatabaseError.failedToSaveData
        }
    }
    
    @MainActor
    func fetchingTitleFromDataBase() async throws -> [Title] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw DatabaseError.failedToGetAppDelegate
        }
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<TitleItem> = TitleItem.fetchRequest()
        
        do {
            let titleItems = try context.fetch(request)
            let titles = titleItems.map { Title(titleItem: $0) }
            return titles
        } 
        catch {
            throw DatabaseError.failedToFetchData
        }
    }
    
    @MainActor
    func deleteTitle(with title: Title) async throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw DatabaseError.failedToGetAppDelegate
        }
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<TitleItem> = TitleItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", title.id)
        
        do {
            let items = try context.fetch(request)
            if let item = items.first {
                context.delete(item)
                try context.save()
            } else {
                throw DatabaseError.failedToFindData
            }
        } 
        catch {
            throw DatabaseError.failedToFindData
        }
    }
}
