//
//  KalanMazeretData.swift
//  IKYonetim
//
//  Created by Volkan on 9.07.2021.
//

import Foundation

struct KalanMazeretData: Decodable {
    let is_success: Bool?
    let messages: String?
    let data: KalanMazeretIzin
}

struct KalanMazeretIzin: Decodable {
    let kalan_mazeret_izni: Int
}
