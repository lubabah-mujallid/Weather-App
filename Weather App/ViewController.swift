//
//  ViewController.swift
//  Weather App
//
//  Created by administrator on 05/01/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageViewWeatherIcon: UIImageView!
    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var collectionViewTodayDetails: UICollectionView!
    @IBOutlet weak var collectionViewWeekDetails: UICollectionView!
    @IBOutlet weak var labelCurrentWeatherStatus: UILabel!
    
    var weatherCast: WeatherCast?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViews()
        fetchData()
    }

    func setCollectionViews() {
        collectionViewWeekDetails.delegate = self
        collectionViewWeekDetails.dataSource = self
        collectionViewTodayDetails.delegate = self
        collectionViewTodayDetails.dataSource = self
        view.addSubview(collectionViewWeekDetails)
        view.addSubview(collectionViewTodayDetails)
    }
    
    func updateUI() {
        //set the main view items: label and image
        let url = "http://openweathermap.org/img/wn/\(String(describing: weatherCast!.current.weather[0].icon))@2x.png"
        imageViewWeatherIcon.downloaded(from: url)
        labelTemp.text = "\(String(describing: Int(weatherCast!.current.temp)))°"
        labelCurrentWeatherStatus.text = weatherCast?.current.weather[0].weatherDescription
    }
    
    func fetchData() {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=21.5169&lon=39.2192&exclude=minutely,alerts&lang=ar&units=metric&appid=a6a7d46b67487feaa22f2fecc3cc2531")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: {
            data, response, error in
            print("api initialized")
            print(data ?? "no data")
            guard let myData = data else { return }
            do {
                let decoder = JSONDecoder()
                let jsonResult = try decoder.decode(WeatherCast.self, from: myData)
                self.weatherCast = jsonResult
                //print(self.weatherCast!)
                DispatchQueue.main.async {
                    self.collectionViewTodayDetails.reloadData()
                    self.collectionViewWeekDetails.reloadData()
                    self.updateUI()
                }
            }
            catch {
                print("error catched")
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewTodayDetails {
            return 5
        }
        else {
            return weatherCast?.daily.count ?? 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionViewTodayDetails {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dailyCell", for: indexPath) as! DailyCollectionViewCell
            var title: String
            var details: String
            switch indexPath.item {
                case 0:
                    title = "Feels Like"
                    details = weatherCast?.current.feelsLike.description ?? "no data 0 "
                case 1:
                    title = "Pressure"
                    details = weatherCast?.current.pressure.description ?? "no data 1"
                case 2:
                    title = "Humidity"
                    details = weatherCast?.current.humidity.description ?? "no data 2"
                case 3:
                    title = "Wind Degree"
                    details = weatherCast?.current.windDeg.description ?? "no data 3"
                case 4:
                    title = "Wind Speed"
                    details = weatherCast?.current.windSpeed.description ?? "no data 4"
                default: title = "title"; details = "details"
            }
            cell.setupCell(title: title, details: details)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weeklyCell", for: indexPath) as! WeeklyCollectionViewCell
            print("making cel----------------------------------------")
            let daytime = (weatherCast?.daily[indexPath.item].dt) ?? 0
            print(daytime)
            let date = NSDate(timeIntervalSince1970: Double(daytime)) as Date
            let temp = (weatherCast?.daily[indexPath.item].temp.day) ?? 0.0
            print(temp)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let dayInWeek = dateFormatter.string(from: date)
            
            cell.setupCell(day: dayInWeek , temp: "\(String(describing: temp))")
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width * 0.45, height: self.view.frame.height * 0.35)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleToFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
