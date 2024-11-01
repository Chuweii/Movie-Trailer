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
    func downloadMovie(movie: Movie) async throws
    func fetchMovies() async throws -> [Movie]
    func deleteMovie(with movie: Movie) async throws
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
    func downloadMovie(movie: Movie) async throws {
        _ = MovieItem(context: context, movie: movie)
        
        do {
            try context.save()
        } 
        catch {
            throw DatabaseError.failedToSaveData
        }
    }
    
    @MainActor
    func fetchMovies() async throws -> [Movie] {
        let request: NSFetchRequest<MovieItem> = MovieItem.fetchRequest()
        
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
    func deleteMovie(with title: Movie) async throws {
        let request: NSFetchRequest<MovieItem> = MovieItem.fetchRequest()
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
