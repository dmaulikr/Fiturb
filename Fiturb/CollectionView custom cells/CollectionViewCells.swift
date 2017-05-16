//
//  CollectionViewCells.swift
//  Fiturb
//
//  Created by Admin on 20/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class CollectionViewCells: UICollectionViewCell {
    
    //Outlets
    @IBOutlet weak var thematicsListItemImage: UIImageView!

    @IBOutlet weak var cellSubView: UIView!
    
    @IBOutlet weak var thematicslistItemName: UILabel!
    
    @IBOutlet weak var slectedItemtotalCount: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        //Set button border colour
        self.setButtonandSubViewUIAdjustment()
        
    }
    
    //MARK:- Custom cell methods
    func thematicsListImage(image:UIImage?, thematicsListItemText:String?, customCellObj:CollectionViewCells?) -> Void {
        
        //set image
        if let imageName = image {
            
            thematicsListItemImage.image = imageName

        }
        
        //set thematics name
        if let itemText = thematicsListItemText{
            
            thematicslistItemName.text = itemText

        }
        
        //Set Selected and unselected cells background view colour
        if (customCellObj?.isSelected)!{
            
            cellSubView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)

        }
        else{
            
            cellSubView.backgroundColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)

        }
    }

    func updateTotalSelectedItemsCount(count:Int?) -> Void {
        
        if let countValue = count {
            
            self.slectedItemtotalCount.text = String(countValue)

        }
    }
    
    func setButtonandSubViewUIAdjustment() -> Void {
    
            //Sub View
            //cellSubView.layer.masksToBounds = true
        
            cellSubView.backgroundColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
        
            cellSubView.layer.borderWidth = 0
        
            cellSubView.layer.cornerRadius = (cellSubView.frame.size.width/9)
        
        
            //Count text label
            slectedItemtotalCount.layer.masksToBounds = true;
        
            slectedItemtotalCount.layer.cornerRadius = slectedItemtotalCount.frame.size.height/2
    
            slectedItemtotalCount.layer.borderWidth = 2.0
    
            slectedItemtotalCount.layer.borderColor = UIColor.gray.cgColor
        

            
        }
    
}
