//
//  APICaller.swift
//  InifiniteScroll
//
//  Created by Sergei Semko on 8/8/23.
//

import Foundation

struct Constants {
    static let baseURL = "https://hacker-news.firebaseio.com/v0"
}

class APICaller {
    
    static let shared = APICaller()
    private init() {}
    
    func getTopStories(completion: @escaping ([Int]) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/topstories.json") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let safeData = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode([Int].self, from: safeData)
                completion(results)
            } catch {
                print("Error getTopStories: \(error)")
            }
        }
        
        task.resume()
    }
    
    func getAskStories(completion: @escaping ([Int]) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/askstories.json") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let safeData = data, error == nil else { return }

            do {
                let results = try JSONDecoder().decode([Int].self, from: safeData)
                completion(results)
            } catch {
                print("Error getAskStories: \(error)")
            }
        }
        
        task.resume()
    }
    
    func getStoryById(id: Int, completion: @escaping (Story) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/item/\(id).json") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let safeData = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(Story.self, from: safeData)
                completion(results)
            } catch {
                print("Error getStoryById: \(error)")
            }
        }
        
        task.resume()
    }
}
