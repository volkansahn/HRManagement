//
//  KalanYillikData.swift
//  IKYonetim
//
//  Created by Volkan on 9.07.2021.
//

import Foundation

struct KalanYillikData: Decodable {
    let is_success: Bool?
    let messages: String?
    let data: KalanYillikIzin
}

struct KalanYillikIzin: Decodable {
    let kalan_yillik_izin: Int
}
