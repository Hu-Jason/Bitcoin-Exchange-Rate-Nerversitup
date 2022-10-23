//
//  HistoryRateTableViewCell.swift
//  Bitcoins
//
//  Created by SukPoet on 2022/10/21.
//

import UIKit

class HistoryRateTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var usdRateLabel: UILabel!
    @IBOutlet weak var gbpRateLabel: UILabel!
    @IBOutlet weak var eurRateLabel: UILabel!
    
    func refresh(with record: Minute) {
        usdRateLabel.text = "$ \(record.usd?.rate ?? "")"
        gbpRateLabel.text = "£ \(record.gbp?.rate ?? "")"
        eurRateLabel.text = "€ \(record.eur?.rate ?? "")"
    }
}
