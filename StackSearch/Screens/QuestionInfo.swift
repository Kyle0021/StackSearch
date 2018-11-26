//
//  QuestionInfo.swift
//  StackSearch
//
//  Created by Kyle Carlos Fernandez on 2018/11/25.
//  Copyright © 2018 KyleApps. All rights reserved.
//

import UIKit
import WebKit

class QuestionInfo: UIViewController {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var txtView: UITextView!
    @IBOutlet var lblTags: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblOwnerName: UILabel!
    @IBOutlet var lblReputation: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var labelContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set all question information
        lblTitle.text = resultsArr[selectedIndex]["title"] as? String
        lblOwnerName.text = (resultsArr[selectedIndex]["owner"] as? NSDictionary)?.value(forKey: "display_name") as? String
        lblTags.text = resultsArr[selectedIndex]["tags"] as? String
        lblReputation.text = "\(String(describing: (resultsArr[selectedIndex]["owner"] as? NSDictionary)?.value(forKey: "reputation") as! Int))"

        // tags are in an array
        // we loop through the tags and build a string,
        // then we set the label value to the string
        var stringTags = ""
        for item in resultsArr[selectedIndex]["tags"] as! NSArray {
        
            if stringTags == ""
            {
                stringTags = (item as! String)
            }
            else
            {
                stringTags = stringTags + ", " + (item as! String)
            }
            
        }
        lblTags.text = stringTags
        labelContainer.layer.masksToBounds = true
        labelContainer.layer.borderWidth = 0.5
        labelContainer.layer.borderColor = UIColor.lightGray.cgColor
     
        // Get and set readable date
        let date = NSDate(timeIntervalSince1970: (resultsArr[selectedIndex]["creation_date"] as? TimeInterval)!)
        let dateString = self.convertDateFormate(date: date as Date)
        lblDate.text =  dateString

        // load question in UITextView
        let htmlData = NSString(string: (resultsArr[selectedIndex]["body"] as? String)!).data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
        txtView.attributedText = attributedString
        txtView.isScrollEnabled = true
        txtView.showsHorizontalScrollIndicator = true
        
        // set profile image
        let url = URL(string: ((resultsArr[selectedIndex]["owner"] as? NSDictionary)?.value(forKey: "profile_image") as? String)! )
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.imgView.image = UIImage(data: data!)
            }
        }
    }
    
    // date converter
    // use to customise the date
    func convertDateFormate(date : Date) -> String{
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "MMMM yyyy"
        let secondDateFormate = DateFormatter()
        secondDateFormate.dateFormat = "HH:mm"
        let newDate = dateFormate.string(from: date)
        let secondDatePart = secondDateFormate.string(from: date)
        
        var day  = "\(anchorComponents.day!)"
        switch (day) {
        case "1" , "21" , "31":
            day.append("st")
        case "2" , "22":
            day.append("nd")
        case "3" ,"23":
            day.append("rd")
        default:
            day.append("th")
        }
        
        return "asked " + day + " " + newDate + " at " + secondDatePart
    }
}
