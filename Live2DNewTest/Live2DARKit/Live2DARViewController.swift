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

    // MARK: - 属性
    
    /// Live2D 视图
    lazy var live2DView: Live2DView = {
        let view = Live2DView()
        view.backgroundColor = .clear
        return view
    }()
    
    /// 更新人物模型动作
    private let contentUpdater = ContentUpdater()
    
    /// 包含启动和控制直播的方法的对象
    private let broadcastController = RPBroadcastController()
    
    /// 将SceneKit中的虚拟3D内容融入增强现实体验的视图。
    /// ARSCNView类提供了最简单的方法来创建增强现实体验，将虚拟3D内容与真实世界的设备摄像头视图融合在一起
    /// 当你运行视图提供的ARSession对象时：视图自动渲染来自设备摄像头的实时视频作为场景背景
    /// 视图会自动移动它的SceneKit摄像头，以匹配设备的真实移动
    @IBOutlet weak var sceneView: ARSCNView!
    
    /// ARSession对象综合了以下结果，以建立设备所在的现实世界和AR内容建模的虚拟空间之间的对应关系
    /// 这些过程包括从设备的体感硬件读取数据，控制设备内置的摄像头，并对摄像头捕捉到的图像进行图像分析
    private var session: ARSession {
        return sceneView.session
    }
    
    // MARK: - 生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(live2DView)
        live2DView.frame = view.bounds

        sceneView.delegate = contentUpdater
        session.delegate = self
        
        // 指定ARKit是否在视图的场景中创建和更新SceneKit灯光
        // 如果该值为true(默认值)，视图会自动创建一个或多个SCNLight对象
        // 将它们添加到场景中，并更新它们的属性以反映来自摄像机场景的估计光照信息
        // 如果你想直接控制SceneKit场景中的所有照明，请将此值设置为false
        sceneView.automaticallyUpdatesLighting = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 大多数应用程序在短时间内没有触摸用户输入时，系统会让设备进入睡眠状态，屏幕会变暗，这样做是为了节约能源
        // 游戏可以通过将该属性设置为true，禁用空闲计时器以避免系统休眠
        UIApplication.shared.isIdleTimerDisabled = true

        // 人脸跟踪配置
        configARFaceTracking()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // 暂停时，会话不跟踪设备运动或捕捉场景图像
        // 也不与它的委托对象协调或更新任何相关的ARSCNView或ARSKView对象
        session.pause()
    }
    
    // 错误信息
    private func errorString(_ error: Error) -> String {
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion,
        ]
        let errorMessage = messages.compactMap { $0 }.joined(separator: "\n")
        return errorMessage
    }
    
    // MARK: - ARFace
    
    /// 人脸跟踪配置
    private func configARFaceTracking() {
        // 人脸跟踪配置可以检测设备前置摄像头3米内的人脸
        // 当ARKit检测到人脸时，它会创建一个ARFaceAnchor对象，该对象提供关于人脸位置、方向、拓扑结构和表情的信息
        // 要确定设备是否支持人脸跟踪，在尝试使用此配置之前，在ARFaceTrackingConfiguration上调用isSupported
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        
        // 当这个值为true(默认值)时，一个正在运行的AR会话在它捕获的每个ARFrame对象的lightEstimate属性中提供场景照明信息
        configuration.isLightEstimationEnabled = true
        
        // 使用指定的配置和选项启动会话的AR处理
        // 配置：为会话定义运动和场景跟踪行为的对象
        // 选项：影响现有会话状态(如果有的话)如何转换到新配置的选项，如果会话是首次运行，此参数无效
        
        // 默认情况下，当你在之前运行或已经运行的会话上调用run(_:options:)方法时，会话将从其最近的已知状态恢复设备位置跟踪
        // 例如，ARAnchor对象保持其相对于相机的明显位置
        // 当你用与会话当前配置相同类型的配置调用run(_:options:)方法时，你可以添加这个选项来强制设备位置跟踪返回到初始状态
        // 当使用与会话当前配置不同类型的配置调用run(_:options:)方法时，会话总是重置跟踪(也就是说，此选项是隐式启用的)
        // 在这两种情况下，当你重置跟踪时，ARKit也会从会话中移除任何现有的锚。
        
        // 默认情况下，当您在之前运行或已经运行的会话上调用run(_:options:)方法时，会话将保留您之前添加的任何ARAnchor对象
        // 也就是说，AR场景中的对象保持它们在现实世界中相对于设备的明显位置(除非你启用resetTracking选项)
        // 如果更改会话配置应该使AR场景中对象的实际位置失效，则启用removeExistingAnchors选项
        // 例如，如果你在AR场景中添加了位置与现实物体相关的虚拟内容，移除这些锚点，这样你就可以重新评估合适的现实位置
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    // MARK: - 更多信息
    
    /// 展示更多信息
    @IBAction func showMoreInfo(_ sender: UIButton) {
        // 判断当前控制器是否正在直播
        let liveBroadcast = UIAlertAction(title: broadcastController.isBroadcasting ? "停止直播" : "直播", style: .default, handler: { _ in
            if self.broadcastController.isBroadcasting {
                self.stopBroadcast()
            } else {
                self.startBroadcast()
            }
        })
        
        // 判断是否需要展示前置摄像头视图
        let toggleSceneView = UIAlertAction(title: sceneView.isHidden ? "显示前置摄像头视图" : "隐藏前置摄像头视图", style: .default, handler: { _ in
            self.sceneView.isHidden = !self.sceneView.isHidden
        })
        
        // 打开设置面板
        let setting = UIAlertAction(title: "打开设置面板", style: .default, handler: { _ in
            self.present(Live2DARSettingViewController(), animated: true, completion: nil)
        })
        
        let actionSheet = UIAlertController(title: "选项", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(liveBroadcast)
        actionSheet.addAction(toggleSceneView)
        actionSheet.addAction(setting)
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))

        actionSheet.popoverPresentationController?.sourceView = sender
        show(actionSheet, sender: self)
    }
    
    // MARK: - 直播
    
    /// 开始直播
    private func startBroadcast() {
        // 用户设备上的应用程序可以共享记录功能，每个应用程序都有自己的RPScreenRecorder实例
        // 您的应用程序可以录制应用程序内部的音频和视频
        // 通过shared()函数获得记录器的引用，并使用它实现开始和停止记录功能
        // 您可以呈现一个用户界面(视图控制器)，用户可以在其中编辑和预览录音，并与其他用户共享它们
        // 一次只能有一个应用程序使用用户设备上的记录器
        // 指示麦克风当前是否启用
        RPScreenRecorder.shared().isMicrophoneEnabled = true
        
        // 一个视图控制器，显示设备上当前安装的直播服务
        RPBroadcastActivityViewController.load { broadcastAVC, error in
            if error != nil {
                print("加载广播控制器失败：" + self.errorString(error!))
                return
            }
            
            if let broadcastAVC = broadcastAVC {
                broadcastAVC.delegate = self
                self.present(broadcastAVC, animated: true, completion: nil)
            }
        }
    }
    
    /// 停止直播
    private func stopBroadcast() {
        broadcastController.finishBroadcast { error in
            if error != nil {
                print("完成直播失败：" + self.errorString(error!))
                return
            }
        }
    }
    
    // MARK: - Live2D
    
    private func connectLive2D() {
        
    }
}

