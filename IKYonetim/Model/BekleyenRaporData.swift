//
//  BekleyenRaporData.swift
//  IKYonetim
//
//  Created by Volkan on 25.07.2021.
//

import Foundation

struct BekleyenRaporData: Decodable {
    let is_success: Bool?
    let messages: String?
    let data: [BekleyenRapor]
}

struct BekleyenRapor: Decodable {
    let izin_id: Int
    let nedeni: String
    let rapor_baslangic: String
    let rapor_bitis: String
    let adi: String
    let soyadi: String
}
