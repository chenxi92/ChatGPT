//
//  Language.swift
//  ChatGPT
//
//  Created by 陈希 on 2023/2/18.
//

import Foundation

enum Language: CaseIterable, Identifiable {

    case en
    case zh
    
    var id: String {
        self.tag
    }
    
    var name: String {
        switch self {
        case .en:
            return "English"
        case .zh:
            return "中文"
        }
    }
    
    var tag: String {
        switch self {
        case .en:
            return "en-US"
        case .zh:
            return "zh-CN"
        }
    }
}
