//
//  NetworkError.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/20.
//

import Foundation
import Moya

enum NetworkError: Error {
    case moyaError(MoyaError)
    case customError(CustomResponseType)
}
