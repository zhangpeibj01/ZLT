//
//  OpenAIClient.swift
//  
//
//  Created by zhangpeibj01 on 2023/4/23.
//

import Foundation
import OpenAIKit
import Vapor

public class OpenAIClient {
    public static func requestForImage(prompt: String, count: Int, height: Int, width: Int) async throws -> AIImage {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

        let httpClient = HTTPClient(eventLoopGroupProvider: .shared(eventLoopGroup))

        defer {
            try? httpClient.syncShutdown()
        }

        let configuration = Configuration(apiKey: "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")
        let openAIClient = OpenAIKit.Client(httpClient: httpClient, configuration: configuration)
        let image = try await openAIClient.images.create(prompt: "Tiger Woods eating soup")
        return .init(data: image.data.map { .init(url: $0.url) })
    }
}

public struct AIImage: Codable, Content {
    public let data: [ImageData]

    public struct ImageData: Codable {
        public let url: String
    }
}
