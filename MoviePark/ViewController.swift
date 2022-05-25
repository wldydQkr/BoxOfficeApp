//
//  ViewController.swift
//  MoviePark
//
//  Created by comsoft on 2022/05/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let movieURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=ff9c16a03f346ef0d94dad367d05269c&targetDt=20220523"
    
    let name = ["1", "2", "3", "4", "5"]
    
    struct MovieData : Codable {
        
        let boxOfficeResult : BoxOfficeResult
        
    }
    
    struct BoxOfficeResult : Codable {
        
        let dailyBoxOfficeList : [DailyBoxOfficeList]
        
    }
    
    struct DailyBoxOfficeList : Codable {
        
        let movieNm : String
        
        let audiCnt : String
        
    }
    
    @IBOutlet weak var table: UITableView!
    
    var movieData: MovieData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        
        getData()
    }
    
    func getData() {
        
        if let url = URL(string: movieURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let JSONData = data {
                    //                    print(JSONData!)
                    //                    print(response!)
                    let dataStirng = String(data: JSONData, encoding: .utf8)
                    print(dataStirng!)
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(MovieData.self, from: JSONData)
                        print(decodedData.boxOfficeResult.dailyBoxOfficeList[0].movieNm)
                        print(decodedData.boxOfficeResult.dailyBoxOfficeList[0].audiCnt)
                        self.movieData = decodedData
                        DispatchQueue.main.async {
                            self.table.reloadData()
                        }
                        
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell
        cell.movieName.text = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].movieNm
        print(indexPath.description)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.description)
    }
    
}


