import Vapor
import OpenAIKit

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("image") { req -> AIImage in
        guard
            let prompt: String = req.query["prompt"]
        else {
            throw Abort(.badRequest)
        }
        let count: Int = req.query["count"] ?? 1
        let height: Int = req.query["height"] ?? 1024
        let width: Int = req.query["width"] ?? 1024
        return try await OpenAIClient.requestForImage(
            prompt: prompt,
            count: count,
            height: height,
            width: width
        )
    }
}
