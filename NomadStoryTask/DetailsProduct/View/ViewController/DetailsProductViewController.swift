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
    
    // properties
    // detailsProductTableView outlet
    @IBOutlet weak var detailsProductTableView: UITableView!
    
    // viewModel
    let viewModel: ViewModelProtocol = ViewModel(apiDelegate: FetchDataAPI(networkRequest: NativeRequestable(), environment: .production))
    
    // AnyCancellable
    var subscripation = Set<AnyCancellable>()
    
    // Published var for combine
    @Published var dataModelValue = [DataModelValue]()
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Produts"
        // call combine functions and configure tableView
        viewModel.fetchData()
        configureTableView()
        bindingLoadingToViewModel()
        sinkToIsReloadPublisher()
        sinkToUserDataValuePublisher()
        
    }
    
    //MARK:- configure TableView
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
            
            print("result of userDataValuePublisher =>  : \(result ?? [])")
            
            self.dataModelValue.append(contentsOf: result ?? [])
            
        }.store(in: &subscripation)
    }
    
}

