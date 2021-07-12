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
    let data: GecmisRapor
}

struct GecmisRapor: Decodable {
    let id: Int?
    let raporNedeni: String?
    let raporBaslangic: String?
    let raporBitis: String?
    let onay: Bool?
}
