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
    let izin_id: Int
    let izin_turu: String
    let izin_baslangic: String
    let izin_bitis: String
    let durum : String
}
