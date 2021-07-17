//
//  gecmisIzinData.swift
//  IKYonetim
//
//  Created by Volkan on 9.07.2021.
//

import Foundation

struct GecmisIzinData: Decodable {
    let is_success: Bool?
    let messages: String?
    let data: [GecmisIzin]
}

struct GecmisIzin: Decodable {
    let id: Int
    let izinTuru: String
    let izinBaslangic: String
    let izinBitis: String
}

