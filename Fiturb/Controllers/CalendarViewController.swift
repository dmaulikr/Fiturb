//
//  CalendarViewController.swift
//  Fiturb
//
//  Created by DATAPPS on 3/31/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK:- IBOutlets
    @IBOutlet weak var calendarTableview: UITableView!
    
    var calenderActivityApiResponseRecievedArray = [Any?]()
    
    let colorcodes = [UIColor.green,UIColor.red,UIColor.blue,UIColor.yellow,UIColor.purple]

    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //Get calender activity api calling method
        self.getCalenderActivityApi()
        
    }
    
    //MARK:- Api methods
    //GET
    func getCalenderActivityApi() -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        let calenderActivityUrl = MyAppConstants.calnederActivityUrl
        
        ApiDataManager.singleTonObjectForApiManagerClass.getCalenderActivityApiValuesWithUrlString(urlString: calenderActivityUrl,callBackBlock:  {  (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if self.calenderActivityApiResponseRecievedArray.count != 0{
                
                self.calenderActivityApiResponseRecievedArray.removeAll()
            }
            
            guard error == nil else{
                
                let errorText = error!.localizedFailureReason!
                
                if errorText == "ok successful"{
                    
                    //Reload calender activity Table view
                    self.calendarTableview.reloadData()
                    
                }
                else{
                    
                    //Error handling
                    print("Error recieved from Calender activity api is:\(errorText)")
                    
                    //Reload calender activity Table view
                    self.calendarTableview.reloadData()
                    
                    //Dsiplay alert
                    let alertController = singleTon.sharedInstance.displayAlert(message: errorText, title: "Fiturb")
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
                return
            }
            
            //Store recieved response
            self.calenderActivityApiResponseRecievedArray = apiRecievedResponse!
            
            if self.calenderActivityApiResponseRecievedArray.count != 0{
                
                for responseRecievedobj in self.calenderActivityApiResponseRecievedArray{
                    
                    let tempObj = responseRecievedobj! as! CalenderActivityModel
                    
                    print("Calender activity model object values are:\(tempObj.activityId!),\(tempObj.activityName!),\(tempObj.activityStartTime!),\(tempObj.activityEndTime!),\(tempObj.longitude!),\(tempObj.latitude!)")
                }
                
            }
            
            //Reload calender activity Table view
            self.calendarTableview.reloadData()
            
        })

    }
    
    //MARK:- UITableview Datasource and delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rowsCount: Int?
    
        //Calender activity cell
        rowsCount = (self.calenderActivityApiResponseRecievedArray.count != 0) ? self.calenderActivityApiResponseRecievedArray.count : 0
        
        return rowsCount!
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let calenderActivityTableCell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell", for: indexPath) as! CalendarTableViewCell
        
        if self.calenderActivityApiResponseRecievedArray.count != 0{

            let modelObj = self.calenderActivityApiResponseRecievedArray[indexPath.row] as? CalenderActivityModel
            
            //Custom cell method
            calenderActivityTableCell.customCellData(activityName: modelObj?.activityName, activityStartDateAndTime: modelObj?.activityStartTime)
            
            //subview background colour
            calenderActivityTableCell.firstSubView.backgroundColor = UIColor.purple
            
        }
        
        return calenderActivityTableCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var cellRowHeight:CGFloat?
        
        cellRowHeight = 161
        
        return cellRowHeight!
        
    }

   
}
