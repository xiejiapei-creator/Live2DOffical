//
//  LAppModel.h
//  Live2DNewTest
//
//  Created by 谢佳培 on 2022/8/24.
//

#ifndef LAppModel_h
#define LAppModel_h

#import <CubismFramework.hpp>
#import <Model/CubismUserModel.hpp>
#import <ICubismModelSetting.hpp>
#import <Type/csmRectF.hpp>
#import <Rendering/Metal/CubismOffscreenSurface_Metal.hpp>

/**
 * @brief 用户实际使用的模型
 *
 */
class LAppModel : public Csm::CubismUserModel
{
public:
    /**
     * @brief 构造器
     */
    LAppModel();

    /**
     * @brief 析构函数
     *
     */
    virtual ~LAppModel();

    /**
     * @brief 提供model3.json文件所在的目录和名称来生成模型
     *
     */
    void LoadAssets(const Csm::csmChar* dir, const  Csm::csmChar* fileName);

    /**
     * @brief 重新加载渲染器
     *
     */
    void ReloadRenderer();

    /**
     * @brief   模型更新处理。根据模型参数来决定绘图状态
     *
     */
    void Update();

    /**
     * @brief   绘制模型的处理。传递绘制模型的空间View-Projection矩阵。
     *
     * @param[in]  matrix  View-Projection行列
     */
    void Draw(Csm::CubismMatrix44& matrix);

    /**
     * @brief   开始运动
     *
     * @param[in]   group                       运动组名
     * @param[in]   no                          组内的号码
     * @param[in]   priority                    优先级
     * @param[in]   onFinishedMotionHandler     运动结束时调用的回调函数。如果为空，则不被调用。
     * @return                                  返回开始的运动的识别号码。作为判断单独运动是否结束的IsFinished()的自变量使用。不能开始时用“-1”
     */
    Csm::CubismMotionQueueEntryHandle StartMotion(const Csm::csmChar* group, Csm::csmInt32 no, Csm::csmInt32 priority, Csm::ACubismMotion::FinishedMotionCallback onFinishedMotionHandler = NULL);

    /**
     * @brief   开始播放随机选择的运动
     *
     * @param[in]   group                       运动组名称
     * @param[in]   priority                    优先级
     * @param[in]   onFinishedMotionHandler     在运动播放结束时调用的回调函数。如果为空，则不调用。
     * @return                                  返回已开始运动的标识号。用于确定单独的运动是否结束的IsFinished（）的参数。无法开始时为“-1”
     */
    Csm::CubismMotionQueueEntryHandle StartRandomMotion(const Csm::csmChar* group, Csm::csmInt32 priority, Csm::ACubismMotion::FinishedMotionCallback onFinishedMotionHandler = NULL);

    /**
     * @brief   设置由参数指定的表情动作
     *
     * @param   expressionID    表情动作的ID
     */
    void SetExpression(const Csm::csmChar* expressionID);

    /**
     * @brief   设置随机选择的表情和动作
     *
     */
    void SetRandomExpression();
    
    /**
     * @brief   设置角色参数值来让人物动起来
     *
     */
    void SetParameterValue(const char* paramId, Csm::csmInt32 value);
    
    /**
     * @brief   点燃运动事件
     *
     */
    virtual void MotionEventFired(const Live2D::Cubism::Framework::csmString& eventValue);

    /**
     * @brief    命中判定测试。根据指定ID的顶点列表计算矩形，判定坐标是否在矩形范围内。
     *
     * @param[in]   hitAreaName     测试命中判定的区域名称（Head / Body)，可以通过名称获取ID
     * @param[in]   x               进行判定X坐标
     * @param[in]   y               进行判定Y坐标
     */
    virtual Csm::csmBool HitTest(const Csm::csmChar* hitAreaName, Csm::csmFloat32 x, Csm::csmFloat32 y);

    /**
     * @brief   获取在绘制不同目标时使用的缓冲器
     */
    Csm::Rendering::CubismOffscreenFrame_Metal& GetRenderBuffer();

protected:
    /**
     * @brief  绘制模型的处理。传递绘制模型的空间View-Projection矩阵
     *
     */
    void DoDraw();

private:
    /**
     * @brief 加载模型
     *
     * @param[in]   setting     ICubismModelSetting 的实例
     *
     */
    void SetupModel(Csm::ICubismModelSetting* setting);

    /**
     * @brief 加载纹理
     *
     */
    void SetupTextures();

    /**
     * @brief   从组名中统一加载运动数据
     *          运动数据的名称在内部从ModelSetting获得
     *
     * @param[in]   group  运动数据的组名
     */
    void PreloadMotionGroup(const Csm::csmChar* group);

    /**
     * @brief   从组名中一次性释放运动数据
     *          运动数据的名称在内部从ModelSetting获得
     *
     * @param[in]   group  运动数据的组名
     */
    void ReleaseMotionGroup(const Csm::csmChar* group) const;

    /**
     * @brief 释放所有的运动数据
     *
     */
    void ReleaseMotions();

    /**
     * @brief 释放所有的表情数据
     *
     */
    void ReleaseExpressions();

    Csm::ICubismModelSetting* _modelSetting; /// 模型设置信息
    Csm::csmString _modelHomeDir; /// 有模型设置的目录
    
    Csm::csmFloat32 _userTimeSeconds; /// 增量时间的累计值[秒]
    
    Csm::csmVector<Csm::CubismIdHandle> _eyeBlinkIds; /// 在模型中设置的眨眼功能参数ID
    Csm::csmVector<Csm::CubismIdHandle> _lipSyncIds; /// 模型中设置的口型同步功能的参数ID
    Csm::csmMap<Csm::csmString, Csm::ACubismMotion*>   _motions; /// 加载的动作列表
    Csm::csmMap<Csm::csmString, Csm::ACubismMotion*>   _expressions; /// 已加载的面部表情列表

    Csm::csmVector<Csm::csmRectF> _hitArea;
    Csm::csmVector<Csm::csmRectF> _userArea;
    
    const Csm::CubismId* _idParamAngleX; /// 参数ID: ParamAngleX
    const Csm::CubismId* _idParamAngleY; /// 参数ID: ParamAngleX
    const Csm::CubismId* _idParamAngleZ; /// 参数ID: ParamAngleX
    const Csm::CubismId* _idParamBodyAngleX; /// 参数ID: ParamBodyAngleX
    const Csm::CubismId* _idParamEyeBallX; /// 参数ID: ParamEyeBallX
    const Csm::CubismId* _idParamEyeBallY; /// 参数ID: ParamEyeBallXY

    Live2D::Cubism::Framework::Rendering::CubismOffscreenFrame_Metal _renderBuffer;
};

#endif /* LAppModel_h */
