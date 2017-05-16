//
//  FlashScreenViewController.swift
//  Fiturb
//
//  Created by Admin on 03/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class FlashScreenViewController: UIViewController {
    
    @IBOutlet weak var pageControler: UIPageControl!
    @IBOutlet weak var backGroungImage: UIImageView!
    @IBOutlet weak var scroolObj: UIScrollView!
    var timer = Timer()
    
    var counter = -1
    
    var imageArray: Array = ["SlideImageOne","SlideImageTwo","SlideImageThree"]
    
    //MARK:- Life cycle methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true

        scroolObj.isPagingEnabled = true
        
        scroolObj.contentSize = CGSize(width: self.view.frame.size.width * 3, height: self.view.frame.size.height)
        
        self.configurePageControl()
        
        //Start timer
        self.startTimer()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _ = self.navigationController?.isNavigationBarHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool){
        
        super.viewWillDisappear(animated)
        
        //Stop timer
        if timer.isValid {
            
            //Stop timer
            self.stopTimer()
        }
        
    }
    
    //MARK:- Private Methods
    // called every time interval from the timer
    func timerAction() {
        
        counter += 1
        let number = counter
        
        if  number <= 2{
            
            pageControler.currentPage = number
            
            changeImage()
            
        }
        else{
            
            counter = -1
            timerAction()
        }
        
    }
    
    func configurePageControl() {
        
        self.pageControler.numberOfPages = 3
        self.pageControler.currentPage = 0
        //        self.pageControler.tintColor = UIColor.red
        //        self.pageControler.pageIndicatorTintColor = UIColor.white
        //        self.pageControler.currentPageIndicatorTintColor = UIColor.green
    }
    
    func changeImage() -> Void {
        
        backGroungImage.image = UIImage(named:imageArray [pageControler.currentPage])
        
    }
    
    func startTimer() -> Void {
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(FlashScreenViewController.timerAction), userInfo: nil, repeats: true)
    }
    
    func stopTimer() -> Void {
        
        timer.invalidate()
    }
    
    //MARK:- Scroll view Delegate Methods
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //        if timer.isValid {
        //
        //            //Stop timer
        //            self.stopTimer()
        //        }
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        print("Page number is:\(pageNumber)")
        counter = Int(pageNumber)
        pageControler.currentPage = Int(pageNumber)
        
        self.changeImage()
        
    }
    
}
