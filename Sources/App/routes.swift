import Vapor
import OpenAIKit

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
        let datas = urls.compactMap { url in
            do {
                return (try Data(contentsOf: URL(string: url)!))
            } catch {
                print("xxxxxx\(error)")
            }
            return nil
        }
        print("xxxxxx", Date().timeIntervalSince1970)
        return ImagesData(datas: datas)
    }
}
