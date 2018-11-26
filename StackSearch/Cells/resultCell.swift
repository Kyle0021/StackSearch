//
//  resultCell.swift
//  StackSearch
//
//  Created by Kyle Carlos Fernandez on 2018/11/24.
//  Copyright © 2018 KyleApps. All rights reserved.
//

import Foundation
import UIKit

class resultCell: UITableViewCell
{
    //outlets for the result cell
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var lblOwnerName: UILabel!
    
    @IBOutlet var lblVotes: UILabel!
    
    @IBOutlet var lblAnswers: UILabel!
    
    @IBOutlet var lblViews: UILabel!
    
    @IBOutlet var btnCheck: UIButton!

    @IBOutlet var btnCheckLayoutConst: NSLayoutConstraint!
}
