//
//  APIChatMessage.swift
//  Habitica API Client
//
//  Created by Phillip Thelen on 29.03.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import Foundation
import Habitica_Models

public class APIChatMessage: ChatMessageProtocol, Codable {
    public var id: String?
    public var userID: String?
    public var text: String?
    public var attributedText: NSAttributedString?
    public var timestamp: Date?
    public var username: String?
    public var flagCount: Int
    public var contributor: ContributorProtocol?
    public var userStyles: UserStyleProtocol?
    public var likes: [ChatMessageReactionProtocol]
    public var flags: [ChatMessageReactionProtocol]
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "uuid"
        case text
        case timestamp
        case username = "user"
        case flagCount
        case contributor
        case userStyles
        case likes
        case flags
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String.self, forKey: .id)
        userID = try? values.decode(String.self, forKey: .userID)
        text = try? values.decode(String.self, forKey: .text)
        if let timeStampNumber = try? values.decode(Double.self, forKey: .timestamp) {
            timestamp = Date(timeIntervalSince1970: timeStampNumber/1000)
        }
        username = try? values.decode(String.self, forKey: .username)
        flagCount = (try? values.decode(Int.self, forKey: .flagCount)) ?? 0
        contributor = (try? values.decode(APIContributor.self, forKey: .contributor))
        if values.contains(.userStyles) {
            userStyles = try! values.decode(APIUserStyle.self, forKey: .userStyles)
        }
        likes = APIChatMessageReaction.fromList(try values.decode([String: Bool].self, forKey: .likes))
        flags = APIChatMessageReaction.fromList(try values.decode([String: Bool].self, forKey: .flags))
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }
}