// MARK: - ARSessionDelegate

extension Live2DARViewController: ARSessionDelegate {
    
    /// 当会话失败时调用此函数
    func session(_: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }

        let errorMessage = errorString(error)
        DispatchQueue.main.async {
            print("AR会话失败：" + errorMessage)
        }
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        DispatchQueue.main.async {
            self.configARFaceTracking()
        }
    }
}

// MARK: - RPBroadcastActivityViewControllerDelegate

extension Live2DARViewController: RPBroadcastActivityViewControllerDelegate {
    
    /// 在视图控制器完成时调用
    /// broadcastActivityViewController：视图控制器实例
    /// broadcastController：可用于启动和停止对用户选择的直播服务
    /// error：零错误表示用户已成功设置直播服务并准备开始直播
    func broadcastActivityViewController(_ broadcastActivityViewController: RPBroadcastActivityViewController, didFinishWith broadcastController: RPBroadcastController?, error: Error?) {
        if error != nil {
            broadcastActivityViewController.dismiss(animated: false, completion: nil)
            print("设置直播控制器失败：" + errorString(error!))
            return
        }

        broadcastActivityViewController.dismiss(animated: true) {
            broadcastController?.startBroadcast { error in
                if error != nil {
                    print("开始直播失败：" + self.errorString(error!))
                    return
                }
            }
        }
    }
}
