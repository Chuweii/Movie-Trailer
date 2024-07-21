//
//  CustomError.swift
//  Netflix Clone
//
//  Created by Wei Chu on 2024/7/20.
//

import Foundation
import Moya

enum CustomResponseType {
    case objectMappingError
    case decodingError
}

extension CustomResponseType {
    var response: Response {
        switch self {
        default:
            Response(statusCode: 499, data: Data())
        }
    }
}
