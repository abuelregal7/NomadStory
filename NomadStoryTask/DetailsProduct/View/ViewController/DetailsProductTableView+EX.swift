//
//  DetailsProductTableView+EX.swift
//  NomadStoryTask
//
//  Created by Ahmed on 6/16/22.
//

import UIKit

//MARK:- extension from DetailsProductViewController for TableViewDataSource and TableViewDelegate
extension DetailsProductViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModelValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = detailsProductTableView.dequeueReusableCell(withIdentifier: DetailsProductTableViewCell.cellID, for: indexPath) as? DetailsProductTableViewCell else { return UITableViewCell() }
        
        // UI elementin cell and load data from local database(dataModelValue)
        cell.imageOutlet.setImageWith(dataModelValue[indexPath.row].imageURL)//.loadImage(item?.imageURL)
        cell.titleLabelOutlet.text = dataModelValue[indexPath.row].name
        cell.priceLabelOutlet.text = "Price : \(dataModelValue[indexPath.row].retailPrice) $"
        
        // this closure in button action to => add data to database(OfflineStorageModel)
        cell.tappedButton = { [weak self] in
            
            guard let self = self else { return }
            
            guard let data = DataModelValue.database.add(OfflineStorageModel.self) else { return }
            data.id = self.dataModelValue[indexPath.row].id
            data.barcode = self.dataModelValue[indexPath.row].barcode
            data.dataModelDescription = self.dataModelValue[indexPath.row].dataModelDescription
            data.imageURL = self.dataModelValue[indexPath.row].imageURL
            data.name = self.dataModelValue[indexPath.row].name
            data.retailPrice = Int16(self.dataModelValue[indexPath.row].retailPrice)
            data.costPrice = Int16(self.dataModelValue[indexPath.row].costPrice ?? 0)
            
            DataModelValue.database.save()
            cell.loveButtonOutlet.setImage(UIImage(named: "loveSubProduct"), for: .normal)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
        //let firstAnimation = AnimationFactory.makeSlideIn(duration: 0.5, delayFactor: 0.05)
        //let secondAnimation = AnimationFactory.makeFade(duration: 0.5, delayFactor: 0.05)
        let thirdAnimation = AnimationFactory.makeMoveUpWithBounce(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
        //let fourthAnimation = AnimationFactory.makeMoveUpWithFade(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
            
        let animator = Animator(animation: thirdAnimation)
            animator.animate(cell: cell, at: indexPath, in: tableView)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
