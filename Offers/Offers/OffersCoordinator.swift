//
//  OffersCoordinator.swift
//  Offers
//
//  Created by Igor on 30.06.2020.
//  Copyright © 2020 Igor Gapanovich. All rights reserved.
//

import UIKit
import UI
import Models
import Core
import Pic
import Reviews


public final class OffersCoordinator: BaseCoordinator {
    
    private weak var rootController: NavigationController?
    private let reviewsControllerFactory: ViewControllerFactory
    
    public init(rootController: NavigationController) {
        self.rootController = rootController
        self.reviewsControllerFactory = ViewControllerFactory()
        super.init()
    }
    
    public override func start() {
        rootController?.setNavigationBarHidden(true, animated: true)
        showListOfOffersController()
    }
    
    private func showListOfOffersController() {
        let controller = reviewsControllerFactory.makeListOfOffersController()
        
        controller.onOfferController = { [weak self] offer in
            self?.showOfferController(offer: offer)
        }
        
        rootController?.viewControllers = [controller]
    }
    
    private func showOfferController(offer: FakeOffer) {
        let controller = reviewsControllerFactory.makeOfferController()
        controller.offer = offer
        
        controller.onPicController = { [weak self] offerID, scrollToItem in
            self?.showPicController(offerID: offerID, scrollToItem: scrollToItem)
        }
        
        controller.onReviewsController = { [weak self] offerID in
            self?.showReviewsController(offerID: offerID)
        }
        
        if nil != rootController?.viewControllers.last as? ListOfOffersController {
            rootController?.pushViewController(controller, animated: true)
        } else {
            rootController?.pushViewController(controller, animated: true)
        }
    }
    
    private func showPicController(offerID: Int, scrollToItem: Int) {
        let picCoordinator = PicCoordinator(rootController: self.rootController!,
                                            offerID: offerID,
                                            scrollToItem: scrollToItem)
        picCoordinator.start()
    }
    
    private func showReviewsController(offerID: Int) {
        let picCoordinator = ReviewsCoordinator(rootController: self.rootController!,
                                                offerID: offerID)
        picCoordinator.start()
    }
    
    private func showError(error: Error) {
        print("Error \(error.localizedDescription)")
    }
}
