//
//  ActionCell.swift
//  Fitness-Lab
//
//  Created by 張書涵 on 2018/9/21.
//  Copyright © 2018年 AliceChang. All rights reserved.
//

import UIKit

class ActionCell: UITableViewCell {

    @IBOutlet weak var timeDescription: UILabel!
    @IBOutlet weak var actionDescription: UILabel!
    
    
    func updateView(actionModel: ActionModel) {
        timeDescription.text = actionModel.timesDescription
        actionDescription.text = actionModel.actionDescription
        contentView.backgroundColor = #colorLiteral(red: 0.09411764706, green: 0.09411764706, blue: 0.09411764706, alpha: 1)
    }
}
