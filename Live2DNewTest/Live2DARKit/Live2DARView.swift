//
//  Live2DARView.swift
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/29.
//

import UIKit
import SceneKit
import ARKit
import SnapKit

class Live2DARView: Live2DView {
    
    /// 将SceneKit中的虚拟3D内容融入增强现实体验的视图。
    /// ARSCNView类提供了最简单的方法来创建增强现实体验，将虚拟3D内容与真实世界的设备摄像头视图融合在一起
    /// 当你运行视图提供的ARSession对象时：视图自动渲染来自设备摄像头的实时视频作为场景背景
    /// 视图会自动移动它的SceneKit摄像头，以匹配设备的真实移动
    lazy var sceneView: ARSCNView = {
        let view = ARSCNView()
        view.backgroundColor = .clear
        return view
    }()
    
    /// ARSession对象综合了以下结果，以建立设备所在的现实世界和AR内容建模的虚拟空间之间的对应关系
    /// 这些过程包括从设备的体感硬件读取数据，控制设备内置的摄像头，并对摄像头捕捉到的图像进行图像分析
    /// 暂停时，会话不跟踪设备运动或捕捉场景图像
    /// 也不与它的委托对象协调或更新任何相关的ARSCNView或ARSKView对象
    /// viewWillDisappear 调用 session.pause()
    var session: ARSession {
        return sceneView.session
    }
    
    /// 更新人物模型动作
    private let contentUpdater = ContentUpdater()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        UserDefaults.standard.set(true, forKey: "UseAR")
        
        addSubview(sceneView)
        sceneView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30.0)
            make.width.equalTo(128.0)
            make.height.equalTo(240.0)
        }
        
        sceneView.delegate = contentUpdater
        session.delegate = self
        
        // 指定ARKit是否在视图的场景中创建和更新SceneKit灯光
        // 如果该值为true(默认值)，视图会自动创建一个或多个SCNLight对象
        // 将它们添加到场景中，并更新它们的属性以反映来自摄像机场景的估计光照信息
        // 如果你想直接控制SceneKit场景中的所有照明，请将此值设置为false
        sceneView.automaticallyUpdatesLighting = true
        
        // 大多数应用程序在短时间内没有触摸用户输入时
        // 系统会让设备进入睡眠状态，屏幕会变暗，这样做是为了节约能源
        // 游戏可以通过将该属性设置为true，禁用空闲计时器以避免系统休眠
        UIApplication.shared.isIdleTimerDisabled = true
        
        // 人脸跟踪配置
        configARFaceTracking()
    }
    
    func hideSceneView(hide: Bool) {
        sceneView.isHidden = hide
    }
    
    /// 人脸跟踪配置
    private func configARFaceTracking() {
        // 人脸跟踪配置可以检测设备前置摄像头3米内的人脸
        // 当ARKit检测到人脸时，它会创建一个ARFaceAnchor对象
        // 该对象提供关于人脸位置、方向、拓扑结构和表情的信息
        // 要确定设备是否支持人脸跟踪，在尝试使用此配置之前
        // 在ARFaceTrackingConfiguration上调用isSupported
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        
        // 当这个值为true(默认值)时
        // 一个正在运行的AR会话在它捕获的每个ARFrame对象的lightEstimate属性中提供场景照明信息
        configuration.isLightEstimationEnabled = true
        
        // 使用指定的配置和选项启动会话的AR处理
        // 配置：为会话定义运动和场景跟踪行为的对象
        // 选项：影响现有会话状态(如果有的话)如何转换到新配置的选项
        // 如果会话是首次运行，此参数无效
        
        // 默认情况下，当你在之前运行或已经运行的会话上调用run(_:options:)方法时
        // 会话将从其最近的已知状态恢复设备位置跟踪
        // 例如，ARAnchor对象保持其相对于相机的明显位置
        // 当你用与会话当前配置相同类型的配置调用run(_:options:)方法时
        // 你可以添加这个选项来强制设备位置跟踪返回到初始状态
        // 当使用与会话当前配置不同类型的配置调用run(_:options:)方法时
        // 会话总是重置跟踪(也就是说，此选项是隐式启用的)
        // 在这两种情况下，当你重置跟踪时，ARKit也会从会话中移除任何现有的锚。
        
        // 默认情况下，当您在之前运行或已经运行的会话上调用run(_:options:)方法时
        // 会话将保留您之前添加的任何ARAnchor对象
        // 也就是说，AR场景中的对象保持它们在现实世界中相对于设备的明显位置(除非你启用resetTracking选项)
        // 如果更改会话配置应该使AR场景中对象的实际位置失效，则启用removeExistingAnchors选项
        // 例如，如果你在AR场景中添加了位置与现实物体相关的虚拟内容
        // 移除这些锚点，这样你就可以重新评估合适的现实位置
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}

extension Live2DARView: ARSessionDelegate {
    
    func sessionInterruptionEnded(_ session: ARSession) {
        DispatchQueue.main.async {
            self.configARFaceTracking()
        }
    }
}
