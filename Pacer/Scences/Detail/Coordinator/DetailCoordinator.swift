//
//  DetailCoordinator.swift
//  Pacer
//
//  Created by Nguyen Dang Trong Thai on 4/11/23.
//

import UIKit
import RxSwift

class DetailCoordinator: BaseCoordinator<Void> {

    private let rootViewController: UIViewController

    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    override func start() -> Observable<Void> {
        let viewModel = DetailViewModel(date: Date())
        let viewController = DetailViewController(viewModel: viewModel, date: Date())
        let navigationController = UINavigationController(rootViewController: viewController)
        
        viewController.viewModel = viewModel

        rootViewController.present(navigationController, animated: true)

        return Observable.never()
    }
}
