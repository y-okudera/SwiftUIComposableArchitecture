//
//  EnvDecoder.swift
//  SwiftUIComposableArchitecture
//
//  Created by okudera on 2021/09/13.
//

import Foundation

enum EnvDecoder {
    static func decode() -> Env {
        guard let url = Bundle.main.url(forResource: "Info", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let environmentHolder = try? PropertyListDecoder().decode(EnvHolder.self, from: data) else {
            fatalError("Environment variables decoding failed.")
        }
        return environmentHolder.environment
    }
}
