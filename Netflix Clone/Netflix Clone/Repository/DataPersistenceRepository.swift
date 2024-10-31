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
    func downloadMovieWithTitle(model: Movie) async throws
    func fetchMovies() async throws -> [Movie]
    func deleteMovieWithTitle(with title: Movie) async throws
}
 
class DataPersistenceRepository: DataPersistenceRepositoryProtocol {
    // MARK: - Properties
    
    private var appDelegate: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return AppDelegate() }
        return appDelegate
    }
    private lazy var context = appDelegate.persistentContainer.viewContext

    // MARK: - Methods
    
    @MainActor
    func downloadMovieWithTitle(model: Movie) async throws {
        _ = TitleItem(context: context, title: model)
        
        do {
            try context.save()
        } 
        catch {
            throw DatabaseError.failedToSaveData
        }
    }
    
    @MainActor
    func fetchMovies() async throws -> [Movie] {
        let request: NSFetchRequest<TitleItem> = TitleItem.fetchRequest()
        
        do {
            let titleItems = try context.fetch(request)
            let titles = titleItems.map { Movie(movieItem: $0) }
            return titles
        } 
        catch {
            throw DatabaseError.failedToFetchData
        }
    }
    
    @MainActor
    func deleteMovieWithTitle(with title: Movie) async throws {
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
