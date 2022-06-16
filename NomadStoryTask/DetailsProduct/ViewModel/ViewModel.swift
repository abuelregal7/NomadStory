//
//  ViewModel.swift
//  NomadStory
//
//  Created by Ahmed on 6/15/22.
//

import Foundation
import Combine

protocol ViewModelProtocol {
    
    var userData: DataModel? { get }
    var userDataPublisher: Published<DataModel?>.Publisher { get }
    
    var userDataValue: DataModelValue? { get }
    var userDataValuePublisher: Published<DataModelValue?>.Publisher { get }
    
    var isError: String { get set }
    var isErrorPublisher: Published<String>.Publisher { get }
    
    var isLoading: Bool {get set}
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    
    var isReloading: Bool {get set}
    var isReloadingPublisher: Published<Bool>.Publisher { get }
    
//    var startGoToHomePage: Bool { get }
//    var startGoToHomePagePublisher: Published<Bool>.Publisher { get }
//
    func fetchData()
    
}

class ViewModel: ViewModelProtocol {
    
    @Published var userData: DataModel?
    var userDataPublisher: Published<DataModel?>.Publisher{$userData}
    
    @Published var userDataValue: DataModelValue?
    var userDataValuePublisher: Published<DataModelValue?>.Publisher{$userDataValue}
    
    @Published var isLoading: Bool = false
    var isLoadingPublisher: Published<Bool>.Publisher {$isLoading}
    
    @Published var isReloading: Bool = false
    var isReloadingPublisher: Published<Bool>.Publisher {$isReloading}
    
    @Published var isError: String = ""
    var isErrorPublisher: Published<String>.Publisher{$isError}
    
    //Combine networking
    var apiDelegate: FetchDataAPIProtocol?
    
    var subscriptions = Set<AnyCancellable>()
    let service = FetchDataAPI(networkRequest: NativeRequestable(), environment: .production)
    let database = DatabaseHandler.shared
    
    init(apiDelegate: FetchDataAPIProtocol = FetchDataAPI(networkRequest: NativeRequestable(), environment: .production)){
        self.apiDelegate = apiDelegate
    }
    
    func fetchData() {
        isLoading = true
        apiDelegate?.fetchData().sink { [weak self] (completion) in
            guard let self = self else { return }
            switch completion {
            case .failure(let error):
                self.isLoading = false
                self.isError = error.localizedDescription
                print("oops got an error \(error.localizedDescription)")
                print(self.isError)
                
            case .finished:
                print("nothing much to do here => finished => done")
            }
        } receiveValue: { [weak self] (response) in
            guard let self = self else { return }
            self.isLoading = false
            print("got my response here : \(response)")
            self.userData = response
            
            response.forEach{
                self.userDataValue = $0.value
            }
            
            self.isReloading = true
            
            guard let data = DataModelValue.database.add(OfflineStorageModel.self) else { return }
            
//            for result in response {
//
//                print(result)
//
//                data.id = result.value.id
//                data.barcode = result.value.barcode
//                data.dataModelDescription = result.value.dataModelDescription
//                data.imageURL = result.value.imageURL
//                data.name = result.value.name
//                data.retailPrice = Int16(result.value.retailPrice)
//                data.costPrice = Int16(result.value.costPrice ?? 0)
//
//                DataModelValue.database.save()
//            }
            
            DataModelValue.database.save()
            
            response.forEach {
                print($0.value)
                $0.value.store()
            }
            
        }
        .store(in: &subscriptions)
    }
    
}
