//
//  BekleyenIzinData.swift
//  IKYonetim
//
//  Created by Volkan on 9.07.2021.
//

import Foundation

struct BekleyenIzinData: Decodable {
    let is_success: Bool?
    let messages: String?
    let data: BekleyenIzin
}

struct BekleyenIzin: Decodable {
    let id: Int
    let izinTuru: String
    let izinBaslangic: String
    let izinBitis: String
    let izinYonOnay: Bool
    let izinIkOnay: Bool
}

