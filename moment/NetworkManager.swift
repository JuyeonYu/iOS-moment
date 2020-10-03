//
//  NetworkManager.swift
//  moment
//
//  Created by Juyeon on 2020/09/27.
//  Copyright © 2020 주연  유. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    static let sharedInstance = NetworkManager()

    init() {}
    
    func requestNaverBookList(keyword: String, start: Int, completion: @escaping (Any) -> Void) {
        let url = "https://openapi.naver.com/v1/search/book.json"
        let param = ["query":keyword, "display":20, "start":start] as [String : Any]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Naver-Client-Id": "Lq0B1PfGpbrb3ZykZVGm",
            "X-Naver-Client-Secret": "mzRlyMs5iQ"
        ]
        
        AF.request(url, parameters: param, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let obj):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    let getData = try decoder.decode(NaverBook.self, from: jsonData)
                    completion(getData)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
    func requestNaverMovieList(keyword: String, start: Int, completion: @escaping (Any) -> Void) {
        let url = "https://openapi.naver.com/v1/search/movie.json"
        let param = ["query":keyword, "display":20, "start":start] as [String : Any]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Naver-Client-Id": "Lq0B1PfGpbrb3ZykZVGm",
            "X-Naver-Client-Secret": "mzRlyMs5iQ"
        ]
        
        AF.request(url, parameters: param, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let obj):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    let getData = try decoder.decode(NaverMovie.self, from: jsonData)
                    completion(getData)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
}
