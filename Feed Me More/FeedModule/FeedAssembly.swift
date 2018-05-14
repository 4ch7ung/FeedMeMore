//
//  FeedAssembly.swift
//  Feed Me More
//
//  Created by macbook on 12.05.2018.
//  Copyright © 2018 4ch7ung. All rights reserved.
//

import UIKit

protocol ModuleAssembly {
    func assembleModule() -> UIViewController
}

class FeedAssembly: ModuleAssembly {
    func assembleModule() -> UIViewController {
        let api = GazetaRuFeedAPIFactory().createAPI()
        let vm = FeedViewModel(api: api)
        let viewController = FeedViewController(viewModel: vm)
        vm.delegate = viewController
        return viewController
    }
}
