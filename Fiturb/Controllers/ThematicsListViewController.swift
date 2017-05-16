//
//  ThematicsListViewController.swift
//  Fiturb
//
//  Created by Admin on 20/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class ThematicsListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,dataPassBackToPreviousProtocol {
    
    var selectedItemCount: Int?
    
    //Outlets
    var apiResponseRecievedArray = [AnyObject?]()
    
    @IBOutlet weak var collectionViewObj: UICollectionView!
    
    var imageName  = "google-hangouts"

    var selecteditemIndexpath:IndexPath?
    
    var selectedItemsModelObjCollectionArray = [thematicsListModel?]()
    
    @IBOutlet weak var submitBtn: UIButton!
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Collection VIew allow multiple selections
        collectionViewObj.allowsMultipleSelection = true
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if self.apiResponseRecievedArray.count == 0{
            
            //Get Thermatics list
            self.thematicsList()
        }
       
    }
    
    
    //MARK:- Api Methods
    func thematicsList() -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        ApiDataManager.singleTonObjectForApiManagerClass.getThematicsListApiValuesWithUrlString(urlString: MyAppConstants.thermaticListUrl) {  (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from thematics list api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            //Store recieved response
            self.apiResponseRecievedArray = apiRecievedResponse!
            
            if self.apiResponseRecievedArray.count != 0{
                
                for responseRecievedobj in self.apiResponseRecievedArray{
                    
                    let tempObj = responseRecievedobj! as! thematicsListModel
                    
                    print("Thematics model object values are:\(tempObj.themeName),\(tempObj.themeId!),\(tempObj.themeIcon),\(tempObj.themeMessage)")
                }
                
                //Reload collection view
                self.collectionViewObj.reloadData()
                
            }
            
        }
        
    }

    //MARK:- IBAction methods
    
    @IBAction func backButtonPressedAction(_ sender: UIButton) {
        
        _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        
        //perform segue to thematic interest list screen
        self.performSegue(withIdentifier: "ThematicsInterestlListViewController", sender: nil)
    }
    
    //MARK:- Private Methods
    var visibleCurrentCell: IndexPath? {
        
        for cell in self.collectionViewObj.visibleCells {
            
            let indexPath = self.collectionViewObj.indexPath(for: cell)
            
            return indexPath
            
        }
        
        return nil
    }
    
    //MARK:- Collection view Data source and delegate methods
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        
        return self.apiResponseRecievedArray.count
    }
    
     func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"thematicsCustomCell",
                                                      for: indexPath) as! CollectionViewCells
        
        if  self.apiResponseRecievedArray[indexPath.row] != nil {
            
            let eachResponseObj = self.apiResponseRecievedArray[indexPath.row] as! thematicsListModel

            //fill custom cell data
            cell.thematicsListImage(image:UIImage(named:imageName), thematicsListItemText: eachResponseObj.themeName, customCellObj:cell)

            if indexPath == selecteditemIndexpath{
                
                cell.updateTotalSelectedItemsCount(count:selectedItemCount)
                
            }
        }
        
        return cell
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
//        
//        var collectionViewFrameSize = collectionView.bounds.size
//        
//        collectionViewFrameSize.width = ((collectionViewFrameSize.width/3.0) - 15)
//        
//        collectionViewFrameSize.height = collectionViewFrameSize.width
//        
//        return collectionViewFrameSize
//    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
//    
//        if selecteditemIndexpath != indexPath {
//            
//            //Store selected item indexpath
//            selecteditemIndexpath = indexPath
//            
//        }
//        
//        //perform segue to thematic interest list screen
//        self.performSegue(withIdentifier: "ThematicsInterestlListViewController", sender: indexPath)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let thematicsCustomCell = collectionView.cellForItem(at: indexPath) as? CollectionViewCells
        
        thematicsCustomCell?.cellSubView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        
        //Collecting selected items model object
        let thematicsListModelObj = self.apiResponseRecievedArray[indexPath.row] as? thematicsListModel
        
        if thematicsListModelObj != nil {
            
            selectedItemsModelObjCollectionArray.append(thematicsListModelObj)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let thematicsCustomCell = collectionView.cellForItem(at: indexPath) as? CollectionViewCells
        
        thematicsCustomCell?.cellSubView.backgroundColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
        
        //Remove unSelcted items model object
        let thematicsListModelObj = self.apiResponseRecievedArray[indexPath.row] as? thematicsListModel
        
        if thematicsListModelObj != nil{
            
            self.selectedItemsModelObjCollectionArray = self.selectedItemsModelObjCollectionArray.filter { $0?.themeName != thematicsListModelObj?.themeName}
            
        }
        
    }
    
    //Sunil code( below 4 methods)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: CGFloat(((self.collectionViewObj.frame.size.width / 3) - 1)), height: CGFloat(130))
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(0,0,0,0)
    }
    
    //MARK:- Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "ThematicsInterestlListViewController" {
            
            return false
            
        }else{
            
            return true
            
        }
    }
    
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        let indexpathOfSelectedItem:IndexPath = sender as! IndexPath
//        
//        //Slected item model object
//        let responseObj = self.apiResponseRecievedArray[indexpathOfSelectedItem.row] as! thematicsListModel
//        
//        //Destination view controller adress
//        let destinationVC = segue.destination as! ThematicsInterestlListViewController
//        
//        //set up delegate
//        destinationVC.dataBackDelegate = self
//        
//        //Send slected item name to destination view controller
//        destinationVC.selectedThematicsListname = responseObj.themeName
//
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       // let indexpathOfSelectedItem:IndexPath = sender as! IndexPath
        
        //Slected item model object
        let responseObj = self.apiResponseRecievedArray[0] as! thematicsListModel
        
        //Destination view controller adress
        let destinationVC = segue.destination as! ThematicsInterestlListViewController
        
        //set up delegate
        destinationVC.dataBackDelegate = self
        
        //Send slected item name to destination view controller
        destinationVC.selectedThematicsListname = responseObj.themeName
        
        //pass selcted thematics items list array to next interest list class
        destinationVC.seletedInterestsModelObjectsCollectionArray = selectedItemsModelObjCollectionArray
    }

    
    //MARK:- Protocol delegate methods
    func passDataToThematicsListController(count:Int?) -> Void {
        
        guard count != nil  else {
         
            return
        }
        
        if (selecteditemIndexpath != nil){
        
            //Total count
            selectedItemCount = count!

            //Reload selected collection view item only
            self.collectionViewObj.reloadItems(at: [selecteditemIndexpath!])
            
        }
    }
}
