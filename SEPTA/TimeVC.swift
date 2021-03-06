//
//  TimeVC.swift
//  SEPTA
//
//  Created by Julia Gao Miller on 2/16/17.
//  Copyright © 2017 Julia Miller. All rights reserved.
//

import UIKit
import MapKit

class TimeVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var lineNameLabel: UILabel!
    @IBOutlet var directionLabel: UILabel!
    @IBOutlet var currentTimeLabel: UILabel!
    @IBOutlet var currentDayLabel: UILabel!
    @IBOutlet var dayOfWeekScheduleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var menuButton: UIBarButtonItem!
    
    let locationManager = CLLocationManager()
    
<<<<<<< Updated upstream
    var closestStation: StationDetail!
=======
    var myLocation: (longitude: CLLocationDegrees, latitude: CLLocationDegrees)?
    var savedStationsDict = [[String:Any]]()
>>>>>>> Stashed changes
    var stationTimes: [String: [String]] = ["weekday":[""],"weekend":[""], "saturday":[""], "sunday":[""], "":[""]]
    
//    var currentStation: StationDetail!
    var stationDetailArray = [StationDetail]()
<<<<<<< Updated upstream
    var compiledStations = [StationDetail]()
    
    var stationSchedules = [StationDetail]()
=======
    var compiledStations = [StationDetail]() //weekends + weekdays
    var stationSchedules = [StationDetail]() //directions
>>>>>>> Stashed changes
    
    var currentDayOfWeek = ""
    
    var timeIndex = 0
    var stationDetailIndex = 0
    
    var switchStationMode = false
    
    var railLocations = [(stationName: String, longitude: CLLocationDegrees, latitude: CLLocationDegrees)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRailLines()
        tableView.delegate = self
        tableView.dataSource = self
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = revealViewControllerWidth
        }
        
        _ = Timer.scheduledTimer(timeInterval: 10.0, target: self,
                                                           selector: #selector(displayCurrentDate),
                                                           userInfo: nil,
                                                           repeats: true)
        
        
    }
    
    func compileStations(){
        var i = 0
        for x in stationDetailArray {
            if compiledStations.count == 0 {
                compiledStations.append(x)
            } else if x.direction != stationDetailArray[i-1].direction
                || x.stationName != stationDetailArray[i-1].stationName{
                compiledStations.append(x)
            }
            i += 1
        }
        compiledStations = compiledStations.sorted{$0.stationName < $1.stationName}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkForUserDefaults()
        compileStations()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StationsVC" {
            let vc = segue.destination as! StationsVC
            vc.selectedLines = sender as! [[String:Any]]
        }
    }
    
    @IBAction func switchWeekSchedules(){
        var text = ""
        switch(currentDayOfWeek){
        case "weekday":
            if stationSchedules.count == 2 {
                text = "weekend"
            } else if stationSchedules.count == 3 {
                text = "saturday"
            }
        case "weekend":
            text = "weekday"
        case "saturday":
            text = "sunday"
        case "sunday":
            text = "weekday"
        default:
            fatalError("\(currentDayOfWeek)")
        }
        currentDayOfWeek = text
        text = text.capitalized
        dayOfWeekScheduleLabel.text = "\(text) Schedule →"
        setCorrectTimeIndex()
        tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .left)
    }
    
    @IBAction func switchStations(){
        switchStationMode = true
        reloadView()
        tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .fade)
    }
    
    func displayStation(stationName: String, direction: String, scheduleName: String){
        
        stationSchedules.removeAll()
        for s in stationDetailArray { //get both directions, should always be two
            if s.direction == direction && s.stationName == stationName && s.scheduleName == scheduleName {
                stationSchedules.append(s)
            }
        }
        if stationSchedules.count > 3 {fatalError("\(stationSchedules.count)")}
        
        if currentDayOfWeek == "" {
            //we just loaded the page, so the default would the day of week
            let today = Date()
            if stationSchedules.count == 2 {
                currentDayOfWeek = getDayOfWeek(date: today, returnSatSun: false)
                
            } else if stationSchedules.count == 3 {
                currentDayOfWeek = getDayOfWeek(date: today, returnSatSun: true)
            } else {
                fatalError("\(stationSchedules.count)")
            }
        }
        
        for s in stationSchedules {
            switch(s.dayOfWeekSchedule){
                case "weekend": stationTimes["weekend"] = s.timesArray
                case "weekday": stationTimes["weekday"] = s.timesArray
                case "saturday": stationTimes["saturday"] = s.timesArray
                case "sunday": stationTimes["sunday"] = s.timesArray
            default: fatalError("\(s.dayOfWeekSchedule)")
            }
        }
        
        lineNameLabel.text = stationName
        directionLabel.text = direction
        tableView.reloadData()
//        tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
        setCorrectTimeIndex()
        
    }
    
}

