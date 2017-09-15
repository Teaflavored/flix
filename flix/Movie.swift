//
//  Movie.swift
//  flix
//
//  Created by Auster Chen on 9/12/17.
//  Copyright © 2017 Auster Chen. All rights reserved.
//

import Foundation

class Movie {
    var id: Int?
    var overview: String?
    var title: String?
    var posterPath: String?

    private let BASE_IMAGE_URL =  "https://image.tmdb.org/t/p/w500"

    init(config: NSDictionary) {
        id = config["id"] as? Int
        overview = config["overview"] as? String
        title = config["title"] as? String
        posterPath = config["poster_path"] as? String
    }

    func getPosterImageUrl() -> URL? {
        if let _posterPath = posterPath {
            return URL(string: "\(BASE_IMAGE_URL)\(_posterPath)")
        }
        
        return nil
    }

    class func fetchMovies(successCallBack: @escaping ([Movie]) -> (), _ errorCallBack: ((Error?) -> ())?) {
        let apiKey = "cd4e181e550bd1b9eb536ae2fd16907b"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                errorCallBack?(error)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                if let results = dataDictionary["results"] as? [NSDictionary] {
                    var movies: [Movie] = []
                    for result in results {
                        movies.append(Movie(config: result))
                    }

                    successCallBack(movies)
                } else {
                    successCallBack([])
                }
            }
        }
        task.resume()
    }
}
