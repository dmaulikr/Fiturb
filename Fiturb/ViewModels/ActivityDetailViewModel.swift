//
//  ActivityDetailViewModel.swift
//  Fiturb
//
//  Created by Admin on 10/05/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation
import Alamofire

class ActivityDetailViewModel:NSObject {
    
    //Activity detail model object
    private var activityDetailModelObj:ActivityDetailModel?
    
    var selectedActivityID : String?

    var startDateAndTime: String?{
        
        return String(format: "%@, %@ %@ %@\n%@", activityDetailModelObj?.startDateAndTime?["dayName"] ?? "No data",activityDetailModelObj?.startDateAndTime?["date"] ?? "No data",activityDetailModelObj?.startDateAndTime?["monthName"] ?? "No data",activityDetailModelObj?.startDateAndTime?["year"] ?? "No data",activityDetailModelObj?.startDateAndTime?["time"] ?? "No data")
    }
    
    var endDateAndTime: Dictionary<String, String>?{
        
        return activityDetailModelObj?.endDateAndTime

    }

    var adress: String?{
        
        return activityDetailModelObj?.adress ?? "No data"
    }

    var entryFees: String?{
        
        return String(format: "%@ ₹", activityDetailModelObj?.entryFees ?? "Nod data")
    }
    
    var organisedBy: String?{
        
        return String(format: "Organised by %@", activityDetailModelObj?.organisedBy ?? "No data")
    }

    var descriptionText: String?{
        
        return String(format: "%@", activityDetailModelObj?.description ?? "No data")
    }

