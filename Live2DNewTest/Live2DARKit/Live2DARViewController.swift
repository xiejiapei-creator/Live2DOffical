//
//  Live2DARViewController.swift
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/28.
//

import UIKit
import ReplayKit
import SceneKit
import ARKit

class Live2DARViewController: UIViewController {
    
    lazy var live2DARView: Live2DARView = {
        let view = Live2DARView()
        view.backgroundColor = .clear
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(live2DARView)
        live2DARView.frame = view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        live2DARView.session.pause()
    }
}
