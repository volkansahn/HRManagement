//
//  HttpClient.swift
//  IKYonetim
//
//  Created by Volkan on 9.07.2021.
//

import Foundation

protocol HRClientDelegate {
    func success(_ response: SuccessData)
    func isLogin(_ response: LoginData)
    func failedWithError(error: Error)
    func isLogedOut(_ response: LogoutData)
    func gecmisIzin(_ response: GecmisIzinData)
    func bekleyenIzin(_ response: BekleyenIzinData)
    func kalanMazeret(_ response: KalanMazeretData)
    func kalanYillik(_ response: KalanYillikData)
    func gecmisRapor(_ response: GecmisRaporData)
    func calisanBilgi(_ response: CalisanData)
    func calisanAraError(error: Error)
}

class HRHttpClient {
    var kullanici_id: String?
    var authToken: String?
    var sifre: String?
    var firstName: String?
    var lastName: String?
    
    var delegate: HRClientDelegate?

    init() {

    }

    init(kullanici_id: String, sifre: String) {

        self.kullanici_id = kullanici_id
        self.sifre = sifre
    }

    init(kullanici_id: String, authToken: String) {

        self.kullanici_id = kullanici_id
        self.authToken = authToken
    }

    func login() {

        // 1. Create URL
        if let url = URL(string: Constants.backendURL) {

            var request = URLRequest(url: url)
            // Request Body
            var body = [String: Any]()
            body = ["kullanici_id": kullanici_id!,
                    "sifre": sifre!]
            do {
                request.httpBody  = try JSONSerialization.data(withJSONObject: body, options: [])

            } catch {
                print("JSON serialization failed:  \(error)")

            }
            // Change the URLRequest to a POST request
            request.httpMethod = "POST"
            // Need to tell that request has json in body.
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            // 2. Create URLSession
            let session = URLSession.shared
            // 3. Give Session a task
            let task = session.dataTask(with: request) { (data, _, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.delegate?.failedWithError(error: error!)
                        return
                    }

                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        if let signInResponse = self.parseLoginJSON(safeData) {
                            // Who has the delegate run signInSuccess method
                            self.delegate?.isLogin(signInResponse)
                        }
                    }

                }

            }
            // 4. Start Task
            task.resume()
        }

    }

    func logOut() {
        // 1. Create URL
        if let url = URL(string: Constants.logOutURL) {

            var request = URLRequest(url: url)
            /*
            request.setValue(kullanici_id, forHTTPHeaderField: "X-User-Email")
            request.setValue(authToken, forHTTPHeaderField: "X-User-Token")
            */
            var body = [String: Any]()
            body = ["kullanici_id": kullanici_id!,
                    "auth_token": "auth_will_be_genereted"]
            do {
                request.httpBody  = try JSONSerialization.data(withJSONObject: body, options: [])

            } catch {
                print("JSON serialization failed:  \(error)")

            }
            request.httpMethod = "DELETE"
            let session = URLSession(configuration: .default)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            // 3. Give Session a task
            let task = session.dataTask(with: request) { (data, _, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.delegate?.failedWithError(error: error!)
                        return
                    }

                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        if let logOutResponse = self.parseLogoutJSON(safeData) {
                            // Who has the delegate run signInSuccess method
                            self.delegate?.isLogedOut(logOutResponse)
                        }
                    }

                }

            }
            // 4. Start Task
            task.resume()
        }
    }

    func gecmisIzin() {
        // 1. Create URL
        if let url = URL(string: Constants.gecmisIzinURL) {

            var request = URLRequest(url: url)
            /*
            request.setValue(kullanici_id, forHTTPHeaderField: "X-User-Email")
            request.setValue(authToken, forHTTPHeaderField: "X-User-Token")
            */
            request.httpMethod = "GET"
            let session = URLSession(configuration: .default)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            // 3. Give Session a task
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.delegate?.failedWithError(error: error!)
                        return
                    }

                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        if let response = self.parseGecmisIzin(safeData) {
                            // Who has the delegate run signInSuccess method
                            self.delegate?.gecmisIzin(response)
                        }
                    }

                }

            }
            // 4. Start Task
            task.resume()
        }
    }

    func bekleyenIzin() {
        // 1. Create URL
        if let url = URL(string: Constants.bekleyenIzinURL) {

            var request = URLRequest(url: url)
            
            /*
            request.setValue(kullanici_id, forHTTPHeaderField: "X-User-Email")
            request.setValue(authToken, forHTTPHeaderField: "X-User-Token")
            */
            request.httpMethod = "GET"
            let session = URLSession(configuration: .default)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            // 3. Give Session a task
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.delegate?.failedWithError(error: error!)
                        return
                    }

                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        if let response = self.parseBekleyenIzin(safeData) {
                            // Who has the delegate run signInSuccess method
                            self.delegate?.bekleyenIzin(response)
                        }
                    }

                }

            }
            // 4. Start Task
            task.resume()
        }
    }

    func kalanMazeret(calisan: Calisan) {
        // 1. Create URL
        if let url = URL(string: Constants.kalanMazeretURL) {

            var request = URLRequest(url: url)
            /*
            request.setValue(kullanici_id, forHTTPHeaderField: "X-User-Email")
            request.setValue(authToken, forHTTPHeaderField: "X-User-Token")
            */
            request.httpMethod = "POST"
            let session = URLSession(configuration: .default)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            var body = [String: Any]()
            body = ["kullanici_id": calisan.id,
                    "auth_token": calisan.token]
            do {
                request.httpBody  = try JSONSerialization.data(withJSONObject: body, options: [])

            } catch {
                print("JSON serialization failed:  \(error)")

            }
            // 3. Give Session a task
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.delegate?.failedWithError(error: error!)
                        return
                    }

                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        if let response = self.parseKalanMazeret(safeData) {
                            // Who has the delegate run signInSuccess method
                            self.delegate?.kalanMazeret(response)
                        }
                    }

                }

            }
            // 4. Start Task
            task.resume()
        }
    }

    func kalanYillik(calisan: Calisan) {
        // 1. Create URL
        if let url = URL(string: Constants.kalanYillikURL) {

            var request = URLRequest(url: url)
            /*
            request.setValue(kullanici_id, forHTTPHeaderField: "X-User-Email")
            request.setValue(authToken, forHTTPHeaderField: "X-User-Token")
            */
            request.httpMethod = "POST"
            let session = URLSession(configuration: .default)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            // Request Body
            var body = [String: Any]()
            body = ["kullanici_id": calisan.id,
                    "auth_token": calisan.token]
            do {
                request.httpBody  = try JSONSerialization.data(withJSONObject: body, options: [])

            } catch {
                print("JSON serialization failed:  \(error)")

            }
            // 3. Give Session a task
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.delegate?.failedWithError(error: error!)
                        return
                    }

                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        if let response = self.parseKalanYillik(safeData) {
                            // Who has the delegate run signInSuccess method
                            self.delegate?.kalanYillik(response)
                        }
                    }

                }

            }
            // 4. Start Task
            task.resume()
        }
    }

    func izinTalebi(izin_turu: String, izinBaslangic: String, izinBitis: String) {

        // 1. Create URL
        if let url = URL(string: Constants.izinTalebiURL) {

            var request = URLRequest(url: url)
            /*
            request.setValue(kullanici_id, forHTTPHeaderField: "X-User-Email")
            request.setValue(authToken, forHTTPHeaderField: "X-User-Token")
            */
            // Request Body
            var body = [String: Any]()
            body["data"] = ["id": kullanici_id,
                            "izin_turu": izin_turu,
                            "izin_baslangic": izinBaslangic,
                            "izin_bitis": izinBitis]
            do {
                request.httpBody  = try JSONSerialization.data(withJSONObject: body, options: [])

            } catch {
                print("JSON serialization failed:  \(error)")

            }
            // Change the URLRequest to a POST request
            request.httpMethod = "POST"
            // Need to tell that request has json in body.
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            // 2. Create URLSession
            let session = URLSession.shared
            // 3. Give Session a task
            let task = session.dataTask(with: request) { (data, _, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.delegate?.failedWithError(error: error!)
                        return
                    }

                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        if let response = self.parseSuccess(safeData) {
                            // Who has the delegate run signInSuccess method
                            self.delegate?.success(response)
                        }
                    }

                }

            }
            // 4. Start Task
            task.resume()
        }

    }

    func izinOnayla(izin_id: Int) {
        // 1. Create URL
        if let url = URL(string: Constants.izinOnayURL) {

            var request = URLRequest(url: url)
            // Request Body
            /*
            request.setValue(kullanici_id, forHTTPHeaderField: "X-User-Email")
            request.setValue(authToken, forHTTPHeaderField: "X-User-Token")
            */
            var body = [String: Any]()
            body["data"] = ["izin_id": izin_id]
            do {
                request.httpBody  = try JSONSerialization.data(withJSONObject: body, options: [])

            } catch {
                print("JSON serialization failed:  \(error)")

            }
            // Change the URLRequest to a POST request
            request.httpMethod = "PATCH"
            // Need to tell that request has json in body.
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            // 2. Create URLSession
            let session = URLSession(configuration: .default)

            // 3. Give Session a task
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.delegate?.failedWithError(error: error!)
                        return
                    }

                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        if let response = self.parseSuccess(safeData) {
                            // Who has the delegate run signInSuccess method
                            self.delegate?.success(response)
                        }
                    }

                }

            }
            // 4. Start Task
            task.resume()
        }
    }

    func izinGuncelle(calisan_id: String, mazeret_izni: Int, yillik_izni: Int) {
        // 1. Create URL
        if let url = URL(string: Constants.izinGuncelleURL) {

            var request = URLRequest(url: url)
            // Request Body
            /*
            request.setValue(kullanici_id, forHTTPHeaderField: "X-User-Email")
            request.setValue(authToken, forHTTPHeaderField: "X-User-Token")
            */
            var body = [String: Any]()
            body["data"] = ["calisan_id": calisan_id,
                            "mazeret_izni": mazeret_izni,
                            "yillik_izni": yillik_izni]
            do {
                request.httpBody  = try JSONSerialization.data(withJSONObject: body, options: [])

            } catch {
                print("JSON serialization failed:  \(error)")

            }
            // Change the URLRequest to a POST request
            request.httpMethod = "PATCH"
            // Need to tell that request has json in body.
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            // 2. Create URLSession
            let session = URLSession(configuration: .default)

            // 3. Give Session a task
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.delegate?.failedWithError(error: error!)
                        return
                    }

                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        if let response = self.parseSuccess(safeData) {
                            // Who has the delegate run signInSuccess method
                            self.delegate?.success(response)
                        }
                    }

                }

            }
            // 4. Start Task
            task.resume()
        }
    }

    func gecmisRapor() {
        // 1. Create URL
        if let url = URL(string: Constants.gecmisRaporURL) {

            var request = URLRequest(url: url)
            /*
            request.setValue(kullanici_id, forHTTPHeaderField: "X-User-Email")
            request.setValue(authToken, forHTTPHeaderField: "X-User-Token")
            */
            request.httpMethod = "GET"
            let session = URLSession(configuration: .default)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            // 3. Give Session a task
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.delegate?.failedWithError(error: error!)
                        return
                    }

                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        if let response = self.parseGecmisRapor(safeData) {
                            // Who has the delegate run signInSuccess method
                            self.delegate?.gecmisRapor(response)
                        }
                    }

                }

            }
            // 4. Start Task
            task.resume()
        }
    }

    func raporOlustur(raporNedeni: String, raporBaslangic: String, raporBitis: String) {

        // 1. Create URL
        if let url = URL(string: Constants.raporOlusturURL) {

            var request = URLRequest(url: url)
            /*
            request.setValue(kullanici_id, forHTTPHeaderField: "X-User-Email")
            request.setValue(authToken, forHTTPHeaderField: "X-User-Token")
            */
            // Request Body
            var body = [String: Any]()
            body["data"] = ["id":kullanici_id,
                            "raporNedeni": raporNedeni,
                            "raporBaslangic": raporBaslangic,
                            "raporBitis": raporBitis]
            do {
                request.httpBody  = try JSONSerialization.data(withJSONObject: body, options: [])

            } catch {
                print("JSON serialization failed:  \(error)")

            }
            // Change the URLRequest to a POST request
            request.httpMethod = "POST"
            // Need to tell that request has json in body.
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            // 2. Create URLSession
            let session = URLSession.shared
            // 3. Give Session a task
            let task = session.dataTask(with: request) { (data, _, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.delegate?.failedWithError(error: error!)
                        return
                    }

                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        if let response = self.parseSuccess(safeData) {
                            // Who has the delegate run signInSuccess method
                            self.delegate?.success(response)
                        }
                    }

                }

            }
            // 4. Start Task
            task.resume()
        }

    }

    func raporOnayla(rapor_id: Int) {
        // 1. Create URL
        if let url = URL(string: Constants.raporOnayURL) {

            var request = URLRequest(url: url)
            // Request Body
            /*
            request.setValue(kullanici_id, forHTTPHeaderField: "X-User-Email")
            request.setValue(authToken, forHTTPHeaderField: "X-User-Token")
            */
            var body = [String: Any]()
            body["data"] = ["rapor_id": rapor_id]
            do {
                request.httpBody  = try JSONSerialization.data(withJSONObject: body, options: [])

            } catch {
                print("JSON serialization failed:  \(error)")

            }
            // Change the URLRequest to a POST request
            request.httpMethod = "PATCH"
            // Need to tell that request has json in body.
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            // 2. Create URLSession
            let session = URLSession(configuration: .default)

            // 3. Give Session a task
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.delegate?.failedWithError(error: error!)
                        return
                    }

                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        if let response = self.parseSuccess(safeData) {
                            // Who has the delegate run signInSuccess method
                            self.delegate?.success(response)
                        }
                    }

                }

            }
            // 4. Start Task
            task.resume()
        }
    }

    func maasGuncelle(calisan_id: String, guncel_maas: Int, guncel_yan_odeme: Int) {
        // 1. Create URL
        if let url = URL(string: Constants.maasGuncelleURL) {

            var request = URLRequest(url: url)
            // Request Body
            /*
            request.setValue(kullanici_id, forHTTPHeaderField: "X-User-Email")
            request.setValue(authToken, forHTTPHeaderField: "X-User-Token")
            */
            var body = [String: Any]()
            body["data"] = ["calisan_id": calisan_id,
                            "guncel_maas": guncel_maas,
                            "guncel_yan_odeme": guncel_yan_odeme]
            do {
                request.httpBody  = try JSONSerialization.data(withJSONObject: body, options: [])

            } catch {
                print("JSON serialization failed:  \(error)")

            }
            // Change the URLRequest to a POST request
            request.httpMethod = "PATCH"
            // Need to tell that request has json in body.
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            // 2. Create URLSession
            let session = URLSession(configuration: .default)

            // 3. Give Session a task
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.delegate?.failedWithError(error: error!)
                        return
                    }

                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        if let response = self.parseSuccess(safeData) {
                            // Who has the delegate run signInSuccess method
                            self.delegate?.success(response)
                        }
                    }

                }

            }
            // 4. Start Task
            task.resume()
        }
    }

    func calisanBilgi(calisan_id: String) {
        // 1. Create URL
        if let url = URL(string: Constants.calisanBilgiURL) {

            var request = URLRequest(url: url)
            /*
            request.setValue(kullanici_id, forHTTPHeaderField: "X-User-Email")
            request.setValue(authToken, forHTTPHeaderField: "X-User-Token")
            */
            var body = [String: Any]()
            body["data"] = ["calisan_id": calisan_id]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

            } catch {
                print("JSON serialization failed:  \(error)")

            }
            request.httpMethod = "POST"
            let session = URLSession(configuration: .default)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            // 3. Give Session a task
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.delegate?.calisanAraError(error: error!)
                        return
                    }

                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        if let response = self.parseCalisanBilgi(safeData) {
                            // Who has the delegate run signInSuccess method
                            self.delegate?.calisanBilgi(response)
                        }
                    }

                }

            }
            // 4. Start Task
            task.resume()
        }
    }

    func calisanOlustur(calisan: Calisan) {

        // 1. Create URL
        if let url = URL(string: Constants.calisanOlusturURL) {

            var request = URLRequest(url: url)
            /*
            request.setValue(kullanici_id, forHTTPHeaderField: "X-User-Email")
            request.setValue(authToken, forHTTPHeaderField: "X-User-Token")
            */
            // Request Body
            var body = [String: Any]()
            body["data"] = [ "id": calisan.id,
                             "isim": calisan.isim,
                             "sifre": calisan.sifre,
                             "soyisim": calisan.soyisim,
                             "rol": calisan.rol,
                             "amir_id": calisan.amir_id]
            do {
                request.httpBody  = try JSONSerialization.data(withJSONObject: body, options: [])

            } catch {
                print("JSON serialization failed:  \(error)")

            }
            // Change the URLRequest to a POST request
            request.httpMethod = "POST"
            // Need to tell that request has json in body.
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            // 2. Create URLSession
            let session = URLSession.shared
            // 3. Give Session a task
            let task = session.dataTask(with: request) { (data, _, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.delegate?.failedWithError(error: error!)
                        return
                    }

                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        if let response = self.parseSuccess(safeData) {
                            // Who has the delegate run signInSuccess method
                            self.delegate?.success(response)
                        }
                    }

                }

            }
            // 4. Start Task
            task.resume()
        }

    }

    func calisanGuncelle(calisan_id: String, calisan: Calisan) {
        // 1. Create URL
        if let url = URL(string: Constants.calisanGuncelleURL) {

            var request = URLRequest(url: url)
            // Request Body
            /*
            request.setValue(kullanici_id, forHTTPHeaderField: "X-User-Email")
            request.setValue(authToken, forHTTPHeaderField: "X-User-Token")
            */
            var body = [String: Any]()
            body["data"] = [ "id": calisan.id,
                             "isim": calisan.isim,
                             "sifre": calisan.sifre,
                             "Soyisim": calisan.soyisim,
                             "rol": calisan.rol,
                             "amir_id": calisan.amir_id]
            do {
                request.httpBody  = try JSONSerialization.data(withJSONObject: body, options: [])

            } catch {
                print("JSON serialization failed:  \(error)")

            }
            // Change the URLRequest to a POST request
            request.httpMethod = "PATCH"
            // Need to tell that request has json in body.
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            // 2. Create URLSession
            let session = URLSession(configuration: .default)

            // 3. Give Session a task
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.delegate?.failedWithError(error: error!)
                        return
                    }

                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        if let response = self.parseSuccess(safeData) {
                            // Who has the delegate run signInSuccess method
                            self.delegate?.success(response)
                        }
                    }

                }

            }
            // 4. Start Task
            task.resume()
        }
    }

    func calisanSil(calisan_id: String) {
        // 1. Create URL
        if let url = URL(string: Constants.calisanSilURL) {

            var request = URLRequest(url: url)
            /*
            request.setValue(kullanici_id, forHTTPHeaderField: "X-User-Email")
            request.setValue(authToken, forHTTPHeaderField: "X-User-Token")
            */
            request.httpMethod = "DELETE"
            let session = URLSession(configuration: .default)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            // 3. Give Session a task
            let task = session.dataTask(with: request) { (data, _, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.delegate?.failedWithError(error: error!)
                        return
                    }

                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        if let response = self.parseSuccess(safeData) {
                            // Who has the delegate run signInSuccess method
                            self.delegate?.success(response)
                        }
                    }

                }

            }
            // 4. Start Task
            task.resume()
        }
    }

    // Parsing Data
    func parseLoginJSON(_ data: Data) -> LoginData? {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(LoginData.self, from: data)
            return decodedData

        } catch {
            delegate?.failedWithError(error: error)
            return nil
        }

    }

    func parseLogoutJSON(_ data: Data) -> LogoutData? {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(LogoutData.self, from: data)
            return decodedData

        } catch {
            delegate?.failedWithError(error: error)
            return nil
        }

    }

    func parseGecmisIzin(_ data: Data) -> GecmisIzinData? {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(GecmisIzinData.self, from: data)
            return decodedData

        } catch {
            delegate?.failedWithError(error: error)
            return nil
        }

    }

    func parseBekleyenIzin(_ data: Data) -> BekleyenIzinData? {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(BekleyenIzinData.self, from: data)
            return decodedData

        } catch {
            delegate?.failedWithError(error: error)
            return nil
        }

    }

    func parseKalanMazeret(_ data: Data) -> KalanMazeretData? {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(KalanMazeretData.self, from: data)
            return decodedData

        } catch {
            delegate?.failedWithError(error: error)
            return nil
        }

    }

    func parseKalanYillik(_ data: Data) -> KalanYillikData? {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(KalanYillikData.self, from: data)
            return decodedData

        } catch {
            delegate?.failedWithError(error: error)
            return nil
        }

    }

    func parseSuccess(_ data: Data) -> SuccessData? {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(SuccessData.self, from: data)
            return decodedData

        } catch {
            delegate?.failedWithError(error: error)
            return nil
        }

    }

    func parseGecmisRapor(_ data: Data) -> GecmisRaporData? {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(GecmisRaporData.self, from: data)
            return decodedData

        } catch {
            delegate?.failedWithError(error: error)
            return nil
        }

    }

    func parseCalisanBilgi(_ data: Data) -> CalisanData? {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(CalisanData.self, from: data)
            return decodedData

        } catch {
            delegate?.calisanAraError(error: error)
            return nil
        }

    }

}

extension HRClientDelegate {
    
    func success(_ response: SuccessData) {

    }
    
    func failedWithError(error: Error) {

    }
    
    func isLogedOut(_ response: LogoutData) {

    }
    
    func gecmisIzin(_ response: GecmisIzinData) {

    }
    
    func bekleyenIzin(_ response: BekleyenIzinData) {

    }
    func kalanMazeret(_ response: KalanMazeretData) {

    }
    func kalanYilik(_ response: KalanYillikData) {

    }
    
    func isLogin(_ response: LoginData) {
        
    }
    
    func kalanYillik(_ response: KalanYillikData) {
        
    }
    
    func gecmisRapor(_ response: GecmisRaporData) {
        
    }
    
    func calisanBilgi(_ response: CalisanData) {
        
    }
    func calisanAraError(error: Error){
        
    }

}
