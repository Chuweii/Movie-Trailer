//
//  DatabaseError.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/29.
//

import Foundation

enum DatabaseError:Error {
    case failedToSaveData
    case failedToFetchData
    case failedToFindData
    case failedToGetAppDelegate
}
