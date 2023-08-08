//
//  Story.swift
//  InifiniteScroll
//
//  Created by Sergei Semko on 8/8/23.
//

import Foundation


struct Story: Decodable {
    let id: Int
    let score: Int
    let title: String
    let url: String?
}
