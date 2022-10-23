//
//  BTCRecordSortViewController.swift
//  Bitcoins
//
//  Created by SukPoet on 2022/10/22.
//

import UIKit

enum CurrencyName: String {
    case usd
    case gbp
    case eur
}

class BTCRecordSortViewController: UIViewController {

    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint!
    var leastConstraint: CGFloat = 0.0
    var interactionInProgress = false
    var pageAppearFirstTime = true
    var interactionController = UIPercentDrivenInteractiveTransition()
    var currencyName2SortBy = CurrencyName.usd
    var is2SortAscend = false
    let currencyTypes = ["USD","GBP","EUR"]
    var shouldResort = false
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if pageAppearFirstTime {
            leastConstraint = (view.bounds.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom) / 1.8
            contentViewTopConstraint.constant = leastConstraint
        }
        pageAppearFirstTime = false
    }
    
    @IBAction func onSortButton(_ sender: Any) {
        shouldResort = true
    }
    
    @IBAction func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let translate = sender.translation(in: view)
        let percent = translate.y/view.bounds.size.height
        if sender.state == .began {
            interactionInProgress = true
            dismiss(animated: true)
        } else if sender.state == .changed {
            interactionController.update(percent)
        }  else if sender.state == .ended || sender.state == .cancelled {
            interactionInProgress = false
            let velocity = sender.velocity(in: sender.view)
            interactionController.completionSpeed = 0.5
            if (percent > 0.5 && velocity.y == 0.0) || velocity.y > 0.0 {
                interactionController.finish()
            } else {
                interactionController.cancel()
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BTCRecordSortViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // make sure it only recognizes downward gestures
        if let gestureView = gestureRecognizer.view {
            if let pan = gestureRecognizer as? UIPanGestureRecognizer, gestureView.tag == 101 {
                let translation = pan.translation(in: gestureView)
                let angle = atan2(translation.y, translation.x)
                let isDownward = abs(angle - .pi/2.0) < (.pi / 8.0)
                return isDownward
            } else if let pan = gestureRecognizer as? UIPanGestureRecognizer, gestureView.tag == 102 {
                let translation = pan.translation(in: gestureView)
                let angle = atan2(translation.y, translation.x)
                let isDownward = abs(angle - .pi/2.0) < (.pi / 8.0)
                return isDownward
            } else {
                return true
            }
        } else {
            return true
        }
    }
}

extension BTCRecordSortViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    //MARK: UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 251 {
            return 2
        } else {
            return 3
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView.tag == 251 {
            switch row {
            case 0:
                return NSAttributedString(string: "descend", attributes: [.font: UIFont.systemFont(ofSize: 15.0)])
            default:
                return NSAttributedString(string: "ascend", attributes: [.font: UIFont.systemFont(ofSize: 15.0)])
            }
        } else {
            let text = currencyTypes[row]
            return NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15.0)])
        }
    }
    //MARK: UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 251 {
            switch row {
            case 0:
                is2SortAscend = false
            default:
                is2SortAscend = true
            }
        } else {
            switch row {
            case 0:
                currencyName2SortBy = .usd
            case 1:
                currencyName2SortBy = .gbp
            case 2:
                currencyName2SortBy = .eur
            default:
                currencyName2SortBy = .usd
            }
        }
    }
}
