//
//  ApiRouter.swift
//  SwiftUIComposableArchitecture
//
//  Created by Yuki Okudera on 2021/09/11.
//

import Foundation

enum ApiRouter {
    static func request(for route: ApiRoute) -> URLRequest {
        var request = URLRequest(url: route.url)
        request.httpMethod = route.httpMethod
        return request
    }

    static func url(for route: ApiRoute) -> URL {
        route.url
    }
}
