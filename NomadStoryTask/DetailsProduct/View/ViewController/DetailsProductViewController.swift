//
//  DetailsProductViewController.swift
//  NomadStory
//
//  Created by Ahmed on 6/15/22.
//

import UIKit
import Combine
import CombineCocoa

class DetailsProductViewController: UIViewController {
    
    @IBOutlet weak var detailsProductTableView: UITableView!
    
    let viewModel: ViewModelProtocol = ViewModel(apiDelegate: FetchDataAPI(networkRequest: NativeRequestable(), environment: .production))
    
    // AnyCancellable
    var subscripation = Set<AnyCancellable>()
    
    @Published var dataModelValue = [DataModelValue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchData()
        configureTableView()
        bindingLoadingToViewModel()
        sinkToIsReloadPublisher()
        sinkToUserDataValuePublisher()
        
    }
    
    //MARK:- configureTableView
    func configureTableView() {
        
        detailsProductTableView.delegate = self
        detailsProductTableView.dataSource = self
        detailsProductTableView.separatorStyle = .none
        detailsProductTableView.register(UINib(nibName: DetailsProductTableViewCell.cellID, bundle: nil),
                                         forCellReuseIdentifier: DetailsProductTableViewCell.cellID)
        
    }
    
    //MARK:- Binding Loading To ViewModel
    func bindingLoadingToViewModel() {
        viewModel.isLoadingPublisher.sink { [weak self] state in
            guard let self = self else { return }
            state ? Hud.showHud(in: self.view) : Hud.dismiss()
        }.store(in: &subscripation)
    }
    
    //MARK:- Sink To IsReloadPublisher
    func sinkToIsReloadPublisher() {
        viewModel.isReloadingPublisher.sink { [weak self] (reload) in
            
            guard let self = self else { return }
            
            if reload == true {
                self.detailsProductTableView.reloadData()
            }
            
        }.store(in: &subscripation)
    }
    
    //MARK:- Sink To sinkToUserDataValuePublisher
    func sinkToUserDataValuePublisher() {
        viewModel.userDataValuePublisher.sink { [weak self] (result) in
            
            guard let self = self else { return }
            
            print("result =>  : \(result)")
            
            self.dataModelValue.append(contentsOf: result ?? [])
            
        }.store(in: &subscripation)
    }
    
}

//MARK:- extension from DetailsProductViewController for TableViewDataSource and TableViewDelegate
extension DetailsProductViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModelValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = detailsProductTableView.dequeueReusableCell(withIdentifier: DetailsProductTableViewCell.cellID, for: indexPath) as? DetailsProductTableViewCell else { return UITableViewCell() }
        
        
        cell.imageOutlet.setImageWith(dataModelValue[indexPath.row].imageURL)//.loadImage(item?.imageURL)
        cell.titleLabelOutlet.text = dataModelValue[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
