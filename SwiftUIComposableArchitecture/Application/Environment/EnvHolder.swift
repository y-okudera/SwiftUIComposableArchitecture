//
//  EnvHolder.swift
//  SwiftUIComposableArchitecture
//
//  Created by okudera on 2021/09/13.
//

import Foundation

struct EnvHolder: Decodable {
    let environment: Env

    enum CodingKeys: String, CodingKey {
        case environment = "Env"
    }
}