extension TimeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if switchStationMode {
            return compiledStations.count
        } else {
            if stationTimes[currentDayOfWeek]!.count < 2 {
                return 0
            } else {
                return stationTimes[currentDayOfWeek]!.count
            }
        }
        
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if switchStationMode {
            let station = compiledStations[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeStationCell") as! ChangeStationCell
            cell.configure(stationName: station.stationName, direction: station.direction)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell") as! TimeCell
            cell.backgroundColor = UIColor.white
            cell.countdownTimeLabel.font = UIFont.systemFont(ofSize: 12)
            cell.configure(departureTime: stationTimes[currentDayOfWeek]![indexPath.row])
            if indexPath.row == timeIndex {
                cell.backgroundColor = lightGreen
                cell.countdownTimeLabel.font = UIFont.systemFont(ofSize: 18)
            } else if timeIndex < stationTimes[currentDayOfWeek]!.count - 2 && indexPath.row == timeIndex + 1 {
                cell.countdownTimeLabel.font = UIFont.systemFont(ofSize: 16)
                cell.backgroundColor = lightLightLightGreen
            }
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if switchStationMode {
            switchStationMode = false
            let cell = tableView.cellForRow(at: indexPath) as! ChangeStationCell
            let station = cell.stationNameLabel.text
            let direction = cell.directionLabel.text
            for x in compiledStations {
                if x.stationName == station && x.direction == direction {
                    displayStation(stationName: x.stationName,
                                   direction: x.direction,
                                   scheduleName: x.scheduleName)
                    reloadView()
                }
            }
            
            
        } else {
            //we are on the train times and we can either see how long it will take to get to one of our favorited stations.
            //make an alert view pop up telling distances, or reload tableview.
            //OR look at apple documentation and remember to try to do the dropdown menu
            
            //or we can set up a notification
            //– but I think we'll make that only possible by pressing the notification button in the cell.
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
        
    }
}

extension TimeVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        myLocation?.latitude = locValue.latitude
        myLocation?.longitude = locValue.longitude
    }
    
    func requestLocationServices(){
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func checkForUserDefaults(){
        if let stationsExist = UserDefaults.standard.object(forKey: "stationDetailArray") as? [[String:Any]] {
            savedStationsDict.removeAll()
            savedStationsDict = stationsExist
            checkForSavedStations()
            
            let locationManager = CLLocationManager()
            // Ask for Authorisation from the User.
            locationManager.requestAlwaysAuthorization()
            
            // For use in foreground
            locationManager.requestWhenInUseAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
            
            displayCurrentDate()
            requestLocationServices()
            displayClosestStation()
        } else if let linesExist = UserDefaults.standard.object(forKey: "selectedLines") as? [[String:Any]] {
            performSegue(withIdentifier: "StationsVC", sender: linesExist)
        } else {
            performSegue(withIdentifier: "SchedulesVC", sender: nil)
        }
        
    }
    
    func loadRailLines(){
        if let path = Bundle.main.path(forResource: "septa", ofType: "json") {
            if let json = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe){
                if let data = try? JSONSerialization.jsonObject(with: json)
                {
                    if let all = data as? [String:Any] {
                        lines = all["lines"] as! [[String:Any]]
                    }
                } else { print("Couldn't convert file from JSON data to Any. Check your JSON file for errors.") }
            }
        }
    }
    
    func reloadView(){
        if switchStationMode {
            dayOfWeekScheduleLabel.isHidden = true
            directionLabel.isHidden = true
            lineNameLabel.text = "Switch Stations"
        } else {
            dayOfWeekScheduleLabel.isHidden = false
            directionLabel.isHidden = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        findClosestStation(myLocation: locValue)
    }
    
    //put this into helper
//    func getMyCurrentLocation(){
//        let locationManager = CLLocationManager()
//        // Ask for Authorisation from the User.
//        locationManager.requestAlwaysAuthorization()
//        
//        // For use in foreground
//        locationManager.requestWhenInUseAuthorization()
//        
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//        }
//        
//    }
    
    func findClosestStation(myLocation: CLLocationCoordinate2D){
        //returns a StationDetail
    }
    
    func displayClosestStation(){
       // findClosestStation() // returns a detailStation
        let station = stationDetailArray[0] //temporary
        displayStation(stationName: station.stationName,
                       direction: station.direction,
                       scheduleName: station.scheduleName)
    }
    
    func checkForSavedStations(){
        if savedStationsDict.count != 0 {
            stationDetailArray.removeAll()
            for x in savedStationsDict {
                let stationDetail = StationDetail(dict: x)
                stationDetailArray.append(stationDetail)
            }
        }
    }
    
    func displayCurrentDate(){
        let currentDate = Date()
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        df.amSymbol = "AM"
        df.pmSymbol = "PM"
        let time = df.string(from: currentDate)
        df.dateFormat = "MMM dd, yyyy"
        let dateString = df.string(from: currentDate)
        currentTimeLabel.text = time
        currentDayLabel.text = dateString
        tableView.reloadData()
    }
    
    func setCorrectTimeIndex(){
        var i = 0
        var previousDifferenceWasPositive = true
        for time in stationTimes[currentDayOfWeek]! {
            let difference = calculateTimeInMinutesUntilDepartureTime(departureTime: time)
            
            if difference < 0 && previousDifferenceWasPositive {
    
                timeIndex = i
                previousDifferenceWasPositive = false
                tableView.reloadData()
                tableView.scrollToRow(at: IndexPath.init(row: timeIndex, section: 0), at: .top, animated: false)
            }
            i += 1
        }
        
    }
}


