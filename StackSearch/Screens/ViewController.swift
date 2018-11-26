//
//  ViewController.swift
//  StackSearch
//
//  Created by Kyle Carlos Fernandez on 2018/11/23.
//  Copyright © 2018 KyleApps. All rights reserved.
//

import UIKit
import Foundation

var selectedIndex = Int()
var resultsArr = [NSDictionary]()

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, APIDelegate {

    @IBOutlet var lblLabelPlaceHolder: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var loadingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup outlets that need to be hidden, color changed, or receive borders
        loadingView.isHidden = true
        lblLabelPlaceHolder.isHidden = true
        searchBar.delegate = self
        searchBar.layer.borderColor = UIColor.init(rgb: 0x4078c4).cgColor
        searchBar.layer.borderWidth = 1
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor.white
        tableView.isScrollEnabled = false
        
        //change the color of the status bar view
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor.init(rgb: 0x4078C4)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
    }

    // Hide the navigation bar on this screen
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    // unhide navigation bar so that it will be displayed on the next screen
   override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    // user clicked searchbutton
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadingView.isHidden = false
        
        // performs method call
        let connector = APIConnector(delegate: self)
        connector.getMethod(pageSize: "20", tag: searchBar.text!)
        
        // Hide the keyboard
        searchBar.resignFirstResponder()
    }

    // display the cancel button when the user starts typing in the searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBar.showsCancelButton = true
    }
    
    // if the user clicks the cancel button, clear the searchbar, hide the cancel button, and remove the keyboard
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
   
    // set the number of sections to the amount of results returned
    func numberOfSections(in tableView: UITableView) -> Int {
        
        // Hide and show the default label being shown when no results are displayed.
        if resultsArr.count == 0
        {
            lblLabelPlaceHolder.isHidden = false
        }
        else{
            lblLabelPlaceHolder.isHidden = true
        }
        
        return resultsArr.count
    }
    
    // set the number of rows per section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    // set height between each cell
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        // if first or last cell, add some extra padding
        if section == 0 || section == resultsArr.count
        {
           return 10
        }
        else
        {
            return 5
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create reusable cell
        // set all the outlets information
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! resultCell
        
            cell.btnCheck.isHidden = true
            cell.layer.masksToBounds = true
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.init(rgb: 0x8f8e94).cgColor
        
            cell.lblTitle.text = resultsArr[indexPath.section]["title"] as? String
            cell.lblAnswers.text = String((resultsArr[indexPath.section]["answer_count"] as? Int)!) + " " + "answers"
            cell.lblViews.text = String((resultsArr[indexPath.section]["view_count"] as? Int)!) + " " + "views"
            cell.lblVotes.text = String((resultsArr[indexPath.section]["score"] as? Int)!) + " " + "votes"
            cell.lblOwnerName.text = (resultsArr[indexPath.section]["owner"] as? NSDictionary)?.value(forKey: "display_name") as? String
        
        // check image for answered questions
        // when the check image needs to be hidden the check autolayout constraint size to the container is is decreased,
        // which results in the title label and owner name moving to the left
        //
        if (resultsArr[indexPath.section]["is_answered"]! as? Int) == 1
        {
            cell.btnCheck.isHidden = false
            cell.btnCheckLayoutConst.constant = 5.0
        }
        else{
      
            cell.btnCheck.isHidden = true
            cell.btnCheckLayoutConst.constant = -10
        }
        
        return cell
    }
    
    // when a questions is selected
    // store the index and perform segue to the next screen
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.section
        searchBar.resignFirstResponder()
        performSegue(withIdentifier: "showQuestionInfo", sender: self)
        
        
    }
    
    // response from method call
    // setting up arrays etc
    func onPostExecute(_ response: NSDictionary) {
        
        resultsArr = response["items"] as! [NSDictionary]
        
        // post execute is run asynchronously, so we need to reload the table data and manipulate objects on the main thread
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.loadingView.isHidden = true
            self.tableView.isScrollEnabled = true
        }
    }
}

