//
//  GecmisRaporData.swift
//  IKYonetim
//
//  Created by Volkan on 9.07.2021.
//

import Foundation

struct GecmisRaporData: Decodable {
    let is_success: Bool?
    let messages: String?
    let data: [GecmisRapor]
}

struct GecmisRapor: Decodable {
    let rapor_id: Int?
    let nedeni: String?
    let rapor_baslangic: String?
    let rapor_bitis: String?
}
