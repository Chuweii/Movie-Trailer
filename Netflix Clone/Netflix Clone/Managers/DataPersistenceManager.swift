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
    case failedToDeletData
}

class DataPersistenceManager{
    
    static let shared = DataPersistenceManager()
    
    //MARK: 將影片title資訊存到data persistent
    func downloadTitleWith(model :Title, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.original_name = model.original_name
        item.media_type = model.media_type
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average
        
        do{
            try context.save()
            completion(.success(()))
        }
        catch{
            completion(.failure(DatabaseError.failedToSaveData))
        }
        
    }
    
    
    func fetchingTitleFromDataBase(completion: @escaping (Result<[TitleItem], Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request:NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        
        do{
            let titles = try context.fetch(request)
            completion(.success(titles))
        }
        catch{
            completion(.failure(DatabaseError.failedToFetchData))
        }
        
    }
    
    func deletTitleWith(model:TitleItem, completion: @escaping (Result<Void, Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model) //asking the database manager to delet certain object
        
        do{
            try context.save()
            completion(.success(()))
        }
        catch{
            completion(.failure(DatabaseError.failedToDeletData))
        }
    }
    
}
