//
//  ViewController.swift
//  DemoFonCartWebService
//
//  Created by Dan on 8/19/16.
//  Copyright © 2016 dolphin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // const
    let FONCARTAPI_PREFIX = "http://demo.foncart.com/webservices"

    // ui vars
    @IBOutlet weak var outputTextView: UITextView!
    @IBOutlet weak var objectsTableView: UITableView!
    
    // local vars
    var parser = NSXMLParser()
    var objects : [JSON] = []
    var elements = NSMutableDictionary()
    var element = NSString()
    var anObject = ComplexObject()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        objectsTableView.dataSource = self
        objectsTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getEnumerationTapped(sender: UIButton) {
        loadEnumeration()
    }
    
    func loadEnumeration() {
        
        let progress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progress.label.text = "Loading..."
        progress.userInteractionEnabled = false
        
        Alamofire.request(.POST, FONCARTAPI_PREFIX + "/testservice.asmx/GetEnumerationOfComplexObjects").responseString {
            response in
            
            guard response.result.error == nil else {
                print("error : ", response.result.error)
                return
            }
            guard let receivedvalue : String = response.result.value else {
                print("get recent response : Failed")
                return
            }
            
            print("recent response : ", receivedvalue)
            self.outputTextView.text = receivedvalue
            self.parseString(receivedvalue)
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    
    func parseString(sInfo : String) {
        
        var nStart = 0, nEnd = 0
        nStart = sInfo.indexOfCharacter("[")!
        if nStart != 0 {
            nEnd = sInfo.indexOfCharacter("]")!
            if nEnd != 0 {
                var sJson = sInfo.substringWithRange(sInfo.startIndex.advancedBy(nStart)..<sInfo.startIndex.advancedBy(nEnd+1))
                sJson = "{\"myArray\":" + sJson + "}"
                print("\nsJson : " + sJson)
                let jsonobject = JSON(data: sJson.dataUsingEncoding(NSUTF8StringEncoding)!)
                objects = jsonobject["myArray"].arrayValue
                print("\nobjects count : " + String(objects.count))
                objectsTableView.reloadData()
            }
            else {
                print("not found ]")
            }
        }
        else {
            print("not found [")
        }
        
    }
    
    // MARK: - tableview
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ObjectCell", forIndexPath: indexPath) as! ObjectTVCell
        cell.numLabel.text = String(indexPath.row + 1)
        cell.nameLabel.text = objects[indexPath.row]["Name"].stringValue
        cell.ageLabel.text = objects[indexPath.row]["Age"].stringValue
        cell.dobLabel.text = objects[indexPath.row]["DOB"].stringValue
        cell.urlLabel.text = objects[indexPath.row]["Url"].stringValue
        return cell
    }
    
}

extension String {
    public func indexOfCharacter(char: Character) -> Int? {
        if let idx = self.characters.indexOf(char) {
            return self.startIndex.distanceTo(idx)
        }
        return nil
    }
}
