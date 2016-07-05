//
//  ViewController.swift
//  ARSProgress
//
//  Created by Tharindu Gamlath on 5/16/16.
//  Copyright © 2016 Tharindu Gamlath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnShowSuccess(sender: AnyObject) {
        
        if ARSLineProgress.shown { return }
        
        progressObject = NSProgress(totalUnitCount: 100)
        ARSLineProgress.showWithProgressObject(progressObject!, completionBlock: {
            print("Success completion block")
        })
        
        progressDemoHelper(success: true)
    }

    @IBAction func btnShowFailed(sender: AnyObject) {
        
        if ARSLineProgress.shown { return }
        
        progressObject = NSProgress(totalUnitCount: 100)
        ARSLineProgress.showWithProgressObject(progressObject!, completionBlock: {
        })
        
        progressDemoHelper(success: false)
    }
    
    
    @IBAction func btnShowLoader(sender: AnyObject) {
        if ARSLineProgress.shown { return }
        
        ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
            print("Showed with completion block")
        }
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
//            ARSLineProgress.hideWithCompletionBlock({ () -> Void in
//                print("Hidden with completion block")
//            })
//        })
    }
    
    @IBAction func stop(sender: AnyObject) {
        
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                    ARSLineProgress.hideWithCompletionBlock({ () -> Void in
                        print("Hidden with completion block")
                    })
                })
    }
    
    @IBOutlet var btnWithoutAnimation: UIButton!
    
    @IBAction func btnAnimation(sender: AnyObject) {
        if ARSLineProgress.shown { return }
        
        ARSLineProgressConfiguration.showSuccessCheckmark = false
        
        progressObject = NSProgress(totalUnitCount: 100)
        ARSLineProgress.showWithProgressObject(progressObject!, completionBlock: {
                        ARSLineProgressConfiguration.restoreDefaults()
        })
        
        progressDemoHelper(success: true)
    }
    
    
    
}


// MARK: Helper Demo Methods

private var progress: CGFloat = 0.0
private var progressObject: NSProgress?
private var isSuccess: Bool?

extension ViewController {
    
    private func progressDemoHelper(success success: Bool) {
        isSuccess = success
        launchTimer()
    }
    
    private func launchTimer() {
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.7 * Double(NSEC_PER_SEC)));
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            progressObject!.completedUnitCount += Int64(arc4random_uniform(30))
            
            if isSuccess == false && progressObject?.fractionCompleted >= 0.7 {
                ARSLineProgress.cancelPorgressWithFailAnimation(true, completionBlock: {
                    print("Hidden with completion block")
                })
                return
            } else {
                if progressObject?.fractionCompleted >= 1.0 { return }
            }
            
            self.launchTimer()
        })
    }
    
}

