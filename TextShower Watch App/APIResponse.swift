import Foundation

struct APIResponse: Decodable {
    var text: String
    var emoji: String
    var createdAt: String
    var creator: String
}

struct APIReply: Decodable {
    var message: String
}
