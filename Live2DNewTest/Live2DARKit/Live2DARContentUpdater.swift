//
//  Live2DARContentUpdater.swift
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/26.
//

import ARKit
import Foundation
import SceneKit

class ContentUpdater: NSObject, ARSCNViewDelegate {
    
    // MARK: - ARSCNViewDelegate

    /// - Tag: ARNodeTracking
    /// 当新节点映射到给定锚点时调用。
    /// @param renderer 渲染场景的渲染器。
    /// @param node 映射到锚的节点。
    /// @param anchor 添加的锚。
    func renderer(_: SCNSceneRenderer, didAdd _: SCNNode, for _: ARAnchor) {}

    /// - Tag: ARFaceGeometryUpdate
    /// 当使用给定锚点的数据更新节点时调用。
    /// @param renderer 渲染场景的渲染器。
    /// @param node 更新的节点。
    /// @param anchor 被更新的锚。
    func renderer(_: SCNSceneRenderer, didUpdate _: SCNNode, for anchor: ARAnchor) {
        
        // 当它在前置摄像头中检测到一个独特的脸时，会自动添加到它的锚定列表中一个 ARFaceAnchor 对象
        // 当你使用 ARFaceTrackingConfiguration 跟踪人脸时，ARKit 可以同时跟踪多个人脸
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        // 这个字典中的每个键表示 ARKit 识别的许多特定面部特征之一
        // 每个键的对应值是一个浮点数，表示该特性相对于其中性配置的当前位置，范围从0.0(中性)到1.0(最大移动)
        // 您可以使用混合形状系数以遵循用户面部表情的方式对2D或3D角色进行动画处理
        
        // 左眼上眼睑的闭合系数
        // 右眼上眼睑的闭合系数
        // 描述双眉内部部分向上运动的系数
        // 描述左眉外侧部分向上运动的系数
        // 右眉外侧部分向上运动的系数
        // 描述双唇收缩成张开形状的系数
        // 描述下颚开口的系数
        // 描述双颊向外运动的系数
        guard let eyeBlinkLeft = faceAnchor.blendShapes[.eyeBlinkLeft] as? Float,
            let eyeBlinkRight = faceAnchor.blendShapes[.eyeBlinkRight] as? Float,
            let browInnerUp = faceAnchor.blendShapes[.browInnerUp] as? Float,
            let browOuterUpLeft = faceAnchor.blendShapes[.browOuterUpLeft] as? Float,
            let browOuterUpRight = faceAnchor.blendShapes[.browOuterUpRight] as? Float,
            let mouthFunnel = faceAnchor.blendShapes[.mouthFunnel] as? Float,
            let jawOpen = faceAnchor.blendShapes[.jawOpen] as? Float,
            let cheekPuff = faceAnchor.blendShapes[.cheekPuff] as? Float
        else { return }
        
        // 一个4 × 4矩阵的表示
        // SceneKit使用矩阵来表示坐标空间转换，这反过来可以表示一个物体在三维空间中的组合位置、旋转或方向和比例
        // ARKit中的世界坐标空间总是遵循右对齐的约定，但是是基于会话配置的
        // 编码锚点相对于AR会话世界坐标空间的位置、方向和比例的矩阵
        let newFaceMatrix = SCNMatrix4(faceAnchor.transform)
        
        // SCNNode对象本身没有可见内容——它只表示相对于它的父节点的坐标空间变换(位置、方向和比例)
        // 要构建场景，需要使用节点的层次结构来创建其结构，然后向节点添加灯光、摄像机和几何图形来创建可见内容
        let faceNode = SCNNode()
        
        // 转换是节点旋转、位置和缩放属性的组合。默认转换是SCNMatrix4Identity
        // 当您设置此属性的值时，节点的旋转、方向、欧拉角度、位置和缩放属性将自动更改以匹配新的转换
        // 您可以对该属性值的更改进行动画化
        faceNode.transform = newFaceMatrix

        // 确定接收者的欧拉角，可以做成动画
        // 这个向量中分量的顺序与旋转轴相匹配
        // 螺距(x分量)是围绕节点的x轴旋转(以弧度为单位)
        // 偏航(y分量)是绕节点y轴的旋转(以弧度为单位)
        // 滚动(z分量)是围绕节点的z轴旋转(以弧度为单位)
        // SceneKit按照组件的相反顺序应用这些旋转：先滚动(z分量)——>再偏航(y分量)——>最后螺距(x分量)

        // 面部
        Live2DBridge.setParameterValue(.angleX, value: faceNode.eulerAngles.y * 360 / Float.pi)
        Live2DBridge.setParameterValue(.angleY, value: faceNode.eulerAngles.x * -360 / Float.pi)
        Live2DBridge.setParameterValue(.angleZ, value: faceNode.eulerAngles.z * -360 / Float.pi)

        // 身体
        Live2DBridge.setParameterValue(.bodyPosition, value: 10 + faceNode.position.z * 20)
        Live2DBridge.setParameterValue(.bodyAngleZ, value: faceNode.position.x * 20)
        Live2DBridge.setParameterValue(.bodyAngleY, value: faceNode.position.y * 20)

        // 眼球
        Live2DBridge.setParameterValue(.eyeBallX, value: faceAnchor.lookAtPoint.x * 2)
        Live2DBridge.setParameterValue(.eyeBallY, value: faceAnchor.lookAtPoint.y * 2)

        // 双眉内部部分向上运动
        Live2DBridge.setParameterValue(.browLY, value: -(0.5 - browOuterUpLeft))
        Live2DBridge.setParameterValue(.browRY, value: -(0.5 - browOuterUpRight))

        // 左、右眉外侧部分向上运动
        Live2DBridge.setParameterValue(.browLAngle, value: 16 * (browInnerUp - browOuterUpLeft) - 1.6)
        Live2DBridge.setParameterValue(.browRAngle, value: 16 * (browInnerUp - browOuterUpRight) - 1.6)

        // 左、右眼上眼睑的闭合系数
        Live2DBridge.setParameterValue(.eyeLOpen, value: 1.0 - eyeBlinkLeft)
        Live2DBridge.setParameterValue(.eyeROpen, value: 1.0 - eyeBlinkRight)

        // 下颚开口
        Live2DBridge.setParameterValue(.mouthOpenY, value: jawOpen * 1.8)
        // 双唇收缩成张开形状
        Live2DBridge.setParameterValue(.mouthForm, value: 1 - mouthFunnel * 2)

        // 双颊向外运动
        Live2DBridge.setParameterValue(.cheek, value: cheekPuff)
    }
}
