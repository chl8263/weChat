//
//  ConpassViewController.swift
//  weChat
//
//  Created by admin2 on 2018. 6. 6..
//  Copyright © 2018년 admin2. All rights reserved.
//

import UIKit

class CompassViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let statusBar = UIView()
        self.view.addSubview(statusBar)
        
        statusBar.snp.makeConstraints{(m) in
            
            m.right.top.left.equalTo(self.view)
            m.height.equalTo(20)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
