//
//  MainScreenTableView+EX.swift
//  NomadStoryTask
//
//  Created by Ahmed on 6/16/22.
//

import UIKit

//MARK:- extension from MainScreenViewController for TableViewDataSource and TableViewDelegate
extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return data?.count ?? 0
        }else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // if section = 0 show list cell
        if indexPath.section == 0 {
            guard let cell = mainTableView.dequeueReusableCell(withIdentifier: MainScreenTableViewCell.cellID, for: indexPath) as? MainScreenTableViewCell else { return UITableViewCell() }
            let item = data?[indexPath.row]
            
            // UI elementin cell and load data from local database(dataModelValue)
            cell.imageOutlet.setImageWith(item?.imageURL)
            cell.titleLabelOutlet.text = item?.name
            cell.priceLabelOutlet.text = "Price : \(item?.retailPrice ?? 0) $"
            cell.loveButtonOutlet.setImage(UIImage(named: "loveSubProduct"), for: .normal)
            
            // this closure in button action to => remove data from database(OfflineStorageModel)
            cell.tappedButton = { [weak self] in
                guard let self = self else { return }
                guard let item = self.data?[indexPath.row] else { return }
                self.mainTableView.beginUpdates()
                self.database.delete(object: item)
                self.data?.remove(at: indexPath.row)
                self.mainTableView.deleteRows(at: [indexPath], with: .automatic)
                self.mainTableView.endUpdates()
                cell.loveButtonOutlet.setImage(UIImage(named: "unLoveSubProduct"), for: .normal)
            }
            
            return cell
        }else { // else section = 1 show totalPrice cell
            
            guard let cell = mainTableView.dequeueReusableCell(withIdentifier: TotalPriceTableViewCell.cellID, for: indexPath) as? TotalPriceTableViewCell else { return UITableViewCell() }
            
            /// implement `map and reduce` to calculate total price
            let totalPrice = data?.map { Int($0.retailPrice) }.reduce(0, +)
            
            // UI elementin cell and load data from local database(dataModelValue)
            cell.priceLabelOutlet.text = "Total Price : \(totalPrice ?? 0) $"
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
        let firstAnimation = AnimationFactory.makeSlideIn(duration: 0.5, delayFactor: 0.05)
        //let secondAnimation = AnimationFactory.makeFade(duration: 0.5, delayFactor: 0.05)
        //let thirdAnimation = AnimationFactory.makeMoveUpWithBounce(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
        //let fourthAnimation = AnimationFactory.makeMoveUpWithFade(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
            
        let animator = Animator(animation: firstAnimation)
            animator.animate(cell: cell, at: indexPath, in: tableView)
        }
        
    }
    
    // to make swipe action in cell to remove product with indexPath.row
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete".localized) { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            
            guard let item = self.data?[indexPath.row] else { return }
            self.mainTableView.beginUpdates()
            self.database.delete(object: item)
            self.data?.remove(at: indexPath.row)
            self.mainTableView.deleteRows(at: [indexPath], with: .automatic)
            self.mainTableView.endUpdates()
            completionHandler(true)
            
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // if section = 0, make height = 200
        if indexPath.section == 0 {
            return 200
        }else { // else check if toatPrice = 0 or totalPrice = nil
            let totalPrice = data?.map { Int($0.retailPrice) }.reduce(0, +)
            if totalPrice == 0 || totalPrice == nil { // if totalPrice = 0 or totalPrice = nil, then make height = 0
                return 0
            }else { // else => totalPrice != 0 or totalPrice != nil, then make height = 60
                return 60
            }
        }
    }
    
}
