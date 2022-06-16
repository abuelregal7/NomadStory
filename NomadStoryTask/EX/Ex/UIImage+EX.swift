//
//  UIImage+EX.swift
//  EverDeliever
//
//  Created by Ahmed on 4/7/22.
//

import Foundation
import UIKit
import Kingfisher


extension UIImageView {

    @discardableResult
    private func downloadImage(_ url: URL, _ placeholderImage: UIImage?) -> DownloadTask? {
        kf.indicatorType = .activity
        kf.indicator?.startAnimatingView()
        return self.kf.setImage(with: url, placeholder: placeholderImage, completionHandler:  { [weak self] result in
            guard let self = self else { return }
            self.kf.indicator?.stopAnimatingView()
            
            switch result {
            case .success(let value):
                self.image = value.image
            case .failure(let error):
                self.image = placeholderImage
                debugPrint(error.errorDescription ?? "Error")
            }
        })
    }

    func setImageWith(_ linkString: String?, _ placeholderImage: UIImage? = nil) {
        guard let linkString = linkString, let url = URL(string: linkString) else { return }
        downloadImage(url, placeholderImage)
    }

    func setImageWith(url: URL?, _ placeholderImage: UIImage? = nil) {
        guard let url = url else { return }
        downloadImage(url, placeholderImage)
    }
}

extension UIImageView {
    func loadProfileCover(_ url : String?) {
        
        guard let linkString = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)  , let url = URL(string: linkString) else { return }
        
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "background"),
            options: [
                
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
                
            ])
        
        self.kf.indicatorType = .activity
        
    }
    func loadImageProfile(_ url : String?) {
        
        guard let linkString = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)  , let url = URL(string: linkString) else { return }
        
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "profile"),
            options: [
                
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
                
            ])
        
        self.kf.indicatorType = .activity
        
    }
    func loadImage(_ url : String?) {
        //ahn800
        //placeholder_2
        
        guard let linkString = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)  , let url = URL(string: linkString) else { return }
        
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder3"),
            options: [
                
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
                
            ])
        
        self.kf.indicatorType = .activity
        
    }
    
    func loadChatImage(_ url : String?) {
        //ahn800
        //placeholder_2
        
        guard let linkString = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)  , let url = URL(string: linkString) else { return }
        
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "noun-send-3993472"),
            options: [
                
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
                
            ])
        
        self.kf.indicatorType = .activity
        
    }
}
