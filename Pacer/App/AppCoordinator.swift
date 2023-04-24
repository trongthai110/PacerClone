//
//  AppCoordinator.swift
//  Pacer
//
//  Created by Nguyen Dang Trong Thai on 4/6/23.
//

import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> Observable<Void> {
        //let homeCoordinator = HomeCoordinator(window: window)
        let homeCoordinator = MainTabCoordinator()
        return coordinate(to: homeCoordinator)
    }
}
