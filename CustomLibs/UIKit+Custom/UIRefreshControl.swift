//
//  UIRefreshControl.swift
//
//  Created by Lakhwinder Singh on 31/03/17.
//  Copyright © 2017 lakh. All rights reserved.
//

import UIKit

extension UIRefreshControl {

    func endRefreshingIfNeeded() {
        if isRefreshing {
            endRefreshing()
        }
    }
}


