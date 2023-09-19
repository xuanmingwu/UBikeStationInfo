//
//  UbikeStationManager.swift
//  UbikeStationInfo
//
//  Created by 吳玹銘 on 2023/9/19.
//

import Foundation

struct UbikeStation: Codable {
    let sno: String
    let sna: String
    let tot: Int
    let sbi: Int
    let sarea: String
    let mday: String
    let lat: Double
    let lng: Double
    let ar: String
    let sareaen: String
    let snaen: String
    let aren: String
    let bemp: Int
    let act: String
    let srcUpdateTime: String
    let updateTime: String
    let infoTime: String
    let infoDate: String
}

class UbikeStationManager {

    static let shared = UbikeStationManager()
    private init() {}

    func fetchUbikeStations(completion: @escaping ([UbikeStation]?, Error?) -> Void) {
        guard let url = URL(string:"https://tcgbusfs.blob.core.windows.net/dotapp/youbike/v2/youbike_immediate.json") else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
            } else if let data = data {
                do {
                    let stations = try JSONDecoder().decode([UbikeStation].self, from: data)
                    completion(stations, nil)
                } catch let jsonError {
                    completion(nil, jsonError)
                }
            }
        }
        task.resume()
    }

}