    //MARK:- Api methods
    func activityDetailApi(urlString:String?, postData:Dictionary<String, Any>?, callBackBlock:@escaping(_ successOrFailure:responseResult<String>) -> (), loaderCallBackBlock:@escaping(_ addOrRemoveLoader:loaderAddOrRemove) -> ()) -> Void {
        
        //Add loader
        DispatchQueue.main.async(execute: {
            
            loaderCallBackBlock(.AddLoader)
            
        });
        
        alamofireApiDataManager.singleTonObjectForAlamofireApiDataManager.activityDetailsApiValuesWithUrlString(urlString: urlString!, postDataDicitionary: postData, callBackBlock: { [weak self] (responseRecievedArray:Array?, error:NSError?) in
            
            //Remove Loader
            DispatchQueue.main.async(execute: {
                
                loaderCallBackBlock(.RemoveLoader)
                
            });
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from Activity detail api:\(String(describing: error))")
                
                //Error Call back
                DispatchQueue.main.async(execute: {
                    
                    callBackBlock(.Failure(error))
                });

                return
            }
            
            print("response is:\(String(describing: responseRecievedArray))")
            
            //Success
            if responseRecievedArray?.count != 0{
                
                var activityDetailApiResponseRecievedArray = [Any?]()
                
                activityDetailApiResponseRecievedArray = responseRecievedArray!
                
                //Activity detail model Object
                self?.activityDetailModelObj = (activityDetailApiResponseRecievedArray[0] as? ActivityDetailModel)
                
                //Suceess Call back
                DispatchQueue.main.async(execute: {
                    callBackBlock(.Success(self?.activityDetailModelObj?.messageText))
                    
                });
                
                print(self?.activityDetailModelObj?.messageText as Any,self?.activityDetailModelObj?.title as Any,self?.activityDetailModelObj?.startDateAndTime as Any,self?.activityDetailModelObj?.endDateAndTime as Any,self?.activityDetailModelObj?.latitude as Any,self?.activityDetailModelObj?.longitude as Any,self?.activityDetailModelObj?.description as Any,self?.activityDetailModelObj?.capacity as Any,self?.activityDetailModelObj?.regisiteredMembersCount as Any,self?.activityDetailModelObj?.waitingCount as Any,self?.activityDetailModelObj?.entryFees as Any,self?.activityDetailModelObj?.likesCount as Any,self?.activityDetailModelObj?.sharesCount as Any,self?.activityDetailModelObj?.organiserPicture as Any,self?.activityDetailModelObj?.userId as Any,self?.activityDetailModelObj?.organisedBy as Any,self?.activityDetailModelObj?.adress as Any,self?.activityDetailModelObj?.interestId as Any,self?.activityDetailModelObj?.interestName as Any,self?.activityDetailModelObj?.colour as Any,self?.activityDetailModelObj?.isJoined as Any,self?.activityDetailModelObj?.isLiked as Any,self?.activityDetailModelObj?.isTimeUp as Any)
                
                //Comments model object Array
                let commentsModelResponseArray = (activityDetailApiResponseRecievedArray[0] as? ActivityDetailModel)?.commentsCollection
                
                for eachModelObj in commentsModelResponseArray!{
                    
                    let commentsModelObj = eachModelObj as commentsModel
                    
                    print(commentsModelObj.userId as Any, commentsModelObj.firstName as Any, commentsModelObj.thumbUrl as Any, commentsModelObj.commentId as Any, commentsModelObj.commentsText as Any, commentsModelObj.reviewsCount as Any)
                }
                
                //For Members model object Array
                let membersModelResponseArray = (activityDetailApiResponseRecievedArray[0] as? ActivityDetailModel)?.membersCollection
                
                for eachObj in membersModelResponseArray!{
                    
                    let membersModelObj = eachObj as membersModel
                    
                    print(membersModelObj.userId as Any, membersModelObj.firstName as Any, membersModelObj.thumbUrl as Any, membersModelObj.averageRating as Any, membersModelObj.memberStatus as Any, membersModelObj.memberRole as Any)
                    
                }
                
                //For Ratings model object arrya
                let ratingsModelResponseArray = (activityDetailApiResponseRecievedArray[0] as? ActivityDetailModel)?.ratingsCollection
                
                for eachObj in ratingsModelResponseArray!{
                    
                    let ratingModelObj = eachObj as ratingsModel
                    print(ratingModelObj.ratingId as Any,ratingModelObj.reviewsText as Any,ratingModelObj.ratingTotal as Any,ratingModelObj.createdDataAndTime as Any,ratingModelObj.reviewerId as Any,ratingModelObj.reviewedBy as Any,ratingModelObj.reviewerImageUrl as Any,ratingModelObj.reviewerAvergeRating as Any,ratingModelObj.reviewerRatingsCount as Any,ratingModelObj.reviewesByThisUser as Any)
                    
                }
                
            }
            
        })

    }
    
    //MARK:- Table view supporting methods
    public func getNumberOfSection() -> Int? {
        
        let numberOfSectionsInTableView: Int? = ((self.activityDetailModelObj != nil) ? 1 : 0)
        
        return numberOfSectionsInTableView
        
    }
    
    func getNumberOfRowsOfTableView(sectionNumber:Int?) -> Int? {
        
        var tableViewRowsCount: Int?

        guard (self.activityDetailModelObj != nil) else {
            
            tableViewRowsCount = 0
            
            return tableViewRowsCount
        }
        
        switch sectionNumber! {
            
        case 0:
            
            tableViewRowsCount = 1
            
        case 1:
            
            tableViewRowsCount = 1
            
        case 2:
            
            tableViewRowsCount = 4
            
        case 3:
            
            tableViewRowsCount = 3
            
        default:
            
            tableViewRowsCount = 0
            
        }
        
        return tableViewRowsCount
    }
    
    func getHeightOfEachSectionCellOfTableView(sectionNumber:Int?) -> CGFloat?{
        
        var rowHeight: CGFloat?
        
        guard (self.activityDetailModelObj != nil) else {
            
            rowHeight = 0
            
            return rowHeight
        }
        
        switch sectionNumber! {
            
        case 0:
            
            rowHeight = 225
            
        case 1:
            
            rowHeight = 91
            
        case 2:
            
            rowHeight = 190
            
        case 3:
            
            rowHeight = 150
            
        default:
            
            rowHeight = 0
            
        }
        
        return rowHeight
    }
    
}
