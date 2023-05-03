import Vapor
import OpenAIKit
import Foundation
import AsyncHTTPClient
import NIO
import NIOHTTP1
import NIOFoundationCompat

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("image") { req -> ImagesData in
        guard
            let prompt: String = req.query["prompt"]
        else {
            throw Abort(.badRequest)
        }
        let count: Int = req.query["count"] ?? 1
        let size: String = req.query["size"] ?? "1024x1024"
        print("xxxxxx", Date().timeIntervalSince1970)
        let urls = try await OpenAIClient.requestForImage(
            prompt: prompt,
            count: count,
            size: size
        ).data.map { $0.url }
        print("xxxxxx", Date().timeIntervalSince1970)
        var datas: [Data] = []
        let httpClient = HTTPClient(eventLoopGroupProvider: .createNew)
        for url in urls {
            let request = try HTTPClient.Request(url: url)
            let response = try await httpClient.execute(request: request).get()
            if let byteBuffer = response.body {
                datas.append(Data(buffer: byteBuffer))
            }
        }
        defer {
            try? httpClient.syncShutdown()
        }
        print("xxxxxx", Date().timeIntervalSince1970)
        return ImagesData(datas: datas)
    }
}
