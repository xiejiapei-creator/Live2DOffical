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

    /// 设置背景颜色
    @IBAction func handleChangeColor(_ sender: UIButton) {
        let alert = createSetColorAlertController()
        guard let colorTextFields = alert.textFields else { return }

        alert.addAction(UIAlertAction(title: "提交", style: .default, handler: { _ in
            self.submitColor(colorTextFields: colorTextFields)
        }))
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
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
    
    // MARK: - 改变背景颜色弹框
    
    /// 输入弹框
    private func createSetColorAlertController() -> UIAlertController {
        let defaults = UserDefaults.standard
        let alert = UIAlertController(title: "输入颜色值", message: "RGB 颜色值范围在 [0, 255] 之间", preferredStyle: .alert)
        
        // defaults.float(forKey: RED_COLOR) = 0.78
        alert.addTextField { textField in
            textField.placeholder = "红色值"
            textField.text = "\(Int(defaults.float(forKey: RED_COLOR) * 255))"
            textField.keyboardType = .numberPad
        }
        alert.addTextField { textField in
            textField.placeholder = "绿色植"
            textField.text = "\(Int(defaults.float(forKey: GREEN_COLOR) * 255))"
            textField.keyboardType = .numberPad
        }
        alert.addTextField { textField in
            textField.placeholder = "蓝色值"
            textField.text = "\(Int(defaults.float(forKey: BLUE_COLOR) * 255))"
            textField.keyboardType = .numberPad
        }
        
        return alert
    }
    
    /// 展示错误弹框
    private func displayAlert(alertTitle title: String, alertMessage msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确认", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    /// 检测输入的文本
    private func checkInputText(text: String?) -> Bool {
        guard let text = text else {
            self.displayAlert(alertTitle: "错误", alertMessage: "再次尝试")
            return false
        }
        
        if text.isEmpty || text == "" {
            self.displayAlert(alertTitle: "错误", alertMessage: "请输出完整的RGB值")
            return false
        }
        
        // 判断是否仅输入了数字
        let numberOnly = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: text))

        if numberOnly {
            guard let number: Float = Float(text) else { return false }
            
            if self.checkRange(value: number) == false {
                self.displayAlert(alertTitle: "错误", alertMessage: "数字不在 [0,255] 范围内")
                return false
            }
        } else {
            self.displayAlert(alertTitle: "错误", alertMessage: "请仅输入数字")
            return false
        }
        
        return true
    }
    
    /// 校验颜色值范围
    private func checkRange(value: Float) -> Bool {
        return (value >= 0 && value <= 255)
    }
    
    /// 提交颜色值
    private func submitColor(colorTextFields: [UITextField]) {
        var rgb: [Float] = [1 / 255, 1 / 255, 1 / 255]
        for textField in colorTextFields {
            guard checkInputText(text: textField.text) else { return }
                
            // 对应文本框加上相应数值
            guard let index = colorTextFields.firstIndex(of: textField) else { return }
            rgb[index] *= Float(textField.text!)!
        }
        
        // 存储到本地
        for i in 0 ... 2 {
            UserDefaults.standard.set(rgb[i], forKey: colorKeys[i])
        }
        updateInfo()
    }
    
    // MARK: - 文本框内容
    
    /// 更新文本框显示内容
    private func updateInfo() {
        infoTextView.text = generateInfo()
    }
    
    /// 生成文本框信息
    private func generateInfo() -> String {
        let defaults = UserDefaults.standard
        
        let r = defaults.float(forKey: RED_COLOR)
        let g = defaults.float(forKey: GREEN_COLOR)
        let b = defaults.float(forKey: BLUE_COLOR)
        let zoom = defaults.float(forKey: ZOOM)
        let y_pos = defaults.float(forKey: Y_POS)
        let x_pos = defaults.float(forKey: X_POS)
        
        return "R: \(r)\nG: \(g)\nB: \(b)\nZoom: \(zoom)\nY-Pos: \(y_pos)\nX-Pos: \(x_pos)\n"
    }
    
    // MARK: - 重置默认信息
    
    private func restoreDefault() {
        let alert = UIAlertController(title: "警告", message: "您确定要恢复默认设置吗?", preferredStyle: .alert)
        alert.addAction(.init(title: "恢复", style: .destructive, handler: { _ in
            let defaults = UserDefaults.standard
            defaults.set(RED_COLOR_DEFAULT, forKey: RED_COLOR)
            defaults.set(GREEN_COLOR_DEFAULT, forKey: GREEN_COLOR)
            defaults.set(BLUE_COLOR_DEFAULT, forKey: BLUE_COLOR)
            defaults.set(ZOOM_DEFAULT, forKey: ZOOM)
            defaults.set(X_POS_DEFAULT, forKey: X_POS)
            defaults.set(Y_POS_DEFAULT, forKey: Y_POS)
            self.updateInfo()
        }))
        alert.addAction(.init(title: "取消", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
