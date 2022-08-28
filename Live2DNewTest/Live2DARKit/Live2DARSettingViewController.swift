//
//  Live2DARSettingViewController.swift
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/27.
//

import UIKit

class Live2DARSettingViewController: UIViewController {
    
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var zoomSlider: UISlider!
    @IBOutlet weak var xPositionSlider: UISlider!
    @IBOutlet weak var yPositionSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        zoomSlider.value = defaults.float(forKey: ZOOM)
        xPositionSlider.value = defaults.float(forKey: X_POS)
        yPositionSlider.value = defaults.float(forKey: Y_POS)
        
        updateInfo()
    }
    
    @IBAction func handleZoomSlider(_ sender: UISlider) {
        let defaults = UserDefaults.standard
        defaults.set(zoomSlider.value, forKey: ZOOM)
        updateInfo()
    }
    
    @IBAction func handleXPosition(_ sender: UISlider) {
        let defaults = UserDefaults.standard
        defaults.set(xPositionSlider.value, forKey: X_POS)
        updateInfo()
    }
    
    @IBAction func handleYPosition(_ sender: UISlider) {
        let defaults = UserDefaults.standard
        defaults.set(yPositionSlider.value, forKey: Y_POS)
        updateInfo()
    }
    
    @IBAction func handleReset(_ sender: UIButton) {
        restoreDefault()
    }
    
    // MARK: - 文本框内容
    
    /// 更新文本框显示内容
    private func updateInfo() {
        infoTextView.text = generateInfo()
    }
    
    /// 生成文本框信息
    private func generateInfo() -> String {
        let defaults = UserDefaults.standard
        let zoom = defaults.float(forKey: ZOOM)
        let y_pos = defaults.float(forKey: Y_POS)
        let x_pos = defaults.float(forKey: X_POS)
        
        return "Zoom: \(zoom)\nY-Pos: \(y_pos)\nX-Pos: \(x_pos)\n"
    }
    
    // MARK: - 重置默认信息
    
    private func restoreDefault() {
        let alert = UIAlertController(title: "警告", message: "您确定要恢复默认设置吗?", preferredStyle: .alert)
        alert.addAction(.init(title: "恢复", style: .destructive, handler: { _ in
            let defaults = UserDefaults.standard
            defaults.set(ZOOM_DEFAULT, forKey: ZOOM)
            defaults.set(X_POS_DEFAULT, forKey: X_POS)
            defaults.set(Y_POS_DEFAULT, forKey: Y_POS)
            self.updateInfo()
        }))
        alert.addAction(.init(title: "取消", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
