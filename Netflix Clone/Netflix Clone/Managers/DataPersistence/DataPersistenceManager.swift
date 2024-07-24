//
//  DataPersistenceManager.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2022/10/25.
//

import Foundation
import UIKit
import CoreData

enum DatabaseError:Error {
    case failedToSaveData
    case failedToFetchData
    case failedToFindData
    case failedToGetAppDelegate
}

class DataPersistenceManager{
    
    static let shared = DataPersistenceManager()
    
    func downloadTitleWith(model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(.failure(DatabaseError.failedToGetAppDelegate))
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        _ = TitleItem(context: context, title: model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    
    func fetchingTitleFromDataBase(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<TitleItem> = TitleItem.fetchRequest()
        
        do {
            let titleItems = try context.fetch(request)
            let titles = titleItems.map { Title(titleItem: $0) }
            completion(.success(titles))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    func deleteTitle(with title: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<TitleItem> = TitleItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", title.id)
        
        do {
            let items = try context.fetch(request)
            if let item = items.first {
                context.delete(item)
                try context.save()
                completion(.success(()))
            } else {
                completion(.failure(DatabaseError.failedToFindData))
            }
        } catch {
            completion(.failure(DatabaseError.failedToFindData))
        }
    }
}
